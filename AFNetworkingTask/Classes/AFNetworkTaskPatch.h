//
 

#import <Foundation/Foundation.h> 
#import "AFNetworkContainer.h"

#import <AFNetworking/AFHTTPSessionManager.h>

@class AFNetworkMsg;
@class AFHTTPSessionManager;

typedef void(^AFNetworkingTaskFinishedBlock)(AFNetworkMsg *  _Nonnull msg,id  _Nullable originalObj,id<AFNetworkResponseData>  _Nullable data)  NS_AVAILABLE_IOS(7_0);  //请求协议类型

typedef void(^AFNetworkTaskProgressBlock)(CGFloat progress);
 

@interface AFNetworkTaskPatch : AFHTTPSessionManager

@property (nonatomic,strong) AFNetworkContainer * _Nonnull container;

+ (dispatch_queue_t)afnet_shared_afnetworkCompletionQueue;

+ (NSURL * _Nonnull)pathWithURL:(NSString * _Nonnull)URLString;
 
- (void)progressBlock:(AFNetworkTaskProgressBlock)progressBlock;

- (nullable NSURLSessionUploadTask *)downloadTaskWithHTTPMethod:(NSString * _Nonnull)method
                                             URLString:(NSString * _Nonnull)URLString
                                            parameters:(id _Nullable)parameters
                                               success:(void (^)(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject))success
                                               failure:(void (^)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error))failure;

- (nullable NSURLSessionUploadTask *)uploadTaskWithHTTPMethod:(NSString * _Nonnull)method
                                           URLString:(NSString * _Nonnull)URLString
                                          parameters:(id _Nullable)parameters
                                               files:(id)files
                                             success:(void (^)(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject))success
                                             failure:(void (^)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error))failure;



@end
