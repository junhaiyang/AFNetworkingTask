 

#import "AFNetworkContainer.h"
#import "AFNetworkDefaultSerializerAdapter.h"
#import "AFNetworkDataCovertModelAdapter.h"
#import "AFNetworkAdapter.h"

@implementation AFNetworkMsg

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


-(void)recyle{
    self.responseHeaders = nil;
}

@end

@interface AFNetworkContainer()
    
    
@property (nonatomic,strong) NSMutableArray<AFNetworkSessionAdapter *>  * _Nonnull sessionAdapters NS_AVAILABLE_IOS(7_0);  //请求协议类型
@property (nonatomic,strong) NSMutableArray<AFNetworkDataAdapter *>  * _Nonnull dataAdapters NS_AVAILABLE_IOS(7_0);  //请求协议类型
    
    //执行适配器操作
-(void)sessionRequestAdapter:(NSMutableURLRequest * _Nonnull)request;
-(void)sessionResponseAdapter:(NSHTTPURLResponse * _Nonnull)response;
    
    //返回处理结果
-(id _Nullable)processSuccessWithTask:(NSURLSessionTask * _Nonnull)task response:(NSHTTPURLResponse * _Nonnull)response  originalObj:(id _Nullable)originalObj;
-(void)processFailWithTask:(NSURLSessionTask * _Nonnull)task error:(NSError *_Nullable)error;

@end


@implementation AFNetworkContainer
@synthesize serializerAdapter;
@synthesize sessionAdapters;
@synthesize dataAdapters;

- (instancetype)init
{
    self = [super init];
    if (self) { 
        sessionAdapters= [[NSMutableArray alloc] initWithCapacity:0];
        
        dataAdapters= [[NSMutableArray alloc] initWithCapacity:0];
        
        self.msg =  [AFNetworkMsg new];
        
        self.responseType =AFNetworkProtocolTypeJSON;
        self.requestType =AFNetworkProtocolTypeNormal;
        
        self.completionCustomQueue = NO;
    }
    return self;
}

-(void)addDefaultStructure:(Class)clazz{
    AFNetworkDataCovertModelAdapter * _Nonnull dataAdapter =[AFNetworkDataCovertModelAdapter new];
    [dataAdapter addStructure:clazz]; 
    [self addDataAdapter:dataAdapter];

}
    
-(void)addSessionAdapter:(AFNetworkSessionAdapter * _Nonnull)adapter{
    [sessionAdapters addObject:adapter];
}
-(void)addDataAdapter:(AFNetworkDataAdapter * _Nonnull)adapter{
    [dataAdapters addObject:adapter];
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
-(void)sessionResponseAdapter:(NSHTTPURLResponse * _Nonnull)response{
    self.msg.httpStatusCode =response.statusCode;
    self.msg.responseHeaders = [[NSDictionary alloc] initWithDictionary:[response allHeaderFields]];
    
    for (AFNetworkSessionAdapter *adapter in self.sessionAdapters) {
        [adapter sessionResponse:response msg:self.msg];
    }
    
}


-(id)processSuccessWithTask:(NSURLSessionTask * _Nonnull)task response:(NSHTTPURLResponse * _Nonnull)response  originalObj:(id _Nullable)originalObj{
    id resultObj = originalObj;
    
    @try {
        for (AFNetworkDataAdapter * _Nonnull adapter in self.dataAdapters) {
            resultObj =  [adapter processSuccessWithTask:task originalObj:originalObj parentObj:resultObj];
        }
        self.msg.errorCode = AFNetworkStatusCodeSuccess;
    } @catch (NSException *exception) {
        self.msg.errorCode = AFNetworkStatusCodeDataError;
    } 
    
    
    return resultObj;
}
-(void)processFailWithTask:(NSURLSessionTask * _Nonnull)task error:(NSError * _Nullable)error{
    for (AFNetworkDataAdapter * _Nonnull adapter in self.dataAdapters) {
         [adapter processFailWithTask:task error:error];
    }
    self.msg.errorCode = AFNetworkStatusCodeHttpError;
    self.msg.httpStatusCode = error.code;
}

-(void)recyle{
    [self.serializerAdapter recyle];
    for (AFNetworkSessionAdapter * _Nonnull adapter in self.sessionAdapters) {
        [adapter recyle];
    }
    for (AFNetworkDataAdapter * _Nonnull adapter in self.dataAdapters) {
        [adapter recyle];
    }
    
    serializerAdapter = nil;
    
    [sessionAdapters removeAllObjects];
    sessionAdapters = nil;
    
    [dataAdapters removeAllObjects];
    dataAdapters = nil;
    

}

@end
