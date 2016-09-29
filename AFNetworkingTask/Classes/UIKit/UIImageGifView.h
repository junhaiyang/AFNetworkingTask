
#import "AFNetworkSwiftDefine.h"

#ifdef AF_NETWORK_SWIFT
    #import <YLGIFImage/YLImageView.h>
#else
    #import "YLImageView.h"
#endif

@interface UIImageGifView : YLImageView

@end
