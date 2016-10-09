 

#import <Foundation/Foundation.h>
#import "AFNetworkTaskHelper.h"
#import "AFNetworkContainer.h"

@class AFNetworkMsg;
@class AFHTTPResponseSerializer;
@class AFHTTPRequestSerializer;

@protocol AFURLResponseSerialization;
@protocol AFURLRequestSerialization;


@interface AFNetworkSerializerAdapter : NSObject

-(AFHTTPResponseSerializer<AFURLResponseSerialization> * _Nonnull)responseSerializer:(AFNetworkProtocolType)responseType;
-(AFHTTPRequestSerializer<AFURLRequestSerialization> * _Nonnull)requestSerializer:(AFNetworkProtocolType)requestType;

-(void)recyle; //自定义对象时声明的新参数一定要自己回收下

@end

@interface AFNetworkSessionAdapter : NSObject

-(void)sessionRequest:(NSMutableURLRequest * _Nonnull)request;
-(void)sessionResponse:(NSHTTPURLResponse * _Nonnull)response msg:(AFNetworkMsg * _Nullable)msg;

-(void)recyle; //自定义对象时声明的新参数一定要自己回收下

@end

@interface AFNetworkDataAdapter : NSObject

    

//返回处理结果
-(AFNetworkDataType)processSuccessWithTask:(NSURLSessionTask * _Nonnull)task originalObj:(id _Nullable)originalObj parentObj:(id _Nullable)parentObj msg:(AFNetworkMsg * _Nullable)msg returnObj:(__nullable id * _Nullable)returnObj;

-(id _Nullable)processFailWithTask:(NSURLSessionTask * _Nonnull)task error:(NSError * _Nullable)error;


-(void)recyle; //自定义对象时声明的新参数一定要自己回收下

@end
