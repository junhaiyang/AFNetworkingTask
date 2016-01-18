

#import "UIImageView+GIF+AFNetworking.h"
#import <objc/runtime.h>
#import "AFGIfImageDownloader.h"
#import "AFAutoPurgingGifImageCache.h" 


 
@implementation UIImageView (AFNetworkGIFTask)

+ (AFImageDownloader *)sharedImageDownloader {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    return objc_getAssociatedObject(self, @selector(sharedImageDownloader)) ?: [AFGIfImageDownloader defaultInstance];
#pragma clang diagnostic pop
}

+ (void)setSharedImageDownloader:(AFImageDownloader *)imageDownloader {
    objc_setAssociatedObject(self, @selector(sharedImageDownloader), imageDownloader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


+ (id <AFGIFCache>)sharedImageCache{
    return [UIImageView sharedImageDownloader].imageCache;
}
 

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(nullable UIImage *)placeholderImage
                success:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * __nullable response, UIImage *image))success
                failure:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * __nullable response, NSError *error))failure{

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:success failure:failure];
}

@end
