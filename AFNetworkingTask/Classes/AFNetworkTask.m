 

#import "AFNetworkTask.h"
#import "AFNetworkActivityLogger.h"
#import "MJExtension.h"
#import "AFNetworkAdapter.h"



typedef void (^AFURLSessionDidBecomeInvalidBlock)(NSURLSession *session, NSError *error);
typedef NSURLSessionAuthChallengeDisposition (^AFURLSessionDidReceiveAuthenticationChallengeBlock)(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential * __autoreleasing *credential);

typedef NSURLRequest * (^AFURLSessionTaskWillPerformHTTPRedirectionBlock)(NSURLSession *session, NSURLSessionTask *task, NSURLResponse *response, NSURLRequest *request);
typedef NSURLSessionAuthChallengeDisposition (^AFURLSessionTaskDidReceiveAuthenticationChallengeBlock)(NSURLSession *session, NSURLSessionTask *task, NSURLAuthenticationChallenge *challenge, NSURLCredential * __autoreleasing *credential);
typedef void (^AFURLSessionDidFinishEventsForBackgroundURLSessionBlock)(NSURLSession *session);

typedef NSInputStream * (^AFURLSessionTaskNeedNewBodyStreamBlock)(NSURLSession *session, NSURLSessionTask *task);
typedef void (^AFURLSessionTaskDidSendBodyDataBlock)(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend);
typedef void (^AFURLSessionTaskDidCompleteBlock)(NSURLSession *session, NSURLSessionTask *task, NSError *error);

typedef NSURLSessionResponseDisposition (^AFURLSessionDataTaskDidReceiveResponseBlock)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLResponse *response);
typedef void (^AFURLSessionDataTaskDidBecomeDownloadTaskBlock)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLSessionDownloadTask *downloadTask);
typedef void (^AFURLSessionDataTaskDidReceiveDataBlock)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data);
typedef NSCachedURLResponse * (^AFURLSessionDataTaskWillCacheResponseBlock)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSCachedURLResponse *proposedResponse);

typedef NSURL * (^AFURLSessionDownloadTaskDidFinishDownloadingBlock)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location);
typedef void (^AFURLSessionDownloadTaskDidWriteDataBlock)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
typedef void (^AFURLSessionDownloadTaskDidResumeBlock)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t fileOffset, int64_t expectedTotalBytes);
typedef void (^AFURLSessionTaskProgressBlock)(NSProgress *);

typedef void (^AFURLSessionTaskCompletionHandler)(NSURLResponse *response, id responseObject, NSError *error);

@interface AFURLSessionManager(Ext)
@property (readwrite, nonatomic, strong) NSOperationQueue *operationQueue;
@property (readwrite, nonatomic, strong) NSURLSession *session;
@property (readwrite, nonatomic, strong) NSMutableDictionary *mutableTaskDelegatesKeyedByTaskIdentifier;
@property (readwrite, nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (readwrite, nonatomic, strong) NSLock *lock;

@property (readonly, nonatomic, copy) NSString *taskDescriptionForSessionTasks;
@property (readwrite, nonatomic, copy) AFURLSessionDidBecomeInvalidBlock sessionDidBecomeInvalid;
@property (readwrite, nonatomic, copy) AFURLSessionDidReceiveAuthenticationChallengeBlock sessionDidReceiveAuthenticationChallenge;
@property (readwrite, nonatomic, copy) AFURLSessionDidFinishEventsForBackgroundURLSessionBlock didFinishEventsForBackgroundURLSession;
@property (readwrite, nonatomic, copy) AFURLSessionTaskWillPerformHTTPRedirectionBlock taskWillPerformHTTPRedirection;
@property (readwrite, nonatomic, copy) AFURLSessionTaskDidReceiveAuthenticationChallengeBlock taskDidReceiveAuthenticationChallenge;
@property (readwrite, nonatomic, copy) AFURLSessionTaskNeedNewBodyStreamBlock taskNeedNewBodyStream;
@property (readwrite, nonatomic, copy) AFURLSessionTaskDidSendBodyDataBlock taskDidSendBodyData;
@property (readwrite, nonatomic, copy) AFURLSessionTaskDidCompleteBlock taskDidComplete;
@property (readwrite, nonatomic, copy) AFURLSessionDataTaskDidReceiveResponseBlock dataTaskDidReceiveResponse;
@property (readwrite, nonatomic, copy) AFURLSessionDataTaskDidBecomeDownloadTaskBlock dataTaskDidBecomeDownloadTask;
@property (readwrite, nonatomic, copy) AFURLSessionDataTaskDidReceiveDataBlock dataTaskDidReceiveData;
@property (readwrite, nonatomic, copy) AFURLSessionDataTaskWillCacheResponseBlock dataTaskWillCacheResponse;
@property (readwrite, nonatomic, copy) AFURLSessionDownloadTaskDidFinishDownloadingBlock downloadTaskDidFinishDownloading;
@property (readwrite, nonatomic, copy) AFURLSessionDownloadTaskDidWriteDataBlock downloadTaskDidWriteData;
@property (readwrite, nonatomic, copy) AFURLSessionDownloadTaskDidResumeBlock downloadTaskDidResume;

@end

@interface AFNetworkTask(){
    
}

@property (nonatomic,strong) NSURLSessionTask *sessionTask;

@property (nonatomic) BOOL finishedTag;

@end

@implementation AFNetworkTask
@synthesize container;
@synthesize sessionTask;
- (instancetype)initWithContainer:(AFNetworkContainer * _Nonnull)_container
{
    self = [super init];
    if (self) {
        
        container =  _container;
        __block typeof(self) weakSelf = self;
        [self setTaskDidComplete:^(NSURLSession *session, NSURLSessionTask *task, NSError *error) {
            if(weakSelf.finishedTag)
                [weakSelf recyle];
            else{
                weakSelf.finishedTag = YES;
            }
        }];
        
    }
    return self;
}

-(AFHTTPResponseSerializer<AFURLResponseSerialization> * _Nonnull)responseSerializer{
    
    
    return [container.serializerAdapter responseSerializer:container.responseType];
}
-(AFHTTPRequestSerializer<AFURLRequestSerialization> * _Nonnull)requestSerializer{
    return [container.serializerAdapter requestSerializer:container.requestType];
}
#pragma mark - GET

-(void)GET:(NSString * _Nonnull)url  finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
      [self GET:url form:nil finishedBlock:finishedBlock];
}
-(void)GET:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    NSDictionary *from  =[(Class)data mj_keyValues];
    
      [self GET:url form:from finishedBlock:finishedBlock];
}

-(void)GET:(NSString * _Nonnull)URLString
               form:(NSDictionary * _Nullable)form
                   finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finish{
    
    __block AFNetworkTask *weakSelf = self;
    
    [self serializeFinishedInCustomQueue];
    
    sessionTask =   [self GET:URLString parameters:form success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [weakSelf processSuccessResult:responseObject task:task  finish:finish];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [weakSelf processErrorResult:task error:error finish:finish];
        
    }];
    
    
}
#pragma mark - POST

-(void)POST:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    NSDictionary *from  =[(Class)data mj_keyValues];
    
    return [self POST:url form:from finishedBlock:finishedBlock];
}

- (void)POST:(NSString * _Nonnull)URLString
            form:(NSDictionary * _Nullable)form
             finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finish{
    
    __block typeof(self) weakSelf = self;
    
    [self serializeFinishedInCustomQueue];
    
    sessionTask =   [self POST:URLString parameters:form success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [weakSelf processSuccessResult:responseObject task:task  finish:finish];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [weakSelf processErrorResult:task error:error finish:finish];
    }];
    
}


- (void)POST:(NSString * _Nonnull)URLString
                      data:(id<AFNetworkRequestData> _Nullable)data
                      files:(NSDictionary * _Nullable)files
             finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
    NSDictionary *from  =[(Class)data mj_keyValues];
    
      [self POST:URLString form:from files:files finishedBlock:finishedBlock];
}

- (void)POST:(NSString * _Nonnull)URLString
                      form:(NSDictionary * _Nullable)form
                     files:(NSDictionary * _Nullable)files
             finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finish{
    
    __block typeof(self) weakSelf = self;
    
    [self serializeFinishedInCustomQueue];
    
    sessionTask =    [self uploadTaskWithHTTPMethod:@"POST" URLString:URLString parameters:form files:files success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [weakSelf processSuccessResult:responseObject task:task  finish:finish];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf processErrorResult:task error:error finish:finish];
    }];
    
}
#pragma mark - PUT

-(void)PUT:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    NSDictionary *from  =[(Class)data mj_keyValues];
    
      [self PUT:url form:from finishedBlock:finishedBlock];
}

- (void)PUT:(NSString * _Nonnull)URLString
                form:(NSDictionary * _Nullable)form
             finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finish{
    
    __block typeof(self) weakSelf = self;
    
    [self serializeFinishedInCustomQueue];
    
    sessionTask =   [self PUT:URLString parameters:form success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [weakSelf processSuccessResult:responseObject task:task  finish:finish];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [weakSelf processErrorResult:task error:error finish:finish];
    }];
    
}


- (void)PUT:(NSString * _Nonnull)URLString
                      data:(id<AFNetworkRequestData> _Nullable)data
                     files:(NSDictionary * _Nullable)files
             finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
    NSDictionary *from  =[(Class)data mj_keyValues];
    
      [self PUT:URLString form:from files:files finishedBlock:finishedBlock];
}

- (void)PUT:(NSString * _Nonnull)URLString
                      form:(NSDictionary * _Nullable)form
                     files:(NSDictionary * _Nullable)files
             finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finish{
    
    __block typeof(self) weakSelf = self;
    
    [self serializeFinishedInCustomQueue];
    
    sessionTask =    [self uploadTaskWithHTTPMethod:@"PUT" URLString:URLString parameters:form files:files success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [weakSelf processSuccessResult:responseObject task:task  finish:finish];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf processErrorResult:task error:error finish:finish];
    }];
    
}
#pragma mark - PATCH

-(void)PATCH:(NSString * _Nonnull)url finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
      [self PATCH:url form:nil finishedBlock:finishedBlock];
}
-(void)PATCH:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    NSDictionary *from  =[(Class)data mj_keyValues];
    
      [self PATCH:url form:from finishedBlock:finishedBlock];
}

-(void)PATCH:(NSString * _Nonnull)URLString
                    form:(NSDictionary * _Nullable)form
           finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finish{
    
    __block typeof(self) weakSelf = self;
    
    [self serializeFinishedInCustomQueue];
    
    sessionTask =   [self PATCH:URLString parameters:form success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [weakSelf processSuccessResult:responseObject task:task  finish:finish];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [weakSelf processErrorResult:task error:error finish:finish];
        
    }];
    
    
}
#pragma mark - DELETE

-(void)DELETE:(NSString * _Nonnull)url finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
    return [self DELETE:url form:nil finishedBlock:finishedBlock];
}
-(void)DELETE:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    NSDictionary *from  =[(Class)data mj_keyValues];
    
      [self DELETE:url form:from finishedBlock:finishedBlock];
}

-(void)DELETE:(NSString * _Nonnull)URLString
                      form:(NSDictionary * _Nullable)form
             finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finish{
    
    __block typeof(self) weakSelf = self;
    
    [self serializeFinishedInCustomQueue];
    
    sessionTask =   [self DELETE:URLString parameters:form success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [weakSelf processSuccessResult:responseObject task:task  finish:finish];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [weakSelf processErrorResult:task error:error finish:finish];
        
    }];
    
    
}
#pragma mark - DOWNLOAD

-(void)DOWNLOAD:(NSString * _Nonnull)url  finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
      [self DOWNLOAD:url form:nil finishedBlock:finishedBlock];
}


- (void)DOWNLOAD:(NSString * _Nonnull)URLString
                      data:(id<AFNetworkRequestData> _Nullable)data
             finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
    NSDictionary *from  =[(Class)data mj_keyValues];
    
      [self DOWNLOAD:URLString form:from  finishedBlock:finishedBlock];
}

- (void)DOWNLOAD:(NSString * _Nonnull)URLString
                      form:(NSDictionary * _Nullable)form
             finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finish{
    
    __block typeof(self) weakSelf = self;
    
    [self serializeFinishedInCustomQueue];
    
    self.completionQueue = [[self class] afnet_shared_afnetworkCompletionQueue];
    
    sessionTask =  [self downloadTaskWithHTTPMethod:@"GET" URLString:URLString parameters:form success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [weakSelf processSuccessResult:responseObject task:task  finish:finish];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf processErrorResult:task error:error finish:finish];
    }];
    
}
//切换到主线程
-(void)serializeFinishedInCustomQueue{
    if(container.completionCustomQueue){
        self.completionQueue = [[self class] afnet_shared_afnetworkCompletionQueue];
    }else{
        self.completionQueue = NULL;
    }
}




#pragma mark - process  Result
-(void)processSuccessResult:(id _Nullable)responseObject task:(NSURLSessionDataTask * _Nonnull)task   finish:(AFNetworkingTaskFinishedBlock _Nullable)finish{
    NSHTTPURLResponse  *response = (NSHTTPURLResponse  *)task.response;
    
    [container taskResponseAdapter:response];
    
    id body = [container processSuccessWithTask:task response:response originalObj:responseObject];
    if(finish){
        finish(container.msg,responseObject,body);
    }
    if(self.finishedTag)
        [self recyle];
    else{
        self.finishedTag = YES;
    }
    
}
-(void)processErrorResult:(NSURLSessionDataTask * _Nonnull)task error:(NSError * _Nullable)error finish:(AFNetworkingTaskFinishedBlock _Nullable)finish{
    [container processFailWithTask:task error:error];
    if(finish){
        finish(container.msg,nil,nil);
    }
    if(self.finishedTag)
        [self recyle];
    else{
        self.finishedTag = YES;
    }
}

#pragma mark - process  Recyle
-(void)cancel{
    [sessionTask cancel];
}

-(void)recyle{
    
    sessionTask = nil;
    
    [container recyle];
    container = nil;
    
    self.securityPolicy = nil;
    self.reachabilityManager = nil;
    
    self.completionQueue = nil;
    self.completionGroup = nil;
    [self.operationQueue cancelAllOperations];
    self.operationQueue = nil;
    self.lock = nil;
    [self.session finishTasksAndInvalidate];
    self.session = nil;
    self.mutableTaskDelegatesKeyedByTaskIdentifier = nil;
    self.sessionConfiguration = nil;
    
    self.sessionDidBecomeInvalid = nil;
    self.sessionDidReceiveAuthenticationChallenge = nil;
    self.didFinishEventsForBackgroundURLSession = nil;
    self.taskWillPerformHTTPRedirection = nil;
    self.taskDidReceiveAuthenticationChallenge = nil;
    self.taskNeedNewBodyStream = nil;
    self.taskDidSendBodyData = nil;
    
    self.taskDidComplete = nil;
    self.dataTaskDidReceiveResponse = nil;
    self.dataTaskDidBecomeDownloadTask = nil;
    self.dataTaskDidReceiveData = nil;
    self.dataTaskWillCacheResponse = nil;
    self.downloadTaskDidFinishDownloading = nil;
    self.downloadTaskDidWriteData = nil;
    self.downloadTaskDidResume = nil;
     
}

-(void)dealloc{
//    NSLog(@"------%@ dealloc",self.class);
}

@end
