# AFNetworkingTask
AFNetworking  OC   Sample 


####基本需求
* 简化网络处理和返回JSON 结果处理
* 根据用户提前制定的json映射规则，直接解析出对应的对象返回


####使用方法
* 引用

		source 'https://github.com/CocoaPods/Specs.git'
		source 'https://github.com/junhaiyang/Specs.git'

		pod 'AFNetworkingTask', '~> 1.1'

* 引用头文件 

	
		#import "AFNetworkTask.h"

* 基本请求
 
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
    	
    * 默认请求是JSON格式解析，所以上面的方法会无任何返回结果
  
* 自定义返回对象
    
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
   		
   		//添加json根结构参数解析规则
   		//例如： {"code":200,"message":"no error","result":{"name":"12444","title":"12444"}}
   		// 即为将其中的 result 解析到  UserData 对象中 并放置到 analysis.body 字典中
    	[analysis addAnalysis:@"result" structure:[UserData class]];
    	
    	//上面方法等同于 
    	[task addAnalysis:@"result" structure:[UserData class]];
   		
   		//注意： 如果 {"msg":{"code":200,"message":"no error","result":{"name":"12444","title":"12444"}}} 将无法解析上面的 msg 和自定义数据结构，当前方法只能解析根结构上的数据
   		 
   		
    	AFNetworkTask *task =[[AFNetworkTask alloc] initWithTask:analysis]; 
    	
    	
* 回调说明
	* finishedBlock:^(AFNetworkMsg *msg, id originalObj, NSDictionary *jsonBody)
	* msg：包含服务器的错误码和http 错误码 和 本地处理错误码，以及 response headers 数据
	* originalObj：返回的原始数据，根据 analysis.responseType 不同回事不同的格式类型
		* AFNetworkResponseProtocolTypeNormal：字符串
		* AFNetworkResponseProtocolTypeJSON：字典
		* AFNetworkResponseProtocolTypeFile：文件

	* jsonBody：解析出来的json 实例化对象，可能为空，前提是得自行去配置 addAnalysis:structure: 方法
	
* addAnalysis:structure: 方法说明
	* 可以在两个地方调用添加方法： AFNetworkTask 和 AFNetworkAnalysis 均可以
	* 第一个参数 是字符串，key，对应json 数据中的key值，返回的 jsonBody 中也是使用此key来保存解析实例化数据
	* 第二个参数
		* 可以为 class 声明，为单个实例化对象的解析，例如：[UserData class]
		* 可以为 数组 声明，数组最多为两个参数，最少为一个参数
			* 第一个参数 ：为 实例化对象的类声明
			* 第二个参数 ：为 实例化对象的集合类型声明，可以使用两种：[NSArray class] 或者 [NSObject class] 
			* 数组如果只有一个参数的时候即默认集合类型声明 [NSObject class]
	* 例子说明
	
		
   		 
   		
   			// 声明 单个对象解析
    		[task addAnalysis:@"result" structure:[UserData class]];
    		
    		上面的例子也等同于
    		[task addAnalysis:@"result" structure:@[[UserData class]]];
    		和
    		[task addAnalysis:@"result" structure:@[[UserData class],[NSObject class]]];
    		 
    		最终返回 UserData 的实例化对象   
            UserData *value = [jsonBody objectForKey:@"result"];
    		
    		
   		
   			// 声明 列表对象解析
    		[task addAnalysis:@"result" structure:@[[UserData class],[NSArray class]]];
    		最终返回 UserData 的实例化列表对象   
            NSArray<UserData *> *value = [jsonBody objectForKey:@"result"];
			
			 
* 具体实例化对象与 json 的解析映射规则
	* json 映射 使用的 MJExtension 框架，具体规则 参考 [MJExtension](https://github.com/CoderMJLee/MJExtension)
	
* 请求时添加新的header问题
	* 赋值给 AFNetworkAnalysis 类  requestHeaders  对象
	* analysis.requestHeaders =@{@"x":@"121212"};
	
	
* 操作方法列表

		//get 请求
		-(void)executeGet:(NSString *)url  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0); 
		-(void)executeGet:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
		
		//post 请求
		-(void)executePOST:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
		
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
 