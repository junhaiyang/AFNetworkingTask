 

#import "AFNetworkTaskSessionPatch.h" 

#import "AFTextResponseSerializer.h"
#import "AFNetworkActivityLogger.h"


#import <CommonCrypto/CommonDigest.h>


 

@interface AFNetworkTaskSessionPatch()


@end

@implementation AFNetworkTaskSessionPatch
@synthesize container;

+(dispatch_queue_t)afnet_shared_afnetworkCompletionQueue {
    static dispatch_queue_t  afnet_shared_afnetworkCompletionQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        afnet_shared_afnetworkCompletionQueue = dispatch_queue_create("afnet_shared_afnetworkCompletionQueue", nil);
    });
    
    return afnet_shared_afnetworkCompletionQueue;
}
 

- (nullable NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
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
    [self.container sessionRequestAdapter:request];
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                               if (failure) {
                                   failure(dataTask, error);
                               }
                           } else {
                               if (success) {
                                   success(dataTask, responseObject);
                               }
                           }
                       }];
    [[NSNotificationCenter defaultCenter] postNotificationName:AFNetworkingTaskDidRequestNotification object:dataTask];
    
    return dataTask;
}

- (nullable NSURLSessionUploadTask *)downloadTaskWithHTTPMethod:(NSString *)method
                                             URLString:(NSString *)URLString
                                            parameters:(id)parameters
                                               progressBlock:(AFNetworkTaskProgressBlock _Nullable)progressBlock
                                               success:(void (^)(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject))success
                                               failure:(void (^)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error))failure
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
    [self.container sessionRequestAdapter:request];
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    __block typeof(self) weakSelf = self;
    
    dataTask = [self downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        if(progressBlock){
            progressBlock(downloadProgress.fractionCompleted);
        }
        
        
     } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
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
        
    }];
    
    
    [dataTask resume];
    [[NSNotificationCenter defaultCenter] postNotificationName:AFNetworkingTaskDidRequestNotification object:dataTask];
    
    return dataTask;
}

- (nullable NSURLSessionUploadTask *)uploadTaskWithHTTPMethod:(NSString *)method
                                           URLString:(NSString *)URLString
                                          parameters:(id)parameters
                                                        files:(id)files
                                                progressBlock:(AFNetworkTaskProgressBlock _Nullable)progressBlock
                                             success:(void (^)(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject))success
                                             failure:(void (^)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error))failure
{
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (NSString *key  in files) {
            NSObject *fileObj =[files objectForKey:key];
            
            if([fileObj isKindOfClass:[NSString class]]){
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:(NSString *)fileObj] name:key error:NULL];
            }else  if([fileObj isKindOfClass:[NSData class]]){
                [formData appendPartWithFormData:(NSData *)fileObj name:key];
            }
            
        }
        
        
    } error:nil];
    
    [self.container sessionRequestAdapter:request];
     
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
    
//   __block NSProgress *progress;
    
    dataTask = [self uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if(progressBlock){
            progressBlock(downloadProgress.fractionCompleted);
        }
        
        
    }  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                success(dataTask, responseObject);
            }
        }
        
    }];
    
    [dataTask resume];
    [[NSNotificationCenter defaultCenter] postNotificationName:AFNetworkingTaskDidRequestNotification object:dataTask];
    
    return dataTask;
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

+(NSURL * _Nonnull)pathWithURL:(NSString * _Nonnull)URLString{
    
    
    NSString * temp = NSTemporaryDirectory();
    
    NSFileManager *manager =[NSFileManager defaultManager];
    if(![manager fileExistsAtPath:[temp stringByAppendingPathComponent:@"httpCache"]]){
        [manager createDirectoryAtPath:[temp stringByAppendingPathComponent:@"httpCache"] withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:[temp stringByAppendingPathComponent:@"httpCache"]];
    
    return [documentsDirectoryURL URLByAppendingPathComponent:[[self class] md5StringForString:URLString]];

}
 

@end
