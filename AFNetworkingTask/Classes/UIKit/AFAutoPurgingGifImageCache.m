

#import "AFAutoPurgingGifImageCache.h"
#import "YLGIFImage.h"
#import "UIImage+YKWebPImage.h"

static UIImage * AFImageWithDataAtScale(NSData *data, CGFloat scale) {
    return [[YLGIFImage alloc] initWithData:data scale:scale];
}

@implementation AFAutoPurgingGifImageCache


static inline NSString * AFGIFCacheKeyFromURLRequest(NSURLRequest *request) {
    return [[request URL] absoluteString];
}


- (void)addImage:(UIImage *)image withIdentifier:(NSString *)identifier{}
- (BOOL)removeImageWithIdentifier:(NSString *)identifier{return YES;}

- (BOOL)removeAllImages{return YES;}

- (nullable UIImage *)imageWithIdentifier:(NSString *)identifier{return nil;}

- (nullable UIImage *)imageforRequest:(NSURLRequest *)request withAdditionalIdentifier:(NSString *)identifier {
    switch ([request cachePolicy]) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            return nil;
        default:
            break;
    }
    
    NSObject *cachedData =  [self objectForKey:AFGIFCacheKeyFromURLRequest(request)];
    
    return [self imageforObj:cachedData];
}

- (nullable UIImage *)imageforObj:(NSObject *)cachedData {
    UIImage *cachedImage = nil;
    
    if([cachedData isKindOfClass:[NSData class]]){
        cachedImage = [[UIImage alloc] initWithData:(NSData *)cachedData];
    }
     
    if([cachedData isKindOfClass:[UIImage class]]){
        cachedImage = (UIImage *)cachedData;
    }else if([cachedData isKindOfClass:[NSData class]]){
        cachedImage = AFImageWithDataAtScale((NSData *)cachedData,[[UIScreen mainScreen] scale]);
    }
    if([cachedImage isKindOfClass:[UIImage class]]||[cachedImage isKindOfClass:[YLGIFImage class]])
        return cachedImage;
    else
        return nil;
}

- (void)addImage:(UIImage *)image forRequest:(NSURLRequest *)request withAdditionalIdentifier:(NSString *)identifier {
    if (image && request) {
        [self setObject:image forKey:AFGIFCacheKeyFromURLRequest(request)];
    } 
}
- (BOOL)removeImageforRequest:(NSURLRequest *)request withAdditionalIdentifier:(nullable NSString *)identifier{
    if (request)
        [self removeObjectForKey:AFGIFCacheKeyFromURLRequest(request)];
    
    return YES;
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

-(NSUInteger)cacheCount{
    NSUInteger byteCount = self.diskCache.byteCount+self.memoryCache.totalCost;
    return byteCount;
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
