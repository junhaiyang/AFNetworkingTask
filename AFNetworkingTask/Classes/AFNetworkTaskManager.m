 

#import "AFNetworkTaskManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSObject+DictionaryData.h"


@interface AFNetworkTaskManager(){

}



@end

@implementation AFNetworkTaskManager

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
        responseSerializer= [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml", @"text/asa" ,@"text/asp",@"text/scriptlet",@"text/vnd.wap.wml",@"text/plain",@"text/webviewhtml",@"text/x-ms-odc",@"text/css",@"text/vnd.rn-realtext3d",@"text/vnd.rn-realtext",@"text/iuls",@"text/x-vcard",nil];
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

+ (AFNetworkTask *)GET:(NSString *)URLString
            parameters:(id)parameters
                target:(id)target
              selector:(SEL)aSelector
                finish:(AFNetworkTaskFinishedBlock)finish{
    AFNetworkTaskManager *manager =[[AFNetworkTaskManager alloc] init];
    
    
    return  (AFNetworkTask *)[manager GET:URLString parameters:parameters  success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [manager processResult:responseObject target:target selector:aSelector  finish:finish statusCode:operation.response.statusCode];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
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
    
    
    return  (AFNetworkTask *)[manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [manager processResult:responseObject target:target selector:aSelector  finish:finish statusCode:operation.response.statusCode];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
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
    
    return  (AFNetworkTask *)[manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [manager processResult:responseObject target:target selector:aSelector  finish:finish statusCode:operation.response.statusCode];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
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
    
    return  (AFNetworkTask *)[manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [manager processResult:responseObject target:target selector:aSelector  finish:finish statusCode:operation.response.statusCode];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
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
    
    return  (AFNetworkTask *)[manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [manager processResult:responseObject processResult:processResult finish:finish statusCode:operation.response.statusCode];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
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
    
    return  (AFNetworkTask *)[manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [manager processResult:responseObject processResult:processResult finish:finish statusCode:operation.response.statusCode];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
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
            
            NSData *data = (NSData *)responseObject;
            NSString *string = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
            if(processResult){
                processResult(string);
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
