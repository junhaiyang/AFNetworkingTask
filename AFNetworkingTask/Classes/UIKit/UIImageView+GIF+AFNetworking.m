

#import "UIImageView+GIF+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
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
- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(nullable UIImage *)placeholderImage
                success:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * __nullable response, UIImage *image))success
                failure:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * __nullable response, NSError *error))failure{

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:success failure:failure];
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error))failure
{
    
    if ([urlRequest URL] == nil) {
        [self cancelImageDownloadTask];
        self.image = placeholderImage;
        return;
    }
    
    if ([self isActiveTaskURLEqualToURLRequest:urlRequest]){
        return;
    }
    
    [self cancelImageDownloadTask];
    
    AFImageDownloader *downloader = [[self class] sharedImageDownloader];
    id <AFImageRequestCache> imageCache = downloader.imageCache;
    
    //Use the image from the image cache if it exists
    UIImage *cachedImage = [imageCache imageforRequest:urlRequest withAdditionalIdentifier:nil];
    if (cachedImage&&[cachedImage isKindOfClass:[UIImage class]]) {
        if (success) {
            success(urlRequest, nil, cachedImage);
        } else {
            self.image = cachedImage;
        }
        [self clearActiveDownloadInformation];
    } else {
        if (placeholderImage) {
            self.image = placeholderImage;
        }
        
        __weak __typeof(self)weakSelf = self;
        NSUUID *downloadID = [NSUUID UUID];
        AFImageDownloadReceipt *receipt;
        receipt = [downloader
                   downloadImageForURLRequest:urlRequest
                   withReceiptID:downloadID
                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
                       __strong __typeof(weakSelf)strongSelf = weakSelf;
                       if ([strongSelf.af_activeImageDownloadReceipt.receiptID isEqual:downloadID]) {
                           UIImage *showImage = [(AFAutoPurgingGifImageCache *)imageCache imageforObj:responseObject];
                           
                           if (success) {
                               success(request, response, showImage);
                           } else if(responseObject) {
                               strongSelf.image = showImage;
                           }
                           [strongSelf clearActiveDownloadInformation];
                       }
                       
                   }
                   failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                       __strong __typeof(weakSelf)strongSelf = weakSelf;
                       if ([strongSelf.af_activeImageDownloadReceipt.receiptID isEqual:downloadID]) {
                           if (failure) {
                               failure(request, response, error);
                           }
                           [strongSelf clearActiveDownloadInformation];
                       }
                   }];
        
        self.af_activeImageDownloadReceipt = receipt;
    }
}
@end
