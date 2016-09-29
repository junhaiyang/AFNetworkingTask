
#import "AFNetworkLibDefine.h"


#ifdef AF_NETWORK_DYLIB
    #import <AFNetworking/AFImageDownloader.h>
#else
    #import "AFImageDownloader.h"
#endif

@interface AFGIfImageDownloader : AFImageDownloader

@end
