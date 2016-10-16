 

#import "AFNetworkTask.h"
#import "MJExtension.h"
#import "AFNetworkDataBlockAdapter.h"
#import "AFNetworkDataCovertModelAdapter.h"

@implementation AFNetworkMsg

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


-(void)recyle{
    self.responseHeaders = nil;
}
-(void)dealloc{
#if DEBUG
    NSLog(@"------%@ dealloc",self.class);
#endif
}

@end

//@interface AFNetworkContainer(AFNetworkTask)
//
////执行适配器操作
//-(void)sessionRequestAdapter:(NSMutableURLRequest * _Nonnull)request;
//-(void)sessionResponseAdapter:(NSHTTPURLResponse * _Nonnull)response msg:(AFNetworkMsg * _Nullable)msg;
//
////返回处理结果
//-(id _Nullable)processSuccessWithTask:(NSURLSessionTask * _Nonnull)task response:(NSHTTPURLResponse * _Nonnull)response msg:(AFNetworkMsg * _Nullable)msg originalObj:(id _Nullable)originalObj;
//-(void)processFailWithTask:(NSURLSessionTask * _Nonnull)task msg:(AFNetworkMsg * _Nullable)msg error:(NSError *_Nullable)error;
//
//@end

@interface AFNetworkTask()

@property (nonatomic,strong) NSMutableArray<AFNetworkDataAdapter *>  * _Nonnull dataAdapters NS_AVAILABLE_IOS(7_0);  //请求协议类型

@property (nonatomic,strong) NSURLSessionTask *sessionTask;
@property (nonatomic,strong) AFNetworkMsg *msg;
@property (nonatomic,strong) AFNetworkTaskSession *networkTaskSession;


@end

@implementation AFNetworkTask
@synthesize dataAdapters;

- (instancetype _Nonnull)initWithTaskSession:(AFNetworkTaskSession * _Nonnull)session
{
    self = [super init];
    if (self) {
        
        dataAdapters= [[NSMutableArray alloc] initWithCapacity:0];
        self.networkTaskSession = session;
        self.msg = [AFNetworkMsg new];
         
    }
    return self;
}


-(void)addDataAdapter:(AFNetworkDataAdapter * _Nonnull)adapter{
    if([[dataAdapters lastObject] isKindOfClass:[AFNetworkDataBlockAdapter class]])
        [dataAdapters insertObject:adapter atIndex:dataAdapters.count-1];
    else
        [dataAdapters addObject:adapter];
}

-(void)addDefaultStructure:(Class)clazz{
    AFNetworkDataCovertModelAdapter * _Nonnull dataAdapter =[AFNetworkDataCovertModelAdapter new];
    [dataAdapter addStructure:clazz];
    [self addDataAdapter:dataAdapter];
    
}
-(void)addDataBlock:(AFNetworkingTaskDataBlock _Nullable)dataBlock{
    AFNetworkDataBlockAdapter * _Nonnull dataAdapter =[AFNetworkDataBlockAdapter new];
    [dataAdapter dataBlock:dataBlock];
    [self addDataAdapter:dataAdapter];
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
                 finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
    __block AFNetworkTask *weakSelf = self;
    
    self.sessionTask =  [self.networkTaskSession GET:URLString parameters:form success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [weakSelf processSuccessResult:responseObject task:task msg:weakSelf.msg  finish:finishedBlock];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [weakSelf processErrorResult:task error:error msg:weakSelf.msg finish:finishedBlock];
        
    }];
    
}
#pragma mark - POST

-(void)POST:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    NSDictionary *from  =[(Class)data mj_keyValues];
    
      [self POST:url form:from finishedBlock:finishedBlock];
}

- (void)POST:(NSString * _Nonnull)URLString
                            form:(NSDictionary * _Nullable)form
                   finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
    __block typeof(self) weakSelf = self;
    
    self.sessionTask = [self.networkTaskSession POST:URLString parameters:form success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [weakSelf processSuccessResult:responseObject task:task  msg:weakSelf.msg finish:finishedBlock];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [weakSelf processErrorResult:task error:error msg:weakSelf.msg finish:finishedBlock];
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
                            form:(NSDictionary * _Nullable)from
                           files:(NSDictionary * _Nullable)files
                   finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
      [self POST:URLString form:from files:files progressBlock:NULL finishedBlock:finishedBlock];
    
}
-(void)POST:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form files:(NSDictionary * _Nullable)files progressBlock:(AFNetworkTaskProgressBlock _Nullable)progressBlock finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
    __block typeof(self) weakSelf = self;
    
    self.sessionTask =   [self.networkTaskSession uploadTaskWithHTTPMethod:@"POST" URLString:URLString parameters:form files:files progressBlock:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [weakSelf processSuccessResult:responseObject task:task msg:weakSelf.msg finish:finishedBlock];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf processErrorResult:task error:error msg:weakSelf.msg finish:finishedBlock];
    }];
    
    
}
#pragma mark - PUT

-(void)PUT:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    NSDictionary *from  =[(Class)data mj_keyValues];
    
      [self PUT:url form:from finishedBlock:finishedBlock];
}

- (void)PUT:(NSString * _Nonnull)URLString
                           form:(NSDictionary * _Nullable)form
                  finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
    __block typeof(self) weakSelf = self;
    
    self.sessionTask =  [self.networkTaskSession PUT:URLString parameters:form success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [weakSelf processSuccessResult:responseObject task:task msg:weakSelf.msg finish:finishedBlock];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [weakSelf processErrorResult:task error:error msg:weakSelf.msg finish:finishedBlock];
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
                  finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
      [self PUT:URLString form:form files:files progressBlock:NULL finishedBlock:finishedBlock];
    
}
-(void)PUT:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form files:(NSDictionary * _Nullable)files progressBlock:(AFNetworkTaskProgressBlock _Nullable)progressBlock finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
    __block typeof(self) weakSelf = self;
    
    self.sessionTask =    [self.networkTaskSession uploadTaskWithHTTPMethod:@"PUT" URLString:URLString parameters:form files:files progressBlock:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [weakSelf processSuccessResult:responseObject task:task msg:weakSelf.msg finish:finishedBlock];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf processErrorResult:task error:error msg:weakSelf.msg finish:finishedBlock];
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
                   finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
    __block typeof(self) weakSelf = self;
    
    self.sessionTask = [self.networkTaskSession PATCH:URLString parameters:form success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [weakSelf processSuccessResult:responseObject task:task msg:weakSelf.msg finish:finishedBlock];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [weakSelf processErrorResult:task error:error msg:weakSelf.msg finish:finishedBlock];
        
    }];
    
    
    
}
#pragma mark - DELETE

-(void)DELETE:(NSString * _Nonnull)url finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
      [self DELETE:url form:nil finishedBlock:finishedBlock];
}
-(void)DELETE:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    NSDictionary *from  =[(Class)data mj_keyValues];
    
        [self DELETE:url form:from finishedBlock:finishedBlock];
}

-(void)DELETE:(NSString * _Nonnull)URLString
                             form:(NSDictionary * _Nullable)form
                    finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
    __block typeof(self) weakSelf = self;
    
    self.sessionTask = [self.networkTaskSession DELETE:URLString parameters:form success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [weakSelf processSuccessResult:responseObject task:task msg:weakSelf.msg finish:finishedBlock];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [weakSelf processErrorResult:task error:error msg:weakSelf.msg finish:finishedBlock];
        
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
                       finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
       [self DOWNLOAD:URLString form:form progressBlock:NULL finishedBlock:finishedBlock];
    
}

-(void)DOWNLOAD:(NSString * _Nonnull)URLString data:(id<AFNetworkRequestData> _Nullable)data progressBlock:(AFNetworkTaskProgressBlock _Nullable)progressBlock finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    NSDictionary *from  =[(Class)data mj_keyValues];
    
       [self DOWNLOAD:URLString form:from progressBlock:progressBlock finishedBlock:finishedBlock];
    
}

-(void)DOWNLOAD:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form progressBlock:(AFNetworkTaskProgressBlock _Nullable)progressBlock finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock{
    
    __block typeof(self) weakSelf = self; 
    
    self.sessionTask =  [self.networkTaskSession downloadTaskWithHTTPMethod:@"GET" URLString:URLString parameters:form  progressBlock:progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [weakSelf processSuccessResult:responseObject task:task msg:weakSelf.msg finish:finishedBlock];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf processErrorResult:task error:error msg:weakSelf.msg finish:finishedBlock];
    }];
    
    
}


#pragma mark - process  Result
-(void)processSuccessResult:(id _Nullable)responseObject task:(NSURLSessionDataTask * _Nonnull)task  msg:(AFNetworkMsg * _Nullable)msg finish:(AFNetworkingTaskFinishedBlock _Nullable)finish{
    NSHTTPURLResponse  *response = (NSHTTPURLResponse  *)task.response;
    
    [self.networkTaskSession.container sessionResponseAdapter:response msg:msg];
    
    id body = [self processSuccessWithTask:task response:response msg:msg originalObj:responseObject];
    if(finish){
        finish(msg,responseObject,body);
    }
    
    [self recyle];
    
}
-(void)processErrorResult:(NSURLSessionDataTask * _Nonnull)task error:(NSError * _Nullable)error msg:(AFNetworkMsg * _Nullable)msg finish:(AFNetworkingTaskFinishedBlock _Nullable)finish{
    [self processFailWithTask:task msg:msg error:error];
    if(finish){
        finish(msg,nil,nil);
    }
    
    [self recyle];
    
}


-(id)processSuccessWithTask:(NSURLSessionTask * _Nonnull)task response:(NSHTTPURLResponse * _Nonnull)response  msg:(AFNetworkMsg * _Nullable)msg  originalObj:(id _Nullable)originalObj{
    id parentObj = originalObj;
    id returnObj = nil;
    
    @try {
        for (AFNetworkDataAdapter * _Nonnull adapter in self.dataAdapters) {
            id returnValue = nil;
            AFNetworkDataType  dataType=  [adapter processSuccessWithTask:task originalObj:originalObj parentObj:parentObj msg:msg returnObj:&returnValue];
            parentObj = returnValue;
            if(dataType == AFNetworkDataTypeData&&returnValue!=nil){
                returnObj = returnValue;
                //                break;
            }
        }
        msg.errorCode = AFNetworkStatusCodeSuccess;
    } @catch (NSException *exception) {
        msg.errorCode = AFNetworkStatusCodeDataError;
    }
    
    
    return returnObj;
}
-(void)processFailWithTask:(NSURLSessionTask * _Nonnull)task  msg:(AFNetworkMsg * _Nullable)msg error:(NSError * _Nullable)error{
    for (AFNetworkDataAdapter * _Nonnull adapter in self.dataAdapters) {
        [adapter processFailWithTask:task msg:msg error:error];
    }
    msg.errorCode = AFNetworkStatusCodeHttpError;
    msg.httpStatusCode = error.code;
}

-(void)recyle{
    
    self.networkTaskSession= nil;
    [self.msg recyle];
    self.msg= nil;
    self.sessionTask= nil;
    
    for (AFNetworkDataAdapter * _Nonnull adapter in self.dataAdapters) {
        [adapter recyle];
    }
    [dataAdapters removeAllObjects];
    dataAdapters = nil;
    
}
-(void)cancel{
    [self.sessionTask cancel];
}
-(void)dealloc{
#if DEBUG
        NSLog(@"------%@ dealloc",self.class);
#endif
}
@end
