

#import "UIImageView+GIF+AFNetworking.h"
#import <objc/runtime.h>
#import "AFGIFResponseSerializer.h"
#import "YLGIFImage.h"

@interface UIImageView (AFNetworkGIFTask)
@property (readwrite, nonatomic, strong, setter = af_setImageRequestOperation:) AFHTTPRequestOperation *af_imageRequestOperation;

+ (NSOperationQueue *)af_sharedImageRequestOperationQueue;
@end


@interface AFGIFCache : TMCache/*NSCache*/ <AFImageCache>
@end


static UIImage * AFImageWithDataAtScale(NSData *data, CGFloat scale) {
    return [[YLGIFImage alloc] initWithData:data scale:scale];
}
 
@implementation UIImageView (AFNetworkGIFTask)

+ (id <AFGIFCache>)sharedImageCache {
    static AFGIFCache *_af_defaultImageCache = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSArray *pathcaches=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString* cacheDirectory  = [pathcaches objectAtIndex:0];
        _af_defaultImageCache = [[AFGIFCache alloc] initWithName:@"gifCache" rootPath:cacheDirectory];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * __unused notification) {
            [_af_defaultImageCache.memoryCache removeAllObjects];
        }];
    });
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    return objc_getAssociatedObject(self, @selector(sharedImageCache)) ?: _af_defaultImageCache;
#pragma clang diagnostic pop
}


- (id <AFURLResponseSerialization>)imageResponseSerializer {
    static id <AFURLResponseSerialization> _af_defaultImageResponseSerializer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_defaultImageResponseSerializer = [AFGIFResponseSerializer serializer];
    });
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    return objc_getAssociatedObject(self, @selector(imageResponseSerializer)) ?: _af_defaultImageResponseSerializer;
#pragma clang diagnostic pop
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    [self cancelImageRequestOperation];
    
    NSObject *cachedData = [[[self class] sharedImageCache] cachedImageForRequest:urlRequest];
    UIImage *cachedImage = nil;
    if([cachedData isKindOfClass:[UIImage class]]){
        cachedImage = (UIImage *)cachedData;
    }else if([cachedData isKindOfClass:[NSData class]]){
        cachedImage = AFImageWithDataAtScale((NSData *)cachedData,[[UIScreen mainScreen] scale]);
    }
    
    if (cachedImage) {
        if (success) {
            success(urlRequest, nil, cachedImage);
        } else {
            
            self.image = cachedImage;
        }
        
        self.af_imageRequestOperation = nil;
    } else {
        if (placeholderImage) {
            self.image = placeholderImage;
        }
        
        __weak __typeof(self)weakSelf = self;
        self.af_imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        self.af_imageRequestOperation.responseSerializer = self.imageResponseSerializer;
        [self.af_imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            @try {
                
                
                UIImage *cachedImage = AFImageWithDataAtScale(responseObject,[[UIScreen mainScreen] scale]);
                
                if ([[urlRequest URL] isEqual:[strongSelf.af_imageRequestOperation.request URL]]) {
                    if (success) {
                        success(urlRequest, operation.response, cachedImage);
                    } else if (responseObject) {
                        strongSelf.image = cachedImage;
                    }
                    
                    if (operation == strongSelf.af_imageRequestOperation){
                        strongSelf.af_imageRequestOperation = nil;
                    }
                }
                [[[strongSelf class] sharedImageCache] cacheImage:responseObject forRequest:urlRequest];
            }
            @catch (NSException *exception) {
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([[urlRequest URL] isEqual:[strongSelf.af_imageRequestOperation.request URL]]) {
                if (failure) {
                    failure(urlRequest, operation.response, error);
                }
                
                if (operation == strongSelf.af_imageRequestOperation){
                    strongSelf.af_imageRequestOperation = nil;
                }
            }
        }];
        
        [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
    }
}

@end


#pragma mark -

static inline NSString * AFGIFCacheKeyFromURLRequest(NSURLRequest *request) {
    return [[request URL] absoluteString];
}


@implementation AFGIFCache


- (NSObject *)cachedImageForRequest:(NSURLRequest *)request {
    switch ([request cachePolicy]) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            return nil;
        default:
            break;
    }
    
    return [self objectForKey:AFGIFCacheKeyFromURLRequest(request)];
}

- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request
{
    if (image && request) {
        [self setObject:image forKey:AFGIFCacheKeyFromURLRequest(request)];
    }
}



-(void)cleanCache:(AFGIFCacheType)cacheType finish:(TMCacheBlock)block
{
    switch (cacheType) {
        case AFGIFCacheTypeAll:
        {
            [self removeAllObjects:block];
            break;
        }
        case AFGIFCacheTypeMemory:
        {
            [self.memoryCache removeAllObjects:^(TMMemoryCache *cache) { if (block) { block(self);}}];
            break;
        }
        case AFGIFCacheTypeDisk:
        {
            [self.diskCache removeAllObjects:^(TMDiskCache *cache) { if (block) { block(self);}}];
            break;
        }
        default:
            break;
    }
}

-(NSString*)descriptionOfByteCount {
    return [self descriptionOfByteCountWithEmptyString:nil];
}

-(NSString*)descriptionOfByteCountWithEmptyString:(NSString*)emptyString
{
    NSUInteger byteCount = self.diskCache.byteCount;
    if (!byteCount && emptyString) {
        return emptyString;
    }
    double kByte = byteCount/1024.f;
    if (kByte < 1024.f) {
        return [NSString stringWithFormat:@"%.2fKB",kByte];
    }
    double mByte = kByte/1024.f;
    if (mByte < 1024.f) {
        return [NSString stringWithFormat:@"%.2fMB",mByte];
    }
    double gByte = mByte/1024.f;
    return [NSString stringWithFormat:@"%.2fGB",gByte];
}

@end
