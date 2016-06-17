 

#import "AFNetworkTask.h"
#import "MJExtension.h"

@interface AFURLSessionManager(Ext)
@property (readwrite, nonatomic, strong) NSOperationQueue *operationQueue;
@property (readwrite, nonatomic, strong) NSURLSession *session;
@property (readwrite, nonatomic, strong) NSMutableDictionary *mutableTaskDelegatesKeyedByTaskIdentifier;
@property (readwrite, nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (readwrite, nonatomic, strong) NSLock *lock;

//@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;
//
//@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> * responseSerializer;

@end


@interface AFNetworkTask(){
     
    NSURLSessionTask *sessionTask;
    
}

@property (nonatomic,strong) AFNetworkAnalysis *analysis;
 
@property (nonatomic,strong) AFNetworkingTaskFinishedBlock networkingTaskFinishedBlock;



@end

@implementation AFNetworkTask
@synthesize analysis;

@synthesize requestSerializer = _requestSerializer;
@synthesize responseSerializer = _responseSerializer;

@synthesize networkingTaskFinishedBlock;

- (instancetype)init
{
    return [self initWithTask:[AFNetworkAnalysis defaultAnalysis]];
} 
- (instancetype)initWithTask:(AFNetworkAnalysis *)_analysis
{
    self = [super init];
    if (self) {
        if(_analysis==nil){
            analysis = [AFNetworkAnalysis defaultAnalysis];
        }else{
            analysis = _analysis;
        }
        
    }
    return self;
}
-(void)addAnalysis:(NSString *)key value:(id)value{
    [analysis addAnalysis:key value:value];
}
-(NSDictionary *)responseHeaders{
    return analysis.msg.responseHeaders;
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
//-(void)setResponseHeaders:(NSDictionary *)responseHeaders{
//
//}

-(void)buildCommonHeader:(AFHTTPRequestSerializer *)requestSerializer{
    
//    NSLog(@"%@",self.analysis);
    NSDictionary *headers =[self.analysis buildCommonHeader];
    for (NSString *key in headers.allKeys) {
        [requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    
}

-(void)finishedWithMainQueue:(AFNetworkingFinishedBlock)finishedBlock{
    
    analysis.completionCustomQueue =NO;
    
    [self finishedTaskWithQueue:^(AFNetworkMsg *msg, id originalObj, NSDictionary *jsonBody) {
        if(finishedBlock){
            finishedBlock(self,msg.errorCode,msg.httpStatusCode);
        }
    }];
    
}
-(void)finishedWithCustomQueue:(AFNetworkingFinishedBlock)finishedBlock{
    
    analysis.completionCustomQueue =YES;
    
    [self finishedTaskWithQueue:^(AFNetworkMsg *msg, id originalObj, NSDictionary *jsonBody) {
        if(finishedBlock){
            finishedBlock(self,msg.errorCode,msg.httpStatusCode);
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
    
    sessionTask =[self UPLOAD:url parameters:nil files:files progress:^(CGFloat progress) {
        
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [self processDictionary:responseObject];
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostFileRequest:%@",exception);
        }
        @finally {
            [self processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            
            @try {
                if(self.networkingTaskFinishedBlock){
                    self.networkingTaskFinishedBlock(analysis.msg,analysis.originalBody,analysis.body);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"buildPostFileRequest:%@",exception);
            }@finally{
                [self recyle];
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
    
    
    sessionTask =[self UPLOAD:url parameters:form files:files progress:^(CGFloat progress) {
        
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [self processDictionary:responseObject];
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostFileRequest:%@",exception);
        }
        @finally {
            [self processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            
            @try {
                if(self.networkingTaskFinishedBlock){
                    self.networkingTaskFinishedBlock(analysis.msg,analysis.originalBody,analysis.body);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"buildPostFileRequest:%@",exception);
            }@finally{
                [self recyle];
            }
        }
        
        
    }];
    
}
-(void)buildPostRequest:(NSString *)url form:(NSDictionary *)form{
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    
    sessionTask =[self POST:url parameters:form processResult:^(id responseObject) {
        [self processDictionary:responseObject];
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [self processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            
            if(self.networkingTaskFinishedBlock){
                self.networkingTaskFinishedBlock(analysis.msg,analysis.originalBody,analysis.body);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostRequest:%@",exception);
        }@finally{
            [self recyle];
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
            
            if(weakSelf.networkingTaskFinishedBlock){
                weakSelf.networkingTaskFinishedBlock(analysis.msg,analysis.originalBody,analysis.body);
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"buildGetRequest:%@",exception);
        }@finally{
            [weakSelf recyle];
        }
    }];
}


-(void)buildDeleteRequest:(NSString *)url {
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    
    sessionTask =[self DELETE:url parameters:nil processResult:^(id responseObject) {
        [self processDictionary:responseObject];
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            
            [self processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            
            if(self.networkingTaskFinishedBlock){
                self.networkingTaskFinishedBlock(analysis.msg,analysis.originalBody,analysis.body);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"buildDeleteRequest:%@",exception);
        }@finally{
            [self recyle];
        }
    }];
}
-(void)cancel{
    [sessionTask cancel];
}

-(void)recyle{
    analysis.msg.responseHeaders = nil;
    analysis.msg = nil;
    
    
    analysis.analysises = nil;
    analysis.body = nil;
    analysis.originalBody = nil;
    
    self.networkingTaskFinishedBlock = NULL;
    sessionTask = nil;
    self.responseHeaders = nil;
    
    self.securityPolicy = nil;
    self.reachabilityManager = nil;
    
    self.completionQueue = nil;
    self.completionGroup = nil;
    [self.operationQueue cancelAllOperations];
    self.operationQueue = nil;
    _responseSerializer = nil;
    _requestSerializer = nil;
    self.lock = nil;
    [self.session finishTasksAndInvalidate];
    self.session = nil;
    self.mutableTaskDelegatesKeyedByTaskIdentifier = nil;
    self.sessionConfiguration = nil;
    
    analysis = nil;
    analysis = nil;
     
      
}

-(void)processResponse:(id)responseObject{
    
    if([responseObject isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic = responseObject;
        [analysis.msg mj_setKeyValues:dic];
        
        
        NSMutableDictionary *body =[NSMutableDictionary new];
        
        
        for (NSString *key in analysis.analysises) {
            NSObject *obj = [analysis.analysises objectForKey:key];
            NSObject *value = [dic objectForKey:key];
            
            if([obj isKindOfClass:[NSArray class]]){
                NSArray *array = obj;
                
                if(array.count==1){
                    Class clazz = [array objectAtIndex:0];
                    NSObject *object =  [clazz mj_objectWithKeyValues:value];
                    [body setObject:object forKey:key];
                }else if(array.count==2){
                    Class clazz = [array objectAtIndex:0];
                    Class type = [array objectAtIndex:1];
                    if(![type isSubclassOfClass:[NSArray class]]){
                        NSObject *object =  [clazz mj_objectWithKeyValues:value];
                        [body setObject:object forKey:key];
                    }else{
                        NSArray *object =  [clazz mj_objectArrayWithKeyValuesArray:value];
                        [body setObject:object forKey:key];
                    }
                }else{
                    NSException *exction =[[NSException alloc] initWithName:@"解析方法构造错误" reason:key userInfo:nil];
                    @throw exction;
                }
            }else{
                
                Class clazz = obj;
                NSObject *object =  [clazz mj_objectWithKeyValues:value];
                [body setObject:object forKey:key];
                
//                NSException *exction =[[NSException alloc] initWithName:@"解析方法构造错误" reason:key userInfo:nil];
//                @throw exction;
            }
        }
        analysis.body = body;
        
    }
    
    analysis.msg.responseHeaders =self.responseHeaders;
    
    analysis.originalBody = responseObject;
    
}

-(void)processResponseErrorCode:(AFNetworkStatusCode)errorCode  httpStatusCode:(NSInteger)httpStatusCode{
    
    analysis.msg.errorCode =errorCode;
    analysis.msg.errorCode =httpStatusCode;
     
}

-(BOOL)requestSuccess{
    return [analysis.msg isSuccess];
}
-(void)prepareRequest{
//    NSException *exction =[[NSException alloc] initWithName:@"需要实现方法" reason:@"----prepareRequest----" userInfo:nil];
//    @throw exction;
}
-(void)processDictionary:(id)dictionary{
    [self processResponse:dictionary];
    
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
            
            if(weakSelf.networkingTaskFinishedBlock){
                weakSelf.networkingTaskFinishedBlock(weakSelf.analysis.msg,weakSelf.analysis.originalBody,weakSelf.analysis.body);
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"buildGetRequest:%@",exception);
        }@finally{
            [weakSelf recyle];
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
    
    sessionTask =[self POST:url parameters:form processResult:^(id responseObject) {
        [self processDictionary:responseObject];
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [self processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            
            if(self.networkingTaskFinishedBlock){
                self.networkingTaskFinishedBlock(analysis.msg,analysis.originalBody,analysis.body);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostRequest:%@",exception);
        }@finally{
            [self recyle];
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
    
    sessionTask =[self UPLOAD:url parameters:form files:files progress:^(CGFloat progress) {
        
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [self processDictionary:responseObject];
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostFileRequest:%@",exception);
        }
        @finally {
            [self processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            
            @try {
                if(self.networkingTaskFinishedBlock){
                    self.networkingTaskFinishedBlock(analysis.msg,analysis.originalBody,analysis.body);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"buildPostFileRequest:%@",exception);
            }@finally{
                [self recyle];
            }
        }
        
        
    }];
    
}
-(void)executeDelete:(NSString *)url form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    self.networkingTaskFinishedBlock = finishedBlock;
    
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    
    sessionTask =[self DELETE:url parameters:form processResult:^(id responseObject) {
        [self processDictionary:responseObject];
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [self processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            
            if(self.networkingTaskFinishedBlock){
                self.networkingTaskFinishedBlock(analysis.msg,analysis.originalBody,analysis.body);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"buildDeleteRequest:%@",exception);
        }@finally{
            [self recyle];
        }
    }];

}

-(void)dealloc{
#if DEBUG
    NSLog(@"---网络协议内存完全回收----");
#endif
}

-(void)executeGetFile:(NSString *)url form:(NSDictionary *)form  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock{
    self.networkingTaskFinishedBlock = finishedBlock;
    
    if(analysis.completionCustomQueue){
        [self serializeFinishedInCustomQueue];
    }else{
        self.completionQueue = NULL;
    }
    
    
    [self DOWNLOAD:url parameters:form progress:^(CGFloat progress) {
        
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [self processResponseErrorCode:errorCode httpStatusCode:httpStatusCode];
            
            if(self.networkingTaskFinishedBlock){
                self.networkingTaskFinishedBlock(analysis.msg,analysis.originalBody,analysis.body);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"buildDeleteRequest:%@",exception);
        }@finally{
            [self recyle];
        }
    }];
    
}
@end
