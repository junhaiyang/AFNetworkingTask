
#import "AFNetworkSwiftDefine.h"


#ifdef AF_NETWORK_SWIFT
    #import <AFNetworking/AFImageDownloader.h>
#else
    #import "AFImageDownloader.h"
#endif

@interface AFGIfImageDownloader : AFImageDownloader

@end
