//
 

#import <Foundation/Foundation.h>
#import "AFNetworkTask.h"
#import "AFHTTPSessionManager.h"


static NSString *const kAFNetworking_GET = @"GET";
static NSString *const kAFNetworking_POST = @"POST";
static NSString *const kAFNetworking_DELETE = @"DELETE";

static NSString *const kAFNetworking_PATCH = @"PATCH";
static NSString *const kAFNetworking_HEAD = @"HEAD";
static NSString *const kAFNetworking_PUT = @"PUT";


typedef NS_ENUM(NSInteger, AFNetworkStatusCode) {
    AFNetworkStatusCodeUnknown = 0,      //状态未知
    AFNetworkStatusCodeNoWork  = -50,   //取消
    AFNetworkStatusCodeCancel  = -100,   //取消
    AFNetworkStatusCodeSuccess = 200,    //成功
    AFNetworkStatusCodeHttpError   = -200,    //http未知错误
    AFNetworkStatusCodeDataError   = -300,    //数据解析错误
    AFNetworkStatusCodeProcessError   = -400,    //处理错误
    AFNetworkStatusCodeUnknownError   = -500    //未知错误
};


typedef NS_ENUM(NSInteger, AFNetworkResponseProtocolType) {
    AFNetworkResponseProtocolTypeNormal = 0,       //响应协议类型，发无任何格式的字符串流方式
    AFNetworkResponseProtocolTypeJSON,              //响应协议类型，发JSON格式符串流方式
    AFNetworkResponseProtocolTypeFile,              //响应协议类型，发文件流方式
};
typedef NS_ENUM(NSInteger, AFNetworkRequestProtocolType) {
    AFNetworkRequestProtocolTypeNormal = 0,       //请求协议类型，标准提交
    AFNetworkRequestProtocolTypeJSON,              //请求协议类型，发JSON格式提交
};


typedef void(^AFNetworkTaskFinishedBlock)(NSURLSessionTask *task,id responseObject,id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode);  //请求协议类型
typedef void(^AFNetworkTaskProcessResultBlock)(id responseObject);  //请求协议类型

typedef void(^AFNetworkTaskProgressBlock)(CGFloat progress);


@protocol AFNetworkData <NSObject>



@end
 

@interface AFNetworkTaskManager : AFHTTPSessionManager

@property (nonatomic,strong) NSDictionary *responseHeaders;

@property (nonatomic,assign) AFNetworkResponseProtocolType responseType;  //响应协议类型
@property (nonatomic,assign) AFNetworkRequestProtocolType  requestType;  //请求协议类型
  
+(dispatch_queue_t)afnet_sharedafnetworkCompletionQueue;

-(void)buildCommonHeader:(AFHTTPRequestSerializer *)requestSerializer;


+(NSURL *)pathWithURL:(NSString *)URLString; 



- (AFNetworkTask *)GET:(NSString *)URLString
            parameters:(id)parameters
                processResult:(AFNetworkTaskProcessResultBlock)processResult
                finish:(AFNetworkTaskFinishedBlock)finish;

- (AFNetworkTask *)POST:(NSString *)URLString
             parameters:(id)parameters
          processResult:(AFNetworkTaskProcessResultBlock)processResult
                    finish:(AFNetworkTaskFinishedBlock)finish;

 

- (AFNetworkTask *)DELETE:(NSString *)URLString
               parameters:(id)parameters
            processResult:(AFNetworkTaskProcessResultBlock)processResult
                   finish:(AFNetworkTaskFinishedBlock)finish;


- (AFNetworkTask *)UPLOAD:(NSString *)URLString
               parameters:(id)parameters
                    files:(id)files
                 progress:(AFNetworkTaskProgressBlock)progress
                   finish:(AFNetworkTaskFinishedBlock)finish;

- (AFNetworkTask *)DOWNLOAD:(NSString *)URLString
               parameters:(id)parameters
            progress:(AFNetworkTaskProgressBlock)progress
                   finish:(AFNetworkTaskFinishedBlock)finish;



@end
