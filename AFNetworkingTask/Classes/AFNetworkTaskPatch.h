
 

#import <Foundation/Foundation.h> 
#import "AFNetworkContainer.h"
#import "AFNetworkTaskHelper.h"

#import <AFNetworking/AFHTTPSessionManager.h>

@class AFNetworkMsg;
@class AFHTTPSessionManager;

typedef void(^AFNetworkingTaskFinishedBlock)(AFNetworkMsg *  _Nonnull msg,id  _Nullable originalObj,id  _Nullable data)  NS_AVAILABLE_IOS(7_0);  //请求协议类型

typedef void(^AFNetworkTaskProgressBlock)(CGFloat progress);
 

@interface AFNetworkTaskPatch : AFHTTPSessionManager

@property (nonatomic,strong) AFNetworkContainer * _Nonnull container;

+ (dispatch_queue_t _Nonnull)afnet_shared_afnetworkCompletionQueue;

+ (NSURL * _Nonnull)pathWithURL:(NSString * _Nonnull)URLString;
 
- (void)progressBlock:(AFNetworkTaskProgressBlock _Nullable)progressBlock;

- (nullable NSURLSessionUploadTask *)downloadTaskWithHTTPMethod:(NSString * _Nonnull)method
                                             URLString:(NSString * _Nonnull)URLString
                                            parameters:(id _Nullable)parameters
                                               success:(void (^ _Nonnull)(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject))success
                                               failure:(void (^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error))failure;

- (nullable NSURLSessionUploadTask *)uploadTaskWithHTTPMethod:(NSString * _Nonnull)method
                                           URLString:(NSString * _Nonnull)URLString
                                          parameters:(id _Nullable)parameters
                                               files:(id _Nullable)files
                                             success:(void (^ _Nonnull)(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject))success
                                             failure:(void (^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error))failure;



@end
