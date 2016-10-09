
#import "AFNetworkTaskHelper.h"

@class AFNetworkSerializerAdapter;
@class AFNetworkSessionAdapter;
@class AFNetworkDataAdapter;
@class AFNetworkDataBlockAdapter;

@interface AFNetworkMsg: NSObject


@property (nonatomic,assign) AFNetworkStatusCode errorCode NS_AVAILABLE_IOS(7_0);
@property (nonatomic,assign) NSInteger httpStatusCode NS_AVAILABLE_IOS(7_0);

@property (nonatomic,strong) NSDictionary *_Nullable responseHeaders NS_AVAILABLE_IOS(7_0);

-(BOOL)isSuccess NS_AVAILABLE_IOS(7_0);

-(void)recyle;

@end


typedef _Nullable id (^AFNetworkingTaskDataBlock)(AFNetworkMsg *  _Nonnull msg,id  _Nullable originalObj,id  _Nullable data)  NS_AVAILABLE_IOS(7_0);  //请求协议类型

@interface AFNetworkContainer : NSObject
 
@property (nonatomic,assign)BOOL completionCustomQueue;

@property (nonatomic,strong)AFNetworkMsg * _Nonnull msg NS_AVAILABLE_IOS(7_0);

@property (nonatomic,assign) AFNetworkProtocolType responseType NS_AVAILABLE_IOS(7_0);  //响应协议类型
@property (nonatomic,assign) AFNetworkProtocolType  requestType NS_AVAILABLE_IOS(7_0);  //请求协议类型

 
@property (nonatomic,strong) AFNetworkSerializerAdapter  * _Nonnull serializerAdapter NS_AVAILABLE_IOS(7_0);  //请求协议类型


-(void)addSessionAdapter:(AFNetworkSessionAdapter * _Nonnull)adapter;
-(void)addDataAdapter:(AFNetworkDataAdapter * _Nonnull)adapter;


-(void)addDefaultStructure:(Class _Nonnull)clazz;
-(void)addDataBlock:(AFNetworkingTaskDataBlock _Nullable)dataBlock;

-(void)recyle; //自定义对象时声明的新参数一定要自己回收下

@end
