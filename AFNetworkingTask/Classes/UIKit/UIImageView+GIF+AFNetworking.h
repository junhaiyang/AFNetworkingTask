

#import "AFAutoPurgingImageCache.h"

#import "TMCache.h"
@class AFImageDownloadReceipt;

@protocol AFGIFCache;

@interface UIImageView (AFNetworkGIFTask)


@property (readwrite, nonatomic, strong, setter = af_setActiveImageDownloadReceipt:) AFImageDownloadReceipt *af_activeImageDownloadReceipt;

+ (_Nonnull id <AFGIFCache>)sharedImageCache;


- (void)setImageWithURL:(NSURL *)url;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage;
- (void)setImageWithURL:(NSURL * _Nonnull )url
       placeholderImage:(nullable UIImage *)placeholderImage
                success:(nullable void (^)(NSURLRequest * __nullable request, NSHTTPURLResponse * __nullable response, UIImage * __nullable image))success
                failure:(nullable void (^)(NSURLRequest * __nullable  request, NSHTTPURLResponse * __nullable response, NSError *__nullable error))failure;


- (void)clearActiveDownloadInformation;

- (BOOL)isActiveTaskURLEqualToURLRequest:(NSURLRequest *)urlRequest;

@end

typedef NS_ENUM(NSInteger, AFGIFCacheType) {
    AFGIFCacheTypeAll = 0,
    AFGIFCacheTypeMemory = 1,
    AFGIFCacheTypeDisk = 2
};

@protocol AFGIFCache<AFImageRequestCache>
 @optional
-(void)cleanCache:(AFGIFCacheType)cacheType finish:(_Nonnull TMCacheBlock)block;

-(NSUInteger)cacheCount;

-(NSString* _Nonnull )descriptionOfByteCount;
-(NSString* _Nonnull )descriptionOfByteCountWithEmptyString:(NSString* _Nonnull )emptyString;
@end
