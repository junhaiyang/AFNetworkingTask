 

#import "AFNetworkTask.h"


@interface AFNetworkTask(){
     
    NSURLSessionTask *sessionTask;
    
}

@property (nonatomic,strong) AFNetworkAnalysis *analysis;
 
@property (nonatomic,strong) AFNetworkingTaskFinishedBlock networkingTaskFinishedBlock;



@end

@implementation AFNetworkTask
@synthesize analysis;

@synthesize networkingTaskFinishedBlock;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        manager =[AFNetworkTaskManager new];
        
    }
    return self;
}
- (instancetype)initWithTask:(AFNetworkAnalysis *)_analysis
{
    self = [super init];
    if (self) {
        manager =[AFNetworkTaskManager new];
        
        analysis = _analysis;
        
    }
    return self;
}

-(void)finishedWithMainQueue:(AFNetworkingFinishedBlock)finishedBlock{
    
    [self finishedTaskWithMainQueue:^(AFNetworkTask *request, AFNetworkMsg *msg, id obj, ...) {
        if(finishedBlock){
            finishedBlock(request,msg.errorCode,msg.httpStatusCode);
        }
    }];
    
    
    
    
}
-(void)finishedWithCustomQueue:(AFNetworkingFinishedBlock)finishedBlock{
    
    [self finishedTaskWithCustomQueue:^(AFNetworkTask *request, AFNetworkMsg *msg, id obj, ...) {
        if(finishedBlock){
            finishedBlock(request,msg.errorCode,msg.httpStatusCode);
        }
    }];
}

-(void)finishedTaskWithMainQueue:(AFNetworkingTaskFinishedBlock)finishedBlock{
    
    self.networkingTaskFinishedBlock =finishedBlock;
    [self prepareRequest];
}

-(void)finishedTaskWithCustomQueue:(AFNetworkingTaskFinishedBlock)finishedBlock{
    
    self.networkingTaskFinishedBlock =finishedBlock;
    manager.completionQueue = [[self class] afnet_sharedafnetworkCompletionQueue];
    [self prepareRequest];
}


-(void)buildPostFileRequest:(NSString *)url files:(NSDictionary *)files{
    sessionTask =[manager UPLOAD:url parameters:nil files:files progress:^(CGFloat progress) {
        
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [self processDictionary:responseObject];
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostFileRequest:%@",exception);
        }
        @finally {
            [self processResponse:responseObject target:target errorCode:errorCode httpStatusCode:httpStatusCode];
            
            @try {
                if(self.networkingTaskFinishedBlock){
                    self.networkingTaskFinishedBlock(self,self.taskResponse,nil);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"buildPostFileRequest:%@",exception);
            }
        }
        
        
    }];
    
}

-(void)buildPostFileRequest:(NSString *)url form:(NSDictionary *)form files:(NSDictionary *)files{
    sessionTask =[manager UPLOAD:url parameters:form files:files progress:^(CGFloat progress) {
        
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [self processDictionary:responseObject];
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostFileRequest:%@",exception);
        }
        @finally {
            [self processResponse:responseObject target:target errorCode:errorCode httpStatusCode:httpStatusCode];
            
            @try {
                if(self.networkingTaskFinishedBlock){
                    self.networkingTaskFinishedBlock(self,self.taskResponse,nil);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"buildPostFileRequest:%@",exception);
            }
        }
        
        
    }];
    
}
-(void)buildPostRequest:(NSString *)url form:(NSDictionary *)form{
    
    sessionTask =[manager POST:url parameters:form processResult:^(id responseObject) {
        [self processDictionary:responseObject];
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [self processResponse:responseObject target:target errorCode:errorCode httpStatusCode:httpStatusCode];
            
            if(self.networkingTaskFinishedBlock){
                self.networkingTaskFinishedBlock(self,self.taskResponse,nil);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostRequest:%@",exception);
        }
    }];
    
}
-(void)buildGetRequest:(NSString *)url{
    
    [self buildGetRequest:url form:nil];
    
}

-(void)buildGetRequest:(NSString *)url form:(NSDictionary *)form{
    sessionTask =[manager GET:url parameters:form processResult:^(id responseObject) {
        [self processDictionary:responseObject];
        
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [self processResponse:responseObject target:target errorCode:errorCode httpStatusCode:httpStatusCode];
            
            if(self.networkingTaskFinishedBlock){
                self.networkingTaskFinishedBlock(self,self.taskResponse,nil);
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"buildGetRequest:%@",exception);
        }
    }];
}


-(void)buildDeleteRequest:(NSString *)url {
    sessionTask =[manager DELETE:url parameters:nil processResult:^(id responseObject) {
        [self processDictionary:responseObject];
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            
            [self processResponse:responseObject target:target errorCode:errorCode httpStatusCode:httpStatusCode];
            
            if(self.networkingTaskFinishedBlock){
                self.networkingTaskFinishedBlock(self,self.taskResponse,nil);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"buildDeleteRequest:%@",exception);
        }
    }];
}
-(void)cancel{
    [sessionTask cancel];
}

-(void)processResponse:(id)responseObject target:(id)target errorCode:(AFNetworkStatusCode)errorCode  httpStatusCode:(NSInteger)httpStatusCode{
    errorMsg.errorCode =errorCode;
    errorMsg.errorCode =httpStatusCode;
    
    // TODO  处理
}

-(BOOL)requestSuccess{
    return [errorMsg isSuccess];
}
-(void)prepareRequest{
    NSException *exction =[[NSException alloc] initWithName:@"需要实现方法" reason:@"----prepareRequest----" userInfo:nil];
    @throw exction;
}
-(void)processDictionary:(id)dictionary{
    
    NSException *exction =[[NSException alloc] initWithName:@"需要实现方法" reason:@"----processDictionary:----" userInfo:nil];
    @throw exction;
}

@end
