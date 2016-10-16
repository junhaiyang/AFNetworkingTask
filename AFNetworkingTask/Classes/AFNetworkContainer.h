
#import "AFNetworkTaskHelper.h"

@class AFNetworkSerializerAdapter;
@class AFNetworkSessionAdapter; 

@class AFNetworkMsg;



@interface AFNetworkContainer : NSObject
 
@property (nonatomic,assign)BOOL completionCustomQueue;

@property (nonatomic,assign) AFNetworkProtocolType responseType;  //响应协议类型
@property (nonatomic,assign) AFNetworkProtocolType  requestType;  //请求协议类型

 
@property (nonatomic,strong) AFNetworkSerializerAdapter  * _Nonnull serializerAdapter;  //请求协议类型

//执行适配器操作
-(void)sessionRequestAdapter:(NSMutableURLRequest * _Nonnull)request;
-(void)sessionResponseAdapter:(NSHTTPURLResponse * _Nonnull)response msg:(AFNetworkMsg * _Nullable)msg;


-(void)addSessionAdapter:(AFNetworkSessionAdapter * _Nonnull)adapter;

-(void)recyle; //自定义对象时声明的新参数一定要自己回收下

@end
