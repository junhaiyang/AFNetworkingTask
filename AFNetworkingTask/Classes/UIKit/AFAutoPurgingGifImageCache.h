 

#import "TMCache.h"
#import "UIImageView+GIF+AFNetworking.h"

@interface AFAutoPurgingGifImageCache : TMCache<AFGIFCache>


-(void)cleanCache:(AFGIFCacheType)cacheType finish:(TMCacheBlock)block;

-(NSString*)descriptionOfByteCount;

-(NSString*)descriptionOfByteCountWithEmptyString:(NSString*)emptyString;

@end
