# 一个协议独立文件方式 


####基本请求

######继承 AFNetworkTask 类


	#import "AFNetworkTask.h"

	@interface AFNetworkSample : AFNetworkTask{
     
	}

	@end
	
	
	@implementation AFNetworkSample
	
	//默认不用指定格式类型
	- (instancetype)init
	{
    	self = [super init];
    	if (self) { 
        	self.responseType = AFNetworkResponseProtocolTypeJSON; //默认为JSON
        	self.requestType = AFNetworkRequestProtocolTypeNormal;//默认为表单
    	}
    	return self;
	}
     
     //封装请求，该方法必须实现
     -(void)prepareRequest{
    
    	NSString *url = @"http://xxxxx";
    	NSDictionary *form = @{};
    	[self buildGetRequest:url form:form];
    	
	}

	//处理返回结果，该方法必须实现
	-(void)processDictionary:(id)dictionary{
	
	
		//获取返回的头字典数据
		//  id value =   [self.responseHeaders objectForKey:@"xxx"];
	
	}
	
	//冲处理请求头，可以不实现该方法
	-(void)buildCommonHeader:(AFHTTPRequestSerializer *)requestSerializer{
    	[requestSerializer setValue:@"xxx" forHTTPHeaderField:@"user-agent"];
    }

	@end
 
          
  
###### 格式说明  
   		self.responseType =  AFNetworkResponseProtocolTypeNormal ;     //响应协议类型， 无任何格式的字符串流方式
   		self.responseType =  AFNetworkResponseProtocolTypeJSON ;     //响应协议类型， JSON格式符串流方式
   		self.responseType =  AFNetworkResponseProtocolTypeFile ;     //响应协议类型， 文件流方式 
   		 
    	self.requestType = AFNetworkRequestProtocolTypeNormal;      //请求协议类型，标准提交
    	self.requestType = AFNetworkRequestProtocolTypeJSON;        //请求协议类型，发JSON格式提交
   		     	
###### 回调说明

* 回调是主线程
	* finishedWithMainQueue:^(AFNetworkTask *request, AFNetworkStatusCode errorCode, NSInteger httpStatusCode)
* 回调不是主线程
	* finishedWithCustomQueue:^(AFNetworkTask *request, AFNetworkStatusCode errorCode, NSInteger httpStatusCode)

* 参数说明
	* request：当前对象
	* errorCode：内部定义的错误码  
	* httpStatusCode：http 对应的状态码
	
  
	
	
###### 操作方法实例
* 主线程回调

		AFNetworkSample *protocol =[AFNetworkSample new];
		// ... 添加值
		
    	[protocol finishedWithMainQueue:^(AFNetworkTask *request, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
    	
          // ... 其它逻辑处理
          
    	}];
* 非主线程回调

		AFNetworkSample *protocol =[AFNetworkSample new];
		// ... 添加值
		
    	[protocol finishedWithCustomQueue:^(AFNetworkTask *request, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
    	
          // ... 其它逻辑处理
          
    	}];
 
 