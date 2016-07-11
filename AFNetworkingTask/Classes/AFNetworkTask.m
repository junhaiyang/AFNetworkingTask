 

#import "AFNetworkTask.h"


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
     
    NSURLSessionTask *sessionTask;
    
}

@property (nonatomic,strong) AFNetworkAnalysis *analysis;
 
@property (nonatomic,strong) AFNetworkingTaskFinishedBlock networkingTaskFinishedBlock;



@end

@interface AFNetworkAnalysis(Ext)
@property (nonatomic,strong,readwrite) NSDictionary *analysises NS_AVAILABLE_IOS(7_0);
@property (nonatomic,strong,readwrite) id originalBody NS_AVAILABLE_IOS(7_0);

-(void)addAnalysis:(NSString *)key structure:(Class)clazz;
-(void)addAnalysis:(NSString *)key structureArray:(Class)clazz;

@end

@implementation AFNetworkTask
@synthesize analysis;
//
//@synthesize requestSerializer = _requestSerializer;
//@synthesize responseSerializer = _responseSerializer;

@synthesize networkingTaskFinishedBlock;

static Class networkAnalysis;

+(void)load{
    networkAnalysis = [AFNetworkAnalysis class];
}
+(void)defaultAnalysis:(Class)clazz{
    networkAnalysis = clazz;
}

- (instancetype)init
{
    return [self initWithTask:[[networkAnalysis alloc] init]];
} 
- (instancetype)initWithTask:(AFNetworkAnalysis *)_analysis
{
    self = [super init];
    if (self) {
        if(_analysis==nil){
            analysis = [[networkAnalysis alloc] init];
        }else{
            analysis = _analysis;
        }
        
        __weak AFNetworkTask *weakSelf = self;
        [self setTaskDidComplete:^(NSURLSession *session, NSURLSessionTask *task, NSError *error) {
            [weakSelf recyle];
        }];
        
    }
    return self;
}
-(void)addAnalysis:(NSString *)key structure:(Class)clazz{
    [analysis addAnalysis:key structure:clazz];
}
-(void)addAnalysis:(NSString *)key structureArray:(Class)clazz{
    [analysis addAnalysis:key structureArray:clazz];
}
-(void)addStructure:(Class)clazz{
    [analysis addAnalysis:kAllBodyObjectInfo structure:clazz];
}
-(void)addStructureArray:(Class)clazz{
    [analysis addAnalysis:kAllBodyObjectInfo structureArray:clazz];
}
-(AFNetworkResponseProtocolType)responseType{
    return analysis.responseType;
}
-(AFNetworkRequestProtocolType)requestType{
    return analysis.requestType;
}

-(void)setResponseType:(AFNetworkResponseProtocolType)responseType{
    analysis.responseType =responseType;
}
-(void)setRequestType:(AFNetworkRequestProtocolType)requestType{
    analysis.requestType =requestType;
}
-(void)buildCommonHeader:(AFHTTPRequestSerializer *)requestSerializer{
    
//    NSLog(@"%@",self.analysis);
    NSDictionary *headers =self.analysis.requestHeaders;
    for (NSString *key in headers.allKeys) {
        [requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    
}

-(void)finishedWithMainQueue:(AFNetworkingFinishedBlock)finishedBlock{
    
    analysis.completionCustomQueue =NO;
    __weak AFNetworkTask *weakSelf = self;
    
    [self finishedTaskWithQueue:^(AFNetworkMsg *msg, id originalObj, NSDictionary *jsonBody) {
        if(finishedBlock){
            finishedBlock(weakSelf,msg.errorCode,msg.httpStatusCode);
        }
    }];
    
}
-(void)finishedWithCustomQueue:(AFNetworkingFinishedBlock)finishedBlock{
    
    analysis.completionCustomQueue =YES;
    __weak AFNetworkTask *weakSelf = self;
    
    [self finishedTaskWithQueue:^(AFNetworkMsg *msg, id originalObj, NSDictionary *jsonBody) {
        if(finishedBlock){
            finishedBlock(weakSelf,msg.errorCode,msg.httpStatusCode);
        }
    }];
}

-(void)finishedTaskWithQueue:(AFNetworkingTaskFinishedBlock)finishedBlock{
    
    self.networkingTaskFinishedBlock =finishedBlock;
    [self prepareRequest];
}



-(void)buildPostFileRequest:(NSString *)url files:(NSDictionary *)files{
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    
    __weak AFNetworkTask *weakSelf = self;
    sessionTask =[self UPLOAD:url parameters:nil files:files progress:^(CGFloat progress) {
        
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [weakSelf processDictionary:responseObject];
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostFileRequest:%@",exception);
        }
        @finally {
            [weakSelf processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            [weakSelf processResponse:responseObject];
            
            @try {
                if(weakSelf.networkingTaskFinishedBlock){
                    weakSelf.networkingTaskFinishedBlock(weakSelf.analysis.msg,weakSelf.analysis.originalBody,weakSelf.analysis.body);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"buildPostFileRequest:%@",exception);
            }@finally{
//                [weakSelf recyle];
            }
        }
        
        
    }];
    
}

-(void)buildPostFileRequest:(NSString *)url form:(NSDictionary *)form files:(NSDictionary *)files{
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    
    __weak AFNetworkTask *weakSelf = self;
    
    sessionTask =[self UPLOAD:url parameters:form files:files progress:^(CGFloat progress) {
        
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [weakSelf processDictionary:responseObject];
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostFileRequest:%@",exception);
        }
        @finally {
            [weakSelf processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            [weakSelf processResponse:responseObject];
            
            @try {
                if(weakSelf.networkingTaskFinishedBlock){
                    weakSelf.networkingTaskFinishedBlock(weakSelf.analysis.msg,weakSelf.analysis.originalBody,weakSelf.analysis.body);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"buildPostFileRequest:%@",exception);
            }@finally{
//                [weakSelf recyle];
            }
        }
        
        
    }];
    
}

-(void)buildPutRequest:(NSString *)url form:(NSDictionary *)form{
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    __weak AFNetworkTask *weakSelf = self;
    
    sessionTask =[self PUT:url parameters:form processResult:^(id responseObject) {
        [weakSelf processDictionary:responseObject];
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [weakSelf processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            [weakSelf processResponse:responseObject];
            
            if(weakSelf.networkingTaskFinishedBlock){
                weakSelf.networkingTaskFinishedBlock(weakSelf.analysis.msg,weakSelf.analysis.originalBody,weakSelf.analysis.body);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostRequest:%@",exception);
        }@finally{
//            [weakSelf recyle];
        }
    }];
    
}
-(void)buildPostRequest:(NSString *)url form:(NSDictionary *)form{
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    __weak AFNetworkTask *weakSelf = self;
    
    sessionTask =[self POST:url parameters:form processResult:^(id responseObject) {
        [weakSelf processDictionary:responseObject];
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [weakSelf processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            [weakSelf processResponse:responseObject];
            
            if(weakSelf.networkingTaskFinishedBlock){
                weakSelf.networkingTaskFinishedBlock(weakSelf.analysis.msg,weakSelf.analysis.originalBody,weakSelf.analysis.body);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostRequest:%@",exception);
        }@finally{
//            [weakSelf recyle];
        }
    }];
    
}
-(void)buildGetRequest:(NSString *)url{
    
    [self buildGetRequest:url form:nil];
    
}

-(void)buildGetRequest:(NSString *)url form:(NSDictionary *)form{
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    
    __weak AFNetworkTask *weakSelf = self;
    
    sessionTask =[self GET:url parameters:form processResult:^(id responseObject) {
        [weakSelf processDictionary:responseObject];
        
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [weakSelf processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            [weakSelf processResponse:responseObject];
            
            if(weakSelf.networkingTaskFinishedBlock){
                weakSelf.networkingTaskFinishedBlock(analysis.msg,analysis.originalBody,analysis.body);
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"buildGetRequest:%@",exception);
        }@finally{
//            [weakSelf recyle];
        }
    }];
}


-(void)buildDeleteRequest:(NSString *)url {
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    
    __weak AFNetworkTask *weakSelf = self;
    sessionTask =[self DELETE:url parameters:nil processResult:^(id responseObject) {
        [weakSelf processDictionary:responseObject];
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            
            [weakSelf processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            [weakSelf processResponse:responseObject];
            
            if(weakSelf.networkingTaskFinishedBlock){
                weakSelf.networkingTaskFinishedBlock(weakSelf.analysis.msg,weakSelf.analysis.originalBody,weakSelf.analysis.body);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"buildDeleteRequest:%@",exception);
        }@finally{
//            [weakSelf recyle];
        }
    }];
}
-(void)cancel{
    [sessionTask cancel];
}

-(void)recyle{
    
    self.networkingTaskFinishedBlock = NULL;
    sessionTask = nil;
    self.responseHeaders = nil;
    
    self.securityPolicy = nil;
    self.reachabilityManager = nil;
    
    self.completionQueue = nil;
    self.completionGroup = nil;
    [self.operationQueue cancelAllOperations];
    self.operationQueue = nil;
//    _responseSerializer = nil;
//    _requestSerializer = nil;
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
     
    [analysis recyle];
    analysis = nil;
     
      
}

-(void)processResponse:(id)responseObject{
    
    @try {
        
        analysis.originalBody = responseObject;
        [analysis analysisBody];
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
        analysis.msg.responseHeaders =self.responseHeaders;
    }
    
    
}

-(void)processResponseErrorCode:(AFNetworkStatusCode)errorCode  httpStatusCode:(NSInteger)httpStatusCode{
    
    analysis.msg.errorCode =errorCode;
    analysis.msg.httpStatusCode =httpStatusCode;
     
}

-(BOOL)requestSuccess{
    return [analysis.msg isSuccess];
}
-(void)prepareRequest{
//    NSException *exction =[[NSException alloc] initWithName:@"需要实现方法" reason:@"----prepareRequest----" userInfo:nil];
//    @throw exction;
}
-(void)processDictionary:(id)dictionary{
    
//    NSException *exction =[[NSException alloc] initWithName:@"需要实现方法" reason:@"----processDictionary:----" userInfo:nil];
//    @throw exction;
}

//切换到主线程
-(void)serializeFinishedInCustomQueue{
    self.completionQueue = [[self class] afnet_sharedafnetworkCompletionQueue];
}

//执行操作
-(void)executeGet:(NSString *)url  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    [self executeGet:url form:nil finishedBlock:finishedBlock];
}
-(void)executeDelete:(NSString *)url  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    [self executeDelete:url form:nil finishedBlock:finishedBlock];
    
}

-(void)executeGet:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    self.networkingTaskFinishedBlock = finishedBlock;
    
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    
    __weak AFNetworkTask *weakSelf = self;
    
    sessionTask =[self GET:url parameters:form processResult:^(id responseObject) {
        [weakSelf processDictionary:responseObject];
        
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [weakSelf processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            [weakSelf processResponse:responseObject];
            
            if(weakSelf.networkingTaskFinishedBlock){
                weakSelf.networkingTaskFinishedBlock(weakSelf.analysis.msg,weakSelf.analysis.originalBody,weakSelf.analysis.body);
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"buildGetRequest:%@",exception);
        }@finally{
//            [weakSelf recyle];
        }
    }];
    
}
-(void)executePUT:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    self.networkingTaskFinishedBlock = finishedBlock;
    
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    
    __weak AFNetworkTask *weakSelf = self;
    sessionTask =[self PUT:url parameters:form processResult:^(id responseObject) {
        [weakSelf processDictionary:responseObject];
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [weakSelf processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            [weakSelf processResponse:responseObject];
            
            if(weakSelf.networkingTaskFinishedBlock){
                weakSelf.networkingTaskFinishedBlock(weakSelf.analysis.msg,weakSelf.analysis.originalBody,weakSelf.analysis.body);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostRequest:%@",exception);
        }@finally{
            [weakSelf recyle];
        }
    }];
    
}
-(void)executePATCH:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    self.networkingTaskFinishedBlock = finishedBlock;
    
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    
    __weak AFNetworkTask *weakSelf = self;
    sessionTask =[self PATCH:url parameters:form processResult:^(id responseObject) {
        [weakSelf processDictionary:responseObject];
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [weakSelf processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            [weakSelf processResponse:responseObject];
            
            if(weakSelf.networkingTaskFinishedBlock){
                weakSelf.networkingTaskFinishedBlock(weakSelf.analysis.msg,weakSelf.analysis.originalBody,weakSelf.analysis.body);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostRequest:%@",exception);
        }@finally{
//            [weakSelf recyle];
        }
    }];
    
}
-(void)executePOST:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    self.networkingTaskFinishedBlock = finishedBlock;
    
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    
    __weak AFNetworkTask *weakSelf = self;
    sessionTask =[self POST:url parameters:form processResult:^(id responseObject) {
        [weakSelf processDictionary:responseObject];
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [weakSelf processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            [weakSelf processResponse:responseObject];
            
            if(weakSelf.networkingTaskFinishedBlock){
                weakSelf.networkingTaskFinishedBlock(weakSelf.analysis.msg,weakSelf.analysis.originalBody,weakSelf.analysis.body);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostRequest:%@",exception);
        }@finally{
//            [weakSelf recyle];
        }
    }];
    
}
-(void)executePostFile:(NSString *)url files:(NSDictionary *)files finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    [self executePostFile:url form:nil files:files finishedBlock:finishedBlock];
}
-(void)executePostFile:(NSString *)url form:(NSDictionary *)form  files:(NSDictionary *)files finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    self.networkingTaskFinishedBlock = finishedBlock;
    
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    
    __weak AFNetworkTask *weakSelf = self;
    sessionTask =[self UPLOAD:url parameters:form files:files progress:^(CGFloat progress) {
        
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [self processDictionary:responseObject];
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostFileRequest:%@",exception);
        }
        @finally {
            [weakSelf processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            [weakSelf processResponse:responseObject];
            
            @try {
                if(weakSelf.networkingTaskFinishedBlock){
                    weakSelf.networkingTaskFinishedBlock(weakSelf.analysis.msg,weakSelf.analysis.originalBody,weakSelf.analysis.body);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"buildPostFileRequest:%@",exception);
            }@finally{
//                [weakSelf recyle];
            }
        }
        
        
    }];
    
}
-(void)executeDELETE:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    self.networkingTaskFinishedBlock = finishedBlock;
    
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    
    __weak AFNetworkTask *weakSelf = self;
    sessionTask =[self DELETE:url parameters:form processResult:^(id responseObject) {
        [weakSelf processDictionary:responseObject];
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [weakSelf processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            [weakSelf processResponse:responseObject];
            
            if(weakSelf.networkingTaskFinishedBlock){
                weakSelf.networkingTaskFinishedBlock(weakSelf.analysis.msg,weakSelf.analysis.originalBody,weakSelf.analysis.body);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"buildDeleteRequest:%@",exception);
        }@finally{
//            [weakSelf recyle];
        }
    }];

}

-(void)dealloc{
#if DEBUG
//    NSLog(@"---开发测试阶段，打印网络协议对象回收日志----");
#endif
}

-(void)executeGetFile:(NSString *)url form:(NSDictionary *)form  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    self.networkingTaskFinishedBlock = finishedBlock;
    
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    
    
    __weak AFNetworkTask *weakSelf = self;
    [self DOWNLOAD:url parameters:form progress:^(CGFloat progress) {
        
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [weakSelf processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            [weakSelf processResponse:responseObject];
            
            if(weakSelf.networkingTaskFinishedBlock){
                weakSelf.networkingTaskFinishedBlock(weakSelf.analysis.msg,weakSelf.analysis.originalBody,weakSelf.analysis.body);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"buildDeleteRequest:%@",exception);
        }@finally{
//            [weakSelf recyle];
        }
    }];
    
}
-(void)executeGet:(NSString *)url data:(NSObject<AFNetworkRequestData> *)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    NSDictionary *from  =[data mj_keyValues];
    
    [self executeGet:url form:from finishedBlock:finishedBlock];
    
}
-(void)executePUT:(NSString *)url data:(NSObject<AFNetworkRequestData> *)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    NSDictionary *from  =[data mj_keyValues];
    
    [self executePUT:url form:from finishedBlock:finishedBlock];
}
-(void)executePATCH:(NSString *)url data:(NSObject<AFNetworkRequestData> *)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    NSDictionary *from  =[data mj_keyValues];
    
    [self executePATCH:url form:from finishedBlock:finishedBlock];
}
-(void)executePOST:(NSString *)url data:(NSObject<AFNetworkRequestData> *)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    NSDictionary *from  =[data mj_keyValues];
    
    [self executePOST:url form:from finishedBlock:finishedBlock];
}
-(void)executePostFile:(NSString *)url data:(NSObject<AFNetworkRequestData> *)data  files:(NSDictionary *)files finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    
    NSDictionary *from  =[data mj_keyValues];
    
    [self executePostFile:url form:from files:files finishedBlock:finishedBlock];
}
-(void)executeDelete:(NSString *)url data:(NSObject<AFNetworkRequestData> *)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    NSDictionary *from  =[data mj_keyValues];
    
    [self executeDelete:url form:from finishedBlock:finishedBlock];
}
-(void)executeGetFile:(NSString *)url data:(NSObject<AFNetworkRequestData> *)data  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    NSDictionary *from  =[data mj_keyValues];
    
    [self executeGetFile:url form:from finishedBlock:finishedBlock];
}
@end
