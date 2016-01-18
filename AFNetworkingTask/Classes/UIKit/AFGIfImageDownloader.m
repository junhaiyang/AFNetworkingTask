 

#import "AFGIfImageDownloader.h"
#import "AFGIFResponseSerializer.h"
#import "AFAutoPurgingGifImageCache.h"

@implementation AFGIfImageDownloader



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManager.responseSerializer = [AFGIFResponseSerializer serializer];
        
        NSArray *pathcaches=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString* cacheDirectory  = [pathcaches objectAtIndex:0];
        AFAutoPurgingGifImageCache *_af_defaultImageCache = [[AFAutoPurgingGifImageCache alloc] initWithName:@"gifCache" rootPath:cacheDirectory];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * __unused notification) {
            [_af_defaultImageCache.memoryCache removeAllObjects];
        }];
        
        self.imageCache =_af_defaultImageCache;
        
    }
    return self;
}

+ (instancetype)defaultInstance {
    static AFGIfImageDownloader *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
