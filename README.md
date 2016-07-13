# AFNetworkingTask
AFNetworking  OC   Sample 


####基本需求
* 简化网络处理和返回JSON 结果处理
* 根据用户提前制定的json映射规则，直接解析出对应的对象返回
* 支持图片格式： JPEG、PNG、GIF、WEBP、BMP


####使用方法
###### 引用

		source 'https://github.com/CocoaPods/Specs.git'
		source 'https://github.com/junhaiyang/Specs.git'

		pod 'AFNetworkingTask', '~> 1.2'
 

	
		#import "AFNetworkTask.h"

###### 基本请求
 
 		//声明对象
    	AFNetworkTask *task =[[AFNetworkTask alloc] init];
    	//解析返回json中的result数据，构造成 UserData 对象返回
    	[task addAnalysis:@"result" structure:[UserData class]];
    	// originalObj 为原始数据对象
    	// jsonBody 为解析出来的返回对象
    	[task executeGet:@"http://xxxxxxxx" finishedBlock:^(AFNetworkMsg *msg, id originalObj, NSDictionary *jsonBody) { 
  			UserData *userData = [jsonBody objectForKey:@"result"];
  			//对象
  			
  			NSDictionary *resultDictionary = [originalObj objectForKey:@"result"];
  			//原始json 字典
  			
  			
         	NSLog(@"finish .........");
    	}];
    	
    	----------------------------------------------------------------------
    	
        AFNetworkTask *task1 =[[AFNetworkTask alloc] init];
    	[task1 addAnalysis:@"result" structure:[UserData class]];
    	
        NSDictionary *params =@{@"count":@(123),@"name":@"aaa"};
    	[task1 executePOST:@"http://xxxxxx" form:params finishedBlock:^(AFNetworkMsg *msg, id originalObj, NSDictionary *jsonBody) {
  			UserData *userData = [jsonBody objectForKey:@"result"];
  			//对象
  			
  			NSDictionary *resultDictionary = [originalObj objectForKey:@"result"];
  			//原始json 字典
            
            NSLog(@"finish .........%@",jsonBody);
        }];
         
    	
* 默认请求是JSON格式解析，所以上面的方法会无任何返回结果
  
###### 自定义返回对象
* 实例化说明
    
    	//解析结构声明
   		AFNetworkAnalysis *analysis = [AFNetworkAnalysis defaultAnalysis];
   		analysis.responseType =  AFNetworkResponseProtocolTypeNormal ;     //响应协议类型， 无任何格式的字符串流方式
   		analysis.responseType =  AFNetworkResponseProtocolTypeJSON ;     //响应协议类型， JSON格式符串流方式
   		analysis.responseType =  AFNetworkResponseProtocolTypeFile ;     //响应协议类型， 文件流方式 
   		 
    	analysis.requestType = AFNetworkRequestProtocolTypeNormal;      //请求协议类型，标准提交
    	analysis.requestType = AFNetworkRequestProtocolTypeJSON;        //请求协议类型，发JSON格式提交
   		
   		//处理结果是否在非主线程中回调，默认是主线程
   		analysis.completionCustomQueue = YES; 
   		
   		//基本错误码解析，同时会解析 返回json 根结构上的  code,message 参数，如果您的参数名不同，可以使用 MJExtension 来做参数名映射
   		// 当前对象不用声明，会自动初始化
   		//例如： {"code":200,"message":"no error","result":{"name":"12444","title":"12444"}}
   		// 即为将其中的 code、message 解析到对象中
   		//analysis.msg = [AFNetworkMsg new];  
   		  
   		
   		//注意： 如果 {"msg":{"code":200,"message":"no error","result":{"name":"12444","title":"12444"}}} 将无法解析上面的 msg 和自定义数据结构，当前方法只能解析根结构上的数据
   		 
   		
    	AFNetworkTask *task =[[AFNetworkTask alloc] initWithTask:analysis]; 
    	
* 自定义说明
	* 编写对象 AFNetworkAnalysisExt 继承  AFNetworkAnalysis 类
	* AFNetworkTask 类中注册 静态 类  [AFNetworkTask defaultAnalysis:[AFNetworkAnalysisExt class]]
	*   AFNetworkTask *task =[[AFNetworkTask alloc] init]   使用时即默认使用自定义的解析类
	
			
			@interface AFNetworkAnalysisExt : AFNetworkAnalysis
			@end
			
			@implementation AFNetworkCustomQueueAnalysis

			-(void)analysisBody{
				[super analysisBody];
				
				//直接解析  self.originalBody 数据  判断msg的 code 或者 httpStatusCode 来判断是否用户未登录，然后发送对应的退出应用通知
			}
			
			//返回自定义的request header数据
			-(NSMutableDictionary *)requestHeaders{
				//TODO
    			return nil;
			}

			-(void)recyle{
    			[super recyle];
   				... 回收掉自己定义的新数据
			}

			@end
			
			
			[AFNetworkTask defaultAnalysis:[AFNetworkAnalysisExt class]];
			
			
			AFNetworkTask *task =[[AFNetworkTask alloc] init];
			.....
			
			
			AFNetworkTask *task2 =[[AFNetworkTask alloc] init];
			.....
			
			
			AFNetworkTask *task3 =[[AFNetworkTask alloc] init];
			.....
			
    	
###### 回调说明

* finishedBlock:^(AFNetworkMsg *msg, id originalObj, NSDictionary *jsonBody)
* msg：包含服务器的错误码和http 错误码 和 本地处理错误码，以及 response headers 数据
* originalObj：返回的原始数据，根据 analysis.responseType 不同回事不同的格式类型
	* AFNetworkResponseProtocolTypeNormal：字符串
	* AFNetworkResponseProtocolTypeJSON：字典
	* AFNetworkResponseProtocolTypeFile：文件

* jsonBody：解析出来的json 实例化对象，可能为空，前提是得自行去配置 addAnalysis:structure: 方法
	
###### addAnalysis:structure:  和 addAnalysis:structureArray: 方法说明
* 可以在两个地方调用添加方法： AFNetworkTask 和 AFNetworkAnalysis 均可以
* 第一个参数 是字符串，key，对应json 数据中的key值，返回的 jsonBody 中也是使用此key来保存解析实例化数据
* 第二个参数 为 class 声明，为单个实例化对象的解析，例如：[UserData class] 
	
		 
   	  // 声明 单个对象解析
      [task addAnalysis:@"result" structure:[UserData class]];
    		 
    		 
       最终返回 UserData 的实例化对象   
       UserData *value = [jsonBody objectForKey:@"result"];
    		
    		
   		
  	  //声明 列表对象解析

       [task addAnalysis:@"result" structureArray:[UserData class]];
       //最终返回 UserData 的实例化列表对象   
       NSArray<UserData *> *value = [jsonBody objectForKey:@"result"];
      
###### addStructure:  和 addStructureArray: 方法说明  
* 解析整个返回的数据，获取值时使用 [jsonBody objectForKey:kAllBodyObjectInfo]

		
   	  // 声明 单个对象解析
      [task addStructure:[UserData class]];
    		 
    		 
       最终返回 UserData 的实例化对象   
       UserData *value = [jsonBody objectForKey:kAllBodyObjectInfo];
    		
    		
   		
 	  //声明 列表对象解析

       [task addStructureArray:[UserData class]];
       //最终返回 UserData 的实例化列表对象   
       NSArray<UserData *> *value = [jsonBody objectForKey:kAllBodyObjectInfo];
 

			
			 
###### 具体实例化对象与 json 的解析映射规则
* json 映射 使用的 MJExtension 框架，具体规则 参考 [MJExtension](https://github.com/CoderMJLee/MJExtension)
	
###### 请求时添加新的header问题
* 看 【自定义返回对象】 的 【自定义说明】 
	
	
###### 操作方法列表

		//get 请求
		-(void)executeGet:(NSString *)url  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0); 
		-(void)executeGet:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
		
		//post 请求
		-(void)executePOST:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
		
		//put 请求
		-(void)executePUT:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
		
		//patch 请求
		-(void)executePATCH:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
		
		//文件上传
		-(void)executePostFile:(NSString *)url files:(NSDictionary *)files finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
		//文件和参数混合上传
		-(void)executePostFile:(NSString *)url form:(NSDictionary *)form  files:(NSDictionary *)files finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
		
		// delete 请求
		-(void)executeDelete:(NSString *)url  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
		-(void)executeDelete:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
		//下载文件
		-(void)executeGetFile:(NSString *)url form:(NSDictionary *)form  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);

		//取消请求
		-(void)cancel NS_AVAILABLE_IOS(7_0);
		
		
###### 直接对象请求模式

		
		//自己继承实现该协议就行，对象只能继承自 NSObject
		@interface MyData : NSObject<AFNetworkRequestData>

		@end

		MyData *data = [MyData new]; 

		
        AFNetworkTask *task1 =[[AFNetworkTask alloc] init];
    	[task1 addAnalysis:@"result" structure:[UserData class]];
    	 
    	[task1 executePOST:@"http://xxxxxx" data:data finishedBlock:^(AFNetworkMsg *msg, id originalObj, NSDictionary *jsonBody) {
  			UserData *userData = [jsonBody objectForKey:@"result"];
  			//对象
  			
  			NSDictionary *resultDictionary = [originalObj objectForKey:@"result"];
  			//原始json 字典
            
            NSLog(@"finish .........%@",jsonBody);
        }];

	
		-(void)executeGet:(NSString *)url data:(id<AFNetworkRequestData>)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
		-(void)executePUT:(NSString *)url data:(id<AFNetworkRequestData>)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
		-(void)executePATCH:(NSString *)url data:(id<AFNetworkRequestData>)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
		-(void)executePOST:(NSString *)url data:(id<AFNetworkRequestData>)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
		-(void)executePostFile:(NSString *)url data:(id<AFNetworkRequestData>)data  files:(NSDictionary *)files finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
		-(void)executeDelete:(NSString *)url data:(id<AFNetworkRequestData>)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
		-(void)executeGetFile:(NSString *)url data:(id<AFNetworkRequestData>)data  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
 