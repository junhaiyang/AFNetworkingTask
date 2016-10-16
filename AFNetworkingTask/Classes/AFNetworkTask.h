 

#import <Foundation/Foundation.h>
#import "AFNetworkTaskHelper.h"
#import "AFNetworkTaskSession.h"
#import "AFNetworkAdapter.h"


typedef void (^AFNetworkingTaskDataBlock)(AFNetworkMsg *  _Nonnull msg,id  _Nullable originalObj,id  _Nullable data)  NS_AVAILABLE_IOS(7_0);  //请求协议类型
 

@interface AFNetworkMsg: NSObject


@property (nonatomic,assign) AFNetworkStatusCode errorCode;
@property (nonatomic,assign) NSInteger httpStatusCode;

@property (nonatomic,strong) NSDictionary *_Nullable responseHeaders; 

-(BOOL)isSuccess NS_AVAILABLE_IOS(7_0);

-(void)recyle;

@end

@interface AFNetworkTask : NSObject


- (instancetype _Nonnull)initWithTaskSession:(AFNetworkTaskSession * _Nonnull)session;


//添加数据处理适配器
-(void)addDataAdapter:(AFNetworkDataAdapter * _Nonnull)adapter;
//添加对象解析适配器
-(void)addDefaultStructure:(Class _Nonnull)clazz;

//简化数据处理回调
-(void)addDataBlock:(AFNetworkingTaskDataBlock _Nullable)dataBlock;


#pragma mark - GET

-(void)GET:(NSString * _Nonnull)url  finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)GET:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)GET:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

#pragma mark - POST

-(void)POST:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)POST:(NSString * _Nonnull)URLString form:(NSDictionary *  _Nullable)form finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)POST:(NSString * _Nonnull)URLString data:(id<AFNetworkRequestData> _Nullable)data files:(NSDictionary * _Nullable)files finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)POST:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form files:(NSDictionary * _Nullable)files finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)POST:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form files:(NSDictionary * _Nullable)files progressBlock:(AFNetworkTaskProgressBlock _Nullable)progressBlock finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

#pragma mark - PUT

-(void)PUT:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)PUT:(NSString * _Nonnull)URLString form:(NSDictionary *  _Nullable)form finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)PUT:(NSString * _Nonnull)URLString data:(id<AFNetworkRequestData> _Nullable)data files:(NSDictionary * _Nullable)files finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)PUT:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form files:(NSDictionary * _Nullable)files finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)PUT:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form files:(NSDictionary * _Nullable)files progressBlock:(AFNetworkTaskProgressBlock _Nullable)progressBlock finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

#pragma mark - PATCH

-(void)PATCH:(NSString * _Nonnull)url finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)PATCH:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)PATCH:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;


#pragma mark - DELETE

-(void)DELETE:(NSString * _Nonnull)url finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)DELETE:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)DELETE:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;


#pragma mark - DOWNLOAD

-(void)DOWNLOAD:(NSString * _Nonnull)url  finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)DOWNLOAD:(NSString * _Nonnull)URLString data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)DOWNLOAD:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)DOWNLOAD:(NSString * _Nonnull)URLString data:(id<AFNetworkRequestData> _Nullable)data progressBlock:(AFNetworkTaskProgressBlock _Nullable)progressBlock finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)DOWNLOAD:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form progressBlock:(AFNetworkTaskProgressBlock _Nullable)progressBlock finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;



-(void)cancel;

@end
