 

#import "AFNetworkLibDefine.h"

#ifdef AF_NETWORK_DYLIB
    #import <TMCache/TMCache.h>
#else
    #import "TMCache.h"
#endif

#import "UIImageView+GIF+AFNetworking.h"

@interface AFAutoPurgingGifImageCache : TMCache<AFGIFCache>


-(void)cleanCache:(AFGIFCacheType)cacheType finish:(TMCacheBlock _Nullable)block;

-(NSString* _Nonnull)descriptionOfByteCount;

-(NSString* _Nonnull)descriptionOfByteCountWithEmptyString:(NSString* _Nonnull)emptyString;


- (nullable UIImage *)imageforObj:(NSObject *_Nullable)cachedData;

@end
