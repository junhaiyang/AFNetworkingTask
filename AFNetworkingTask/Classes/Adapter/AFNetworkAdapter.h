 

#import <Foundation/Foundation.h>
#import "AFNetworkTaskHelper.h"

@class AFNetworkMsg;
@class AFHTTPResponseSerializer;
@class AFHTTPRequestSerializer;

@protocol AFURLResponseSerialization;
@protocol AFURLRequestSerialization;


@interface AFNetworkSerializerAdapter : NSObject

-(AFHTTPResponseSerializer<AFURLResponseSerialization> *)responseSerializer:(AFNetworkResponseProtocolType)responseType;
-(AFHTTPRequestSerializer<AFURLRequestSerialization> *)requestSerializer:(AFNetworkRequestProtocolType)requestType;

-(void)recyle; //自定义对象时声明的新参数一定要自己回收下

@end

@interface AFNetworkTaskAdapter : NSObject

-(void)request:(NSMutableURLRequest *)request;
-(void)response:(NSHTTPURLResponse *)response msg:(AFNetworkMsg *)msg;

-(void)recyle; //自定义对象时声明的新参数一定要自己回收下

@end

@interface AFNetworkDataAdapter : NSObject


//返回处理结果
-(id)processSuccessWithTask:(NSURLSessionTask *)task response:(NSHTTPURLResponse *)response  originalObj:(id)originalObj parentObj:(id)parentObj;

-(id)processFailWithTask:(NSURLSessionTask *)task error:(NSError *)error;


-(void)recyle; //自定义对象时声明的新参数一定要自己回收下

@end
