
#import "AFNetworkLibDefine.h"

#ifdef AF_NETWORK_DYLIB
    #import <YLGIFImage/YLImageView.h>
#else
    #import "YLImageView.h"
#endif

@interface UIImageGifView : YLImageView

@end
