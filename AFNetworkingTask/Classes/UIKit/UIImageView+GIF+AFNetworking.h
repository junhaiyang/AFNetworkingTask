

#import "UIImageView+AFNetworking.h"

#import "TMCache.h"


@protocol AFGIFCache;

@interface UIImageView (AFNetworkGIFTask)

+ (id <AFGIFCache>)sharedImageCache;

+ (void)setSharedImageCache:(id <AFGIFCache>)imageCache;

@end

typedef NS_ENUM(NSInteger, AFGIFCacheType) {
    AFGIFCacheTypeAll = 0,
    AFGIFCacheTypeMemory = 1,
    AFGIFCacheTypeDisk = 2
};

@protocol AFGIFCache<AFImageCache>


-(void)cleanCache:(AFGIFCacheType)cacheType finish:(TMCacheBlock)block;

-(NSString*)descriptionOfByteCount;
-(NSString*)descriptionOfByteCountWithEmptyString:(NSString*)emptyString;
@end
