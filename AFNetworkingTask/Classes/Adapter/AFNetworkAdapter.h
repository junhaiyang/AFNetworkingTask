 

#import <Foundation/Foundation.h>
#import "AFNetworkTaskHelper.h"
#import "AFNetworkContainer.h"

@class AFNetworkMsg;
@class AFHTTPResponseSerializer;
@class AFHTTPRequestSerializer;

@protocol AFURLResponseSerialization;
@protocol AFURLRequestSerialization;


@interface AFNetworkSerializerAdapter : NSObject

-(AFHTTPResponseSerializer<AFURLResponseSerialization> * _Nonnull)responseSerializer:(AFNetworkResponseProtocolType)responseType;
-(AFHTTPRequestSerializer<AFURLRequestSerialization> * _Nonnull)requestSerializer:(AFNetworkRequestProtocolType)requestType;

-(void)recyle; //自定义对象时声明的新参数一定要自己回收下

@end

@interface AFNetworkTaskAdapter : NSObject

-(void)request:(NSMutableURLRequest * _Nonnull)request;
-(void)response:(NSHTTPURLResponse * _Nonnull)response msg:(AFNetworkMsg * _Nullable)msg;

-(void)recyle; //自定义对象时声明的新参数一定要自己回收下

@end

@interface AFNetworkDataAdapter : NSObject


//返回处理结果
-(id _Nullable)processSuccessWithTask:(NSURLSessionTask * _Nonnull)task response:(NSHTTPURLResponse * _Nonnull)response  originalObj:(id _Nullable)originalObj parentObj:(id _Nullable)parentObj;

-(id _Nullable)processFailWithTask:(NSURLSessionTask * _Nonnull)task error:(NSError * _Nullable)error;


-(void)recyle; //自定义对象时声明的新参数一定要自己回收下

@end
