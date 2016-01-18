

#import "UIImageView+AFNetworking.h"
#import "AFAutoPurgingImageCache.h"

#import "TMCache.h"


@protocol AFGIFCache;

@interface UIImageView (AFNetworkGIFTask)

+ (_Nonnull id <AFGIFCache>)sharedImageCache;


- (void)setImageWithURL:(NSURL * _Nonnull )url
       placeholderImage:(nullable UIImage *)placeholderImage
                success:(nullable void (^)(NSURLRequest * __nullable request, NSHTTPURLResponse * __nullable response, UIImage * __nullable image))success
                failure:(nullable void (^)(NSURLRequest * __nullable  request, NSHTTPURLResponse * __nullable response, NSError *__nullable error))failure;

@end

typedef NS_ENUM(NSInteger, AFGIFCacheType) {
    AFGIFCacheTypeAll = 0,
    AFGIFCacheTypeMemory = 1,
    AFGIFCacheTypeDisk = 2
};

@protocol AFGIFCache<AFImageRequestCache>
 @optional
-(void)cleanCache:(AFGIFCacheType)cacheType finish:(_Nonnull TMCacheBlock)block;

-(NSString* _Nonnull )descriptionOfByteCount;
-(NSString* _Nonnull )descriptionOfByteCountWithEmptyString:(NSString* _Nonnull )emptyString;
@end
