 

#import "AFNetworkContainer.h"
#import "AFNetworkDefaultSerializerAdapter.h"
#import "AFNetworkDataCovertModelAdapter.h"
#import "AFNetworkDataBlockAdapter.h"
#import "AFNetworkAdapter.h"
#import "AFNetworkTask.h"
#import "AFNetworkAdapter.h"


@interface AFNetworkContainer()
    
    
@property (nonatomic,strong) NSMutableArray<AFNetworkSessionAdapter *>  * _Nonnull sessionAdapters NS_AVAILABLE_IOS(7_0);  //请求协议类型
    
    
    //返回处理结果
-(id _Nullable)processSuccessWithTask:(NSURLSessionTask * _Nonnull)task response:(NSHTTPURLResponse * _Nonnull)response msg:(AFNetworkMsg * _Nullable)msg originalObj:(id _Nullable)originalObj;
-(void)processFailWithTask:(NSURLSessionTask * _Nonnull)task msg:(AFNetworkMsg * _Nullable)msg error:(NSError *_Nullable)error;

@end


@implementation AFNetworkContainer
@synthesize serializerAdapter;
@synthesize sessionAdapters;

- (instancetype)init
{
    self = [super init];
    if (self) { 
        sessionAdapters= [[NSMutableArray alloc] initWithCapacity:0];
          
        self.responseType =AFNetworkProtocolTypeJSON;
        self.requestType =AFNetworkProtocolTypeNormal;
        
        self.completionCustomQueue = NO;
    }
    return self;
}

-(void)addSessionAdapter:(AFNetworkSessionAdapter * _Nonnull)adapter{
    [sessionAdapters addObject:adapter];
}

-(AFNetworkSerializerAdapter * _Nonnull)serializerAdapter{
    if(serializerAdapter==nil){
        return [AFNetworkDefaultSerializerAdapter new];
    }
    
    return serializerAdapter;
}
-(NSMutableArray<AFNetworkSessionAdapter *> *_Nonnull)sessionAdapters{
    
    return sessionAdapters;

}



-(void)sessionRequestAdapter:(NSMutableURLRequest * _Nonnull)request{
    for (AFNetworkSessionAdapter *adapter in self.sessionAdapters) {
        [adapter sessionRequest:request];
    }
}
-(void)sessionResponseAdapter:(NSHTTPURLResponse * _Nonnull)response msg:(AFNetworkMsg * _Nullable)msg{
    msg.httpStatusCode =response.statusCode;
    msg.responseHeaders = [[NSDictionary alloc] initWithDictionary:[response allHeaderFields]];
    
    for (AFNetworkSessionAdapter *adapter in self.sessionAdapters) {
        [adapter sessionResponse:response msg:msg];
    }
    
}



-(void)recyle{
    [self.serializerAdapter recyle];
    for (AFNetworkSessionAdapter * _Nonnull adapter in self.sessionAdapters) {
        [adapter recyle];
    }
    
    serializerAdapter = nil;
    
    [sessionAdapters removeAllObjects];
    sessionAdapters = nil;
    
    

}

@end
