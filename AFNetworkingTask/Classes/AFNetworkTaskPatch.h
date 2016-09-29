//
 

#import <Foundation/Foundation.h> 
#import "AFHTTPSessionManager.h"
#import "AFNetworkContainer.h"

@class AFNetworkMsg;

typedef void(^AFNetworkingTaskFinishedBlock)(AFNetworkMsg *msg,id originalObj,id<AFNetworkResponseData> data)  NS_AVAILABLE_IOS(7_0);  //请求协议类型

typedef void(^AFNetworkTaskProgressBlock)(CGFloat progress);
 

@interface AFNetworkTaskPatch : AFHTTPSessionManager

@property (nonatomic,strong) AFNetworkContainer *container;

+(dispatch_queue_t)afnet_shared_afnetworkCompletionQueue;

+(NSURL *)pathWithURL:(NSString *)URLString;
 
- (void)progressBlock:(AFNetworkTaskProgressBlock)progressBlock;

- (NSURLSessionUploadTask *)downloadTaskWithHTTPMethod:(NSString *)method
                                             URLString:(NSString *)URLString
                                            parameters:(id)parameters
                                               success:(void (^)(NSURLSessionDataTask *, id))success
                                               failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

- (NSURLSessionUploadTask *)uploadTaskWithHTTPMethod:(NSString *)method
                                           URLString:(NSString *)URLString
                                          parameters:(id)parameters
                                               files:(id)files
                                             success:(void (^)(NSURLSessionDataTask *, id))success
                                             failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;



@end
