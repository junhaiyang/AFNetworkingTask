
#import "AFNetworkTaskHelper.h" 

@class AFNetworkSerializerAdapter;
@class AFNetworkTaskAdapter;
@class AFNetworkDataAdapter;
 

@interface AFNetworkMsg: NSObject


@property (nonatomic,assign) AFNetworkStatusCode errorCode NS_AVAILABLE_IOS(7_0);
@property (nonatomic,assign) NSInteger httpStatusCode NS_AVAILABLE_IOS(7_0);

@property (nonatomic,strong) NSDictionary *_Nullable responseHeaders NS_AVAILABLE_IOS(7_0);

-(BOOL)isSuccess NS_AVAILABLE_IOS(7_0);

-(void)recyle;

@end

@interface AFNetworkContainer : NSObject
 
@property (nonatomic,assign)BOOL completionCustomQueue;

@property (nonatomic,strong)AFNetworkMsg * _Nonnull msg NS_AVAILABLE_IOS(7_0);

@property (nonatomic,assign) AFNetworkResponseProtocolType responseType NS_AVAILABLE_IOS(7_0);  //响应协议类型
@property (nonatomic,assign) AFNetworkRequestProtocolType  requestType NS_AVAILABLE_IOS(7_0);  //请求协议类型

 
@property (nonatomic,strong) AFNetworkSerializerAdapter  * _Nonnull serializerAdapter NS_AVAILABLE_IOS(7_0);  //请求协议类型
@property (nonatomic,strong) NSMutableArray<AFNetworkTaskAdapter *>  * _Nonnull taskAdapters NS_AVAILABLE_IOS(7_0);  //请求协议类型
@property (nonatomic,strong) NSMutableArray<AFNetworkDataAdapter *>  * _Nonnull dataAdapters NS_AVAILABLE_IOS(7_0);  //请求协议类型


-(void)addTaskAdapter:(AFNetworkTaskAdapter * _Nonnull)adapter;
-(void)addDataAdapter:(AFNetworkDataAdapter * _Nonnull)adapter;


-(void)addDefaultStructure:(Class _Nonnull)clazz;

//执行适配器操作
-(void)taskRequestAdapter:(NSMutableURLRequest * _Nonnull)request;
-(void)taskResponseAdapter:(NSHTTPURLResponse * _Nonnull)response;

//返回处理结果
-(id _Nullable)processSuccessWithTask:(NSURLSessionTask * _Nonnull)task response:(NSHTTPURLResponse * _Nonnull)response  originalObj:(id _Nullable)originalObj;
-(void)processFailWithTask:(NSURLSessionTask * _Nonnull)task error:(NSError *_Nullable)error;

-(void)recyle; //自定义对象时声明的新参数一定要自己回收下

@end
