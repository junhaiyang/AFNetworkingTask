
#import "AFNetworkAdapter.h"
#import "AFNetworkTaskHelper.h" 

@protocol AFNetworkRequestData <NSObject>

@end
@protocol AFNetworkResponseData <NSObject>

@end

@interface AFNetworkMsg: NSObject


@property (nonatomic,assign) AFNetworkStatusCode errorCode NS_AVAILABLE_IOS(7_0);
@property (nonatomic,assign) NSInteger httpStatusCode NS_AVAILABLE_IOS(7_0);

@property (nonatomic,strong) NSDictionary *responseHeaders NS_AVAILABLE_IOS(7_0);

-(BOOL)isSuccess NS_AVAILABLE_IOS(7_0);

-(void)recyle;

@end

@interface AFNetworkContainer : NSObject
 
@property (nonatomic,assign)BOOL completionCustomQueue;

@property (nonatomic,strong)AFNetworkMsg *msg NS_AVAILABLE_IOS(7_0);

@property (nonatomic,assign) AFNetworkResponseProtocolType responseType NS_AVAILABLE_IOS(7_0);  //响应协议类型
@property (nonatomic,assign) AFNetworkRequestProtocolType  requestType NS_AVAILABLE_IOS(7_0);  //请求协议类型

 
@property (nonatomic,strong) AFNetworkSerializerAdapter  *serializerAdapter NS_AVAILABLE_IOS(7_0);  //请求协议类型
@property (nonatomic,strong) NSMutableArray<AFNetworkTaskAdapter *>  *sessionAdapters NS_AVAILABLE_IOS(7_0);  //请求协议类型
@property (nonatomic,strong) NSMutableArray<AFNetworkDataAdapter *>  *dataAdapters NS_AVAILABLE_IOS(7_0);  //请求协议类型


-(void)addSessionAdapter:(AFNetworkTaskAdapter *)adapter;
-(void)addDataAdapter:(AFNetworkDataAdapter *)adapter;


-(void)addDefaultStructure:(Class)clazz;

//执行适配器操作
-(void)sessionRequestAdapter:(NSMutableURLRequest *)request;
-(void)sessionResponseAdapter:(NSHTTPURLResponse *)response;

//返回处理结果
-(id)processSuccessWithTask:(NSURLSessionTask *)task response:(NSHTTPURLResponse *)response  originalObj:(id)originalObj;
-(void)processFailWithTask:(NSURLSessionTask *)task error:(NSError *)error;

-(void)recyle; //自定义对象时声明的新参数一定要自己回收下

@end
