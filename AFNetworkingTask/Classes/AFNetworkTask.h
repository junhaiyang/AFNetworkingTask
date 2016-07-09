 

#import "AFNetworkTaskManager.h"
#import "AFNetworkAnalysis.h"

@class AFNetworkTask;

typedef void(^AFNetworkingFinishedBlock)(AFNetworkTask *request, AFNetworkStatusCode errorCode, NSInteger httpStatusCode);  //请求协议类型

typedef void(^AFNetworkingTaskFinishedBlock)(AFNetworkMsg *msg,id originalObj,NSDictionary *jsonBody)  NS_AVAILABLE_IOS(7_0);  //请求协议类型

@interface AFNetworkTask : AFNetworkTaskManager{
    
}

-(void)finishedWithMainQueue:(AFNetworkingFinishedBlock)finishedBlock;

-(void)finishedWithCustomQueue:(AFNetworkingFinishedBlock)finishedBlock;

-(void)buildPostFileRequest:(NSString *)url files:(NSDictionary *)files;

-(void)buildPostFileRequest:(NSString *)url form:(NSDictionary *)form files:(NSDictionary *)files;

-(void)buildPostRequest:(NSString *)url form:(NSDictionary *)form;

-(void)buildPutRequest:(NSString *)url form:(NSDictionary *)form;

-(void)buildGetRequest:(NSString *)url;

-(void)buildGetRequest:(NSString *)url form:(NSDictionary *)form;

-(void)buildDeleteRequest:(NSString *)url;

-(void)prepareRequest;

-(void)processDictionary:(id)dictionary;

-(BOOL)requestSuccess;

#pragma mark - new method

+(void)defaultAnalysis:(Class)clazz;

-(instancetype)initWithTask:(AFNetworkAnalysis *)analysis  NS_AVAILABLE_IOS(7_0);

-(void)addAnalysis:(NSString *)key structure:(Class)clazz;
-(void)addAnalysis:(NSString *)key structureArray:(Class)clazz;


//解析整个返回的数据，获取值时使用 [jsonBody objectForKey:kAllBodyObjectInfo]
-(void)addStructure:(Class)clazz;
-(void)addStructureArray:(Class)clazz;

//执行操作
-(void)executeGet:(NSString *)url  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executeDelete:(NSString *)url  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);

-(void)executeGet:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executePUT:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executePATCH:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executePOST:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executePostFile:(NSString *)url files:(NSDictionary *)files finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executePostFile:(NSString *)url form:(NSDictionary *)form  files:(NSDictionary *)files finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executeDelete:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executeGetFile:(NSString *)url form:(NSDictionary *)form  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);


-(void)executeGet:(NSString *)url data:(id<AFNetworkRequestData>)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executePUT:(NSString *)url data:(id<AFNetworkRequestData>)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executePATCH:(NSString *)url data:(id<AFNetworkRequestData>)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executePOST:(NSString *)url data:(id<AFNetworkRequestData>)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executePostFile:(NSString *)url data:(id<AFNetworkRequestData>)data  files:(NSDictionary *)files finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executeDelete:(NSString *)url data:(id<AFNetworkRequestData>)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);
-(void)executeGetFile:(NSString *)url data:(id<AFNetworkRequestData>)data  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock NS_AVAILABLE_IOS(7_0);

-(void)cancel NS_AVAILABLE_IOS(7_0);
-(void)recyle NS_AVAILABLE_IOS(7_0);



@end
