 

#import "AFNetworkTaskManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSObject+DictionaryData.h"
#import "AFTextResponseSerializer.h"


#import <CommonCrypto/CommonDigest.h>


@interface AFNetworkTaskManager(){
    
}

@property (nonatomic,strong) AFNetworkTaskProgressBlock progressBlock;


@end

@implementation AFNetworkTaskManager

-(void)dealloc{
    self.progressBlock = NULL;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.responseType = AFNetworkRequestProtocolTypeNormal;
        self.requestType = AFNetworkRequestProtocolTypeNormal;
        
        self.responseSerializer=[self getAFHTTPResponseSerializer];
        self.requestSerializer=[self getAFHTTPRequestSerializer];
    }
    return self;
}


-(AFHTTPResponseSerializer *)getAFHTTPResponseSerializer{
    AFHTTPResponseSerializer *responseSerializer;
    if(self.responseType==AFNetworkResponseProtocolTypeNormal){
        responseSerializer= [AFTextResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml", @"text/asa" ,@"text/asp",@"text/scriptlet",@"text/vnd.wap.wml",@"text/plain",@"text/webviewhtml",@"text/x-ms-odc",@"text/css",@"text/vnd.rn-realtext3d",@"text/vnd.rn-realtext",@"text/iuls",@"text/x-vcard",@"application/json",nil];
    }else{
        responseSerializer= [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/xml", @"application/xml",@"application/x-gzip", nil];
    }
    
    responseSerializer.acceptableStatusCodes  = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 300)];
    
    
    return responseSerializer;
}

-(AFHTTPRequestSerializer *)getAFHTTPRequestSerializer{
    AFHTTPRequestSerializer *requestSerializer;
    if(self.requestType==AFNetworkRequestProtocolTypeJSON){
        requestSerializer= [AFJSONRequestSerializer serializer];
        //去掉所有限制
        //         requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:nil, nil];
    } else {
        requestSerializer= [AFHTTPRequestSerializer serializer];
    }
    
    
    return requestSerializer;
}

-(void)buildCommonHeader:(AFHTTPRequestSerializer *)requestSerializer{
    
}

+ (AFNetworkTask *)GET:(NSString *)URLString
            parameters:(id)parameters
                target:(id)target
              selector:(SEL)aSelector
                finish:(AFNetworkTaskFinishedBlock)finish{
    AFNetworkTaskManager *manager =[[AFNetworkTaskManager alloc] init];
    
    return [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSHTTPURLResponse  *response = (NSHTTPURLResponse  *)task.response;
        
        [manager processResult:responseObject target:target selector:aSelector  finish:finish statusCode:response.statusCode];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if(finish){
            finish(nil,AFNetworkStatusCodeProcessError,AFNetworkStatusCodeHttpError);
        }
    }];
     
}

+ (AFNetworkTask *)POST:(NSString *)URLString
            parameters:(id)parameters
                 files:(id)files
                target:(id)target
              selector:(SEL)aSelector
                finish:(AFNetworkTaskFinishedBlock)finish{
    
    
    AFNetworkTaskManager *manager =[[AFNetworkTaskManager alloc] init];
    
    return [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSString *key  in files) {
            NSObject *fileObj =[files objectForKey:key];
            
            if([fileObj isKindOfClass:[NSString class]]){
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:(NSString *)fileObj] name:key error:NULL];
            }else  if([fileObj isKindOfClass:[NSData class]]){
                [formData appendPartWithFormData:(NSData *)fileObj name:key];
            }
            
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSHTTPURLResponse  *response = (NSHTTPURLResponse  *)task.response;
        [manager processResult:responseObject target:target selector:aSelector  finish:finish statusCode:response.statusCode];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if(finish){
            finish(nil,AFNetworkStatusCodeProcessError,AFNetworkStatusCodeHttpError);
        }
    }];
    
    
}
+ (AFNetworkTask *)POST:(NSString *)URLString
                target:(id)target
              selector:(SEL)aSelector
                finish:(AFNetworkTaskFinishedBlock)finish{
    
    AFNetworkTaskManager *manager =[[AFNetworkTaskManager alloc] init];
    
    NSDictionary *parameters =[NSObject transformObjcToDictionary:target];
    
    if(parameters.count==0)
        parameters = nil;
     
    return [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSHTTPURLResponse  *response = (NSHTTPURLResponse  *)task.response;
        
        [manager processResult:responseObject target:target selector:aSelector  finish:finish statusCode:response.statusCode];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if(finish){
            finish(nil,AFNetworkStatusCodeProcessError,AFNetworkStatusCodeHttpError);
        }
    }];
    
    
}
+ (AFNetworkTask *)GET:(NSString *)URLString
                target:(id)target
              selector:(SEL)aSelector
                finish:(AFNetworkTaskFinishedBlock)finish{
    
    AFNetworkTaskManager *manager =[[AFNetworkTaskManager alloc] init];
    
    NSDictionary *parameters =[NSObject transformObjcToDictionary:target];
    
    if(parameters.count==0)
        parameters = nil;
    
    return [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSHTTPURLResponse  *response = (NSHTTPURLResponse  *)task.response;
        
        [manager processResult:responseObject target:target selector:aSelector  finish:finish statusCode:response.statusCode];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if(finish){
            finish(nil,AFNetworkStatusCodeProcessError,AFNetworkStatusCodeHttpError);
        }
    }];
    
}

+ (AFNetworkTask *)GET:(NSString *)URLString
            parameters:(id)parameters
         processResult:(AFNetworkTaskProcessResultBlock)processResult
                finish:(AFNetworkTaskFinishedBlock)finish{
    
    AFNetworkTaskManager *manager =[[AFNetworkTaskManager alloc] init];
     
    return [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSHTTPURLResponse  *response = (NSHTTPURLResponse  *)task.response;
        
        [manager processResult:responseObject processResult:processResult finish:finish statusCode:response.statusCode];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if(finish){
            finish(nil,AFNetworkStatusCodeProcessError,AFNetworkStatusCodeHttpError);
        }
    }];
    
}

+ (AFNetworkTask *)POST:(NSString *)URLString
             parameters:(id)parameters
          processResult:(AFNetworkTaskProcessResultBlock)processResult
                 finish:(AFNetworkTaskFinishedBlock)finish{
    
    AFNetworkTaskManager *manager =[[AFNetworkTaskManager alloc] init];
    
    return [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSHTTPURLResponse  *response = (NSHTTPURLResponse  *)task.response;
        
        [manager processResult:responseObject processResult:processResult finish:finish statusCode:response.statusCode];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if(finish){
            finish(nil,AFNetworkStatusCodeProcessError,AFNetworkStatusCodeHttpError);
        }
    }];
}
+ (AFNetworkTask *)DELETE:(NSString *)URLString
             parameters:(id)parameters
          processResult:(AFNetworkTaskProcessResultBlock)processResult
                 finish:(AFNetworkTaskFinishedBlock)finish{
    
    AFNetworkTaskManager *manager =[[AFNetworkTaskManager alloc] init];
     
    return [manager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSHTTPURLResponse  *response = (NSHTTPURLResponse  *)task.response;
        
        [manager processResult:responseObject processResult:processResult finish:finish statusCode:response.statusCode];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if(finish){
            finish(nil,AFNetworkStatusCodeProcessError,AFNetworkStatusCodeHttpError);
        }
    }];
}

- (NSURLSessionUploadTask *)downloadTaskWithHTTPMethod:(NSString *)method
                                             URLString:(NSString *)URLString
                                            parameters:(id)parameters
                                               success:(void (^)(NSURLSessionDataTask *, id))success
                                               failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    NSProgress *progress;
    
    __weak AFNetworkTaskManager *weakSelf = self;
    
    dataTask = [self downloadTaskWithRequest:request progress:&progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [[self class] pathWithURL:URLString];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                success(dataTask, filePath);
            }
        }
        if(weakSelf.progressBlock){
            weakSelf.progressBlock(1.0);
        }
        
        // 结束后移除掉这个progress
        [progress removeObserver:self
                      forKeyPath:@"fractionCompleted"
                         context:NULL];
    }];
    
    // 给这个progress添加监听任务
    [progress addObserver:self
               forKeyPath:@"fractionCompleted"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionUploadTask *)uploadTaskWithHTTPMethod:(NSString *)method
                                           URLString:(NSString *)URLString
                                          parameters:(id)parameters
                           constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                             success:(void (^)(NSURLSessionDataTask *, id))success
                                             failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];
    
     
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil; 
    
    NSProgress *progress;
    
    dataTask = [self uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                success(dataTask, responseObject);
            }
        }
        
        // 结束后移除掉这个progress
        [progress removeObserver:self
                      forKeyPath:@"fractionCompleted"
                         context:NULL];
    }]; 
    
    // 给这个progress添加监听任务
    [progress addObserver:self
               forKeyPath:@"fractionCompleted"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    
    [dataTask resume];
    
    return dataTask;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *)object;
        
        if(self.progressBlock){
            self.progressBlock(progress.fractionCompleted);
        }
         
    }
}


+ (AFNetworkTask *)UPLOAD:(NSString *)URLString
               parameters:(id)parameters
                    files:(id)files
                 progress:(AFNetworkTaskProgressBlock)progress
                   finish:(AFNetworkTaskFinishedBlock)finish{
    
    AFNetworkTaskManager *manager =[[AFNetworkTaskManager alloc] init];
    
    manager.progressBlock = progress;
    
    
    return [manager uploadTaskWithHTTPMethod:@"POST" URLString:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (NSString *key  in files) {
            NSObject *fileObj =[files objectForKey:key];
            
            if([fileObj isKindOfClass:[NSString class]]){
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:(NSString *)fileObj] name:key error:NULL];
            }else  if([fileObj isKindOfClass:[NSData class]]){
                [formData appendPartWithFormData:(NSData *)fileObj name:key];
            }
            
        }

        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSHTTPURLResponse  *response = (NSHTTPURLResponse  *)task.response;
        
        [manager processResult:responseObject processResult:NULL finish:finish statusCode:response.statusCode];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if(finish){
            finish(nil,AFNetworkStatusCodeProcessError,AFNetworkStatusCodeHttpError);
        }
    }];
}


+ (NSString *)md5StringForString:(NSString *)string {
    if(string==nil)
        return [NSString stringWithFormat:@"%lld",(long long)([[NSDate date] timeIntervalSince1970] *1000.0)];
    const char *str = [string UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (uint32_t)strlen(str), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}

+(NSURL *)pathWithURL:(NSString *)URLString{
    
    
    NSString * temp = NSTemporaryDirectory();
    
    NSFileManager *manager =[NSFileManager defaultManager];
    if(![manager fileExistsAtPath:[temp stringByAppendingPathComponent:@"httpCache"]]){
        [manager createDirectoryAtPath:[temp stringByAppendingPathComponent:@"httpCache"] withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:[temp stringByAppendingPathComponent:@"httpCache"]];
    
    return [documentsDirectoryURL URLByAppendingPathComponent:[[self class] md5StringForString:URLString]];

}

+ (AFNetworkTask *)DOWNLOAD:(NSString *)URLString
                 parameters:(id)parameters
                   progress:(AFNetworkTaskProgressBlock)progress
                     finish:(AFNetworkTaskFinishedBlock)finish{
    AFNetworkTaskManager *manager =[[AFNetworkTaskManager alloc] init];
    
    
    manager.responseType = AFNetworkResponseProtocolTypeFile;
    
    manager.progressBlock = progress;
    
    return [manager downloadTaskWithHTTPMethod:@"GET" URLString:URLString parameters:parameters  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        
        NSHTTPURLResponse  *response = (NSHTTPURLResponse  *)task.response;
        
        [manager processResult:responseObject processResult:NULL finish:finish statusCode:response.statusCode];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        
        if(finish){
            finish(nil,AFNetworkStatusCodeProcessError,AFNetworkStatusCodeHttpError);
        }
    }];
}
 

#pragma mark - process  Result
-(void)processResult:(id)responseObject processResult:(AFNetworkTaskProcessResultBlock)processResult finish:(AFNetworkTaskFinishedBlock)finish statusCode:(NSInteger)statusCode{
    @try {
        
        if(self.responseType==AFNetworkResponseProtocolTypeFile){
            if(processResult){
                processResult(responseObject);
            }
        }else if(self.responseType==AFNetworkResponseProtocolTypeNormal){
            
//            NSData *data = (NSData *)responseObject;
//            NSString *string = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
            if(processResult){
                processResult(responseObject);
            }
        }else{
            if(processResult){
                processResult(responseObject);
            }
        }
        if(finish){
            finish(responseObject,AFNetworkStatusCodeSuccess,statusCode);
        }
        
    }
    @catch (NSException *exception) {
#if DEBUG
        NSLog(@"处理结果失败:%@",exception);
#endif
        if(finish){
            finish(responseObject,AFNetworkStatusCodeProcessError,statusCode);
        }
    }
}
-(void)processResult:(id)responseObject target:(NSObject *)target
            selector:(SEL)aSelector finish:(AFNetworkTaskFinishedBlock)finish statusCode:(NSInteger)statusCode{
    @try {
        
        if(self.responseType==AFNetworkResponseProtocolTypeFile){
            if(target){
                if([target respondsToSelector:aSelector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [target performSelector:aSelector withObject:responseObject];
#pragma clang diagnostic pop
                }
            }
        }else if(self.responseType==AFNetworkResponseProtocolTypeNormal){
            
            NSData *data = (NSData *)responseObject;
            NSString *string = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
            if(target){
                if([target respondsToSelector:aSelector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [target performSelector:aSelector withObject:string];
#pragma clang diagnostic pop
                }
            }
        }else{
            if(target){
                if([target respondsToSelector:aSelector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [target performSelector:aSelector withObject:responseObject];
#pragma clang diagnostic pop
                }
            }
        }
        if(finish){
            finish(responseObject,AFNetworkStatusCodeSuccess,statusCode);
        }
        
    }
    @catch (NSException *exception) {
#if DEBUG
        NSLog(@"处理结果失败:%@",exception);
#endif
        if(finish){
            finish(responseObject,AFNetworkStatusCodeProcessError,statusCode);
        }
    }
}

@end
