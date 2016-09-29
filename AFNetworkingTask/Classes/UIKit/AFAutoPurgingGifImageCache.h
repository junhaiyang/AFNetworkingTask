 

#import "AFNetworkLibDefine.h"

#ifdef AF_NETWORK_DYLIB
    #import <TMCache/TMCache.h>
#else
    #import "TMCache.h"
#endif

#import "UIImageView+GIF+AFNetworking.h"

@interface AFAutoPurgingGifImageCache : TMCache<AFGIFCache>


-(void)cleanCache:(AFGIFCacheType)cacheType finish:(TMCacheBlock)block;

-(NSString*)descriptionOfByteCount;

-(NSString*)descriptionOfByteCountWithEmptyString:(NSString*)emptyString;


- (nullable UIImage *)imageforObj:(NSObject *)cachedData;

@end
