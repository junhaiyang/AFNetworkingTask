# AFNetworkingTask(3.0.1) for OC
 
####基本请求
 
		#import "AFNetworkTask.h"
		
 		//声明构造 
        static AFNetworkTaskSession* defaultTaskSession = nil; 
        AFNetworkContainer *container =[[AFNetworkContainer alloc] init];
        container.responseType = AFNetworkProtocolTypeJSON; 
        [container addSessionAdapter:[MyAFNetworkSessionAdapter new]];
        
        defaultTaskSession =  [[AFNetworkTaskSession alloc] initWithContainer:container];
      
 		
    AFNetworkTask *task1 =[[AFNetworkTask alloc] initWithTaskSession:defaultTaskSession];
    	//返回数据解析构造器，可自定义实现 
    [task1 addDefaultStructure:[UserData class]];
    	 
    	
    	// originalObj 为原始数据对象
    	// data 为解析出来的返回对象
    	[task GET:@"http://xxxxxxxx" finishedBlock:^(AFNetworkMsg * _Nonnull msg, id  _Nullable originalObj, id  _Nullable data) { 
  			UserData *userData = data;
  			//对象
  			
  			NSDictionary *resultDictionary = [originalObj objectForKey:@"result"];
  			//原始json 字典
  			
  			
         	NSLog(@"finish .........");
    	}];
    	 
         
    	
* 默认请求是JSON格式解析，所以上面的方法会无任何返回结果
  
###### 自定义返回对象
* 实例化说明
    
    	//解析结构声明
   		AFNetworkContainer *container = [AFNetworkContainer new];
   		container.responseType =  AFNetworkProtocolTypeNormal ;     //响应协议类型， 无任何格式的字符串流方式
   		container.responseType =  AFNetworkProtocolTypeJSON ;     //响应协议类型， JSON格式符串流方式 
   		 
    	container.requestType = AFNetworkProtocolTypeNormal;      //请求协议类型，标准提交
    	container.requestType = AFNetworkProtocolTypeJSON;        //请求协议类型，发JSON格式提交
   		
   		//处理结果是否在非主线程中回调，默认是主线程
   		container.completionCustomQueue = YES; 
   		 
			
    	
###### 回调说明

* finishedBlock:^(AFNetworkMsg *msg, id originalObj, id<AFNetworkResponseData> data)
* msg：包含服务器的错误码和http 错误码 和 本地处理错误码，以及 response headers 数据
* originalObj：返回的原始数据，根据 container.responseType 不同回事不同的格式类型
	* AFNetworkProtocolTypeNormal：字符串
	* AFNetworkProtocolTypeJSON：字典 

* data：解析出来的实例化对象，可能为空


###### 适配器(Adapter)说明

* 有三种适配器 AFNetworkSerializerAdapter，AFNetworkSessionAdapter，AFNetworkDataAdapter
* AFNetworkSerializerAdapter
	* 只能有一个实现，用于生成，请求和响应序列化处理
* AFNetworkSessionAdapter
	* 拦截request和response对象处理， 可以有多个实现，会按照顺序依次执行
* AFNetworkDataAdapter
	* 获取到的数据解析适配器，可以添加多个，会按照顺序依次执行，当出现返回值为 AFNetworkDataTypeData 时停止执行，并直接使用返回结果
		
		
			//自定义数据解析器
    		AFNetworkDataCovertModelAdapter *dataAdapter =[AFNetworkDataCovertModelAdapter new]; 
    		//解析返回json中的result数据，构造成 UserData 对象返回
    		[dataAdapter addStructure:[UserData class]];
    
    		[task addDataAdapter:dataAdapter];

	 
			
			 
###### 具体实例化对象与 json 的解析映射规则
* json 映射 使用的 MJExtension 框架，具体规则 参考 [MJExtension](https://github.com/CoderMJLee/MJExtension)
	
###### 请求时添加新的header问题
* 自定义 AFNetworkTaskAdapter   

			@interface MyAFNetworkSessionAdapter : AFNetworkSessionAdapter

			@end
			@implementation MyAFNetworkSessionAdapter
 
			-(void)sessionRequest:(NSMutableURLRequest * _Nonnull)request{
    			//TODO add header 
    			[request addValue:@"" forHTTPHeaderField:@""]; 
    
			}
			-(void)sessionResponse:(NSHTTPURLResponse * _Nonnull)response msg:(AFNetworkMsg * _Nullable)msg{
    
			} 

			@end


			MyAFNetworkSessionAdapter *taskAdapter =[MyAFNetworkSessionAdapter new]; 

 
    		[container addSessionAdapter:taskAdapter];
    		
    		
	

###### 拦截并处理数据结果 
		
		[task addDataBlock:^(AFNetworkMsg * _Nonnull msg, id  _Nullable originalObj, id  _Nullable data) {
         
         
    }];
		
###### 直接对象请求模式

		
		//自己继承实现该协议就行，对象只能继承自 NSObject
		@interface MyData : NSObject<AFNetworkRequestData>

		@end

		MyData *myData = [MyData new]; 

        static AFNetworkTaskSession* defaultTaskSession = nil; 
        AFNetworkContainer *container =[[AFNetworkContainer alloc] init];
        container.responseType = AFNetworkProtocolTypeJSON; 
        [container addSessionAdapter:[MyAFNetworkSessionAdapter new]];
        
        defaultTaskSession =  [[AFNetworkTaskSession alloc] initWithContainer:container];
        
 		
        AFNetworkTask *task1 =[[AFNetworkTask alloc] initWithTaskSession:defaultTaskSession];
    	 
    	[task1 addDefaultStructure:[UserData class]];  
    	
    	[task1 POST:@"http://xxxxxx" data:myData finishedBlock:^(AFNetworkMsg * _Nonnull msg, id  _Nullable originalObj, id  _Nullable data) { 
  			UserData *userData = data;
  			//对象
  			
  			NSDictionary *resultDictionary = [originalObj objectForKey:@"result"];
  			//原始json 字典
            
            NSLog(@"finish .........%@",jsonBody);
        }];
  

