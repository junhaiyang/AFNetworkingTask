 

#import "AFNetworkBaseProtocol.h"

@implementation AFNetworkBaseProtocol

-(void)finishedWithMainQueue:(AFNetworkingFinishedBlock)finishedBlock{
    self.networkingFinishedBlock =finishedBlock;
    [self prepareRequest];
}
-(void)finishedWithCustomQueue:(AFNetworkingFinishedBlock)finishedBlock{
    self.networkingFinishedBlock =finishedBlock;
    self.completionQueue = [[self class] afnet_sharedafnetworkCompletionQueue];
    [self prepareRequest];
}
-(void)buildPostFileRequest:(NSString *)url files:(NSDictionary *)files{
    [self UPLOAD:url parameters:nil files:files progress:^(CGFloat progress) {
        
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [self processDictionary:responseObject];
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostFileRequest:%@",exception);
        }
        @finally {
            @try {
                if(self.networkingFinishedBlock){
                    self.networkingFinishedBlock(self,errorCode,httpStatusCode);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"buildPostFileRequest:%@",exception);
            }
        }
        
        
    }];
    
}

-(void)buildPostFileRequest:(NSString *)url form:(NSDictionary *)form files:(NSDictionary *)files{
    [self UPLOAD:url parameters:form files:files progress:^(CGFloat progress) {
        
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            [self processDictionary:responseObject];
        }
        @catch (NSException *exception) {
            NSLog(@"buildPostFileRequest:%@",exception);
        }
        @finally {
            @try {
                if(self.networkingFinishedBlock){
                    self.networkingFinishedBlock(self,errorCode,httpStatusCode);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"buildPostFileRequest:%@",exception);
            }
        }
        
        
    }];
    
}
-(void)buildPostRequest:(NSString *)url form:(NSDictionary *)form{
    
    [self POST:url parameters:form processResult:^(id responseObject) {
        [self processDictionary:responseObject];
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            
            if(self.networkingFinishedBlock){
                self.networkingFinishedBlock(self,errorCode,httpStatusCode);
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
    [self GET:url parameters:form processResult:^(id responseObject) {
        [self processDictionary:responseObject];
        
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            if(self.networkingFinishedBlock){
                self.networkingFinishedBlock(self,errorCode,httpStatusCode);
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"buildGetRequest:%@",exception);
        }
    }];
}


-(void)buildDeleteRequest:(NSString *)url {
    [self DELETE:url parameters:nil processResult:^(id responseObject) {
        [self processDictionary:responseObject];
    } finish:^(NSURLSessionTask *task, id responseObject, id target, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        @try {
            if(self.networkingFinishedBlock){
                self.networkingFinishedBlock(self,errorCode,httpStatusCode);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"buildDeleteRequest:%@",exception);
        }
    }];
}

-(BOOL)requestSuccess{
    return YES;
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
