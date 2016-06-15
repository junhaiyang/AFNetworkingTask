 

#import "AFNetworkTaskManager.h"
#import "AFNetworkAnalysis.h"

@class AFNetworkTask;

typedef void(^AFNetworkingFinishedBlock)(AFNetworkTask *request, AFNetworkStatusCode errorCode, NSInteger httpStatusCode)  NS_DEPRECATED_IOS(7_0,7_0);  //请求协议类型

typedef void(^AFNetworkingTaskFinishedBlock)(AFNetworkMsg *msg,id originalObj,id obj,...)  NS_AVAILABLE_IOS(7_0);  //请求协议类型

@interface AFNetworkTask : NSObject{
    
    AFNetworkTaskManager *manager; 

}

-(void)finishedWithMainQueue:(AFNetworkingFinishedBlock)finishedBlock  NS_DEPRECATED_IOS(7_0,7_0);

-(void)finishedWithCustomQueue:(AFNetworkingFinishedBlock)finishedBlock  NS_DEPRECATED_IOS(7_0,7_0);

-(void)buildPostFileRequest:(NSString *)url files:(NSDictionary *)files NS_DEPRECATED_IOS(7_0,7_0);

-(void)buildPostFileRequest:(NSString *)url form:(NSDictionary *)form files:(NSDictionary *)files NS_DEPRECATED_IOS(7_0,7_0);

-(void)buildPostRequest:(NSString *)url form:(NSDictionary *)form NS_DEPRECATED_IOS(7_0,7_0);

-(void)buildGetRequest:(NSString *)url NS_DEPRECATED_IOS(7_0,7_0);

-(void)buildGetRequest:(NSString *)url form:(NSDictionary *)form NS_DEPRECATED_IOS(7_0,7_0);

-(void)buildDeleteRequest:(NSString *)url NS_DEPRECATED_IOS(7_0,7_0);

-(void)prepareRequest NS_DEPRECATED_IOS(7_0,7_0);

-(void)processDictionary:(id)dictionary NS_DEPRECATED_IOS(7_0,7_0);

-(BOOL)requestSuccess NS_DEPRECATED_IOS(7_0,7_0);

#pragma mark - new method

-(instancetype)initWithTask:(AFNetworkAnalysis *)analysis  NS_AVAILABLE_IOS(7_0);

-(instancetype)initWithSerialize:(Class)clazz  NS_AVAILABLE_IOS(7_0);

-(void)setAnalysis:(AFNetworkAnalysis *)analysis;  //完全自定义结果处理
-(void)setSerialize:(Class)clazz;    //序列化结果
-(void)setMsgSerialize:(Class)clazz; //重定义  AFNetworkMsg

//切换到主线程
-(void)serializeFinishedInMainQueue;
//
//-(void)finishedTaskWithMainQueue:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
//
//-(void)finishedTaskWithCustomQueue:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);

//执行操作
-(void)executeGet:(NSString *)url  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executeDelete:(NSString *)url  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);

-(void)executeGet:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executePOST:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executePostFile:(NSString *)url files:(NSDictionary *)files finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executePostFile:(NSString *)url form:(NSDictionary *)form  files:(NSDictionary *)files finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);

//-(void)finishedTaskWithCustomQueue:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);

-(void)cancel NS_AVAILABLE_IOS(7_0);



@end
