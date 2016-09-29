 

#import "AFNetworkContainer.h"
#import "AFNetworkDefaultSerializerAdapter.h"
#import "AFNetworkDefaultTaskAdapter.h" 
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

@implementation AFNetworkContainer
@synthesize serializerAdapter;
@synthesize sessionAdapters;
@synthesize dataAdapters;

- (instancetype)init
{
    self = [super init];
    if (self) { 
        sessionAdapters= [[NSMutableArray alloc] initWithCapacity:0];
        
        [sessionAdapters addObject:[AFNetworkDefaultTaskAdapter new]];
        
        dataAdapters= [[NSMutableArray alloc] initWithCapacity:0];
        
        self.msg =  [AFNetworkMsg new];
        
        self.responseType =AFNetworkResponseProtocolTypeJSON;
        self.requestType =AFNetworkRequestProtocolTypeNormal;
        
        self.completionCustomQueue = NO;
    }
    return self;
}

-(void)addDefaultStructure:(Class)clazz{
    AFNetworkDataCovertModelAdapter * _Nonnull dataAdapter =[AFNetworkDataCovertModelAdapter new];
    [dataAdapter addStructure:clazz]; 
    [self addDataAdapter:dataAdapter];

}

-(void)addSessionAdapter:(AFNetworkTaskAdapter * _Nonnull)adapter{
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
-(NSArray<AFNetworkTaskAdapter *> * _Nonnull)sessionAdapters{
    if(sessionAdapters.count==0){
        return @[[AFNetworkDefaultTaskAdapter new]];
    }
    
    return sessionAdapters;

}



-(void)sessionRequestAdapter:(NSMutableURLRequest * _Nonnull)request{
    for (AFNetworkTaskAdapter *adapter in self.sessionAdapters) {
        [adapter request:request];
    }
}
-(void)sessionResponseAdapter:(NSHTTPURLResponse * _Nonnull)response{
    for (AFNetworkTaskAdapter *adapter in self.sessionAdapters) {
        [adapter response:response msg:self.msg];
    }
}


-(id)processSuccessWithTask:(NSURLSessionTask * _Nonnull)task response:(NSHTTPURLResponse * _Nonnull)response  originalObj:(id _Nullable)originalObj{
    id resultObj = originalObj;
    
    @try {
        for (AFNetworkDataAdapter * _Nonnull adapter in self.dataAdapters) {
            resultObj =  [adapter processSuccessWithTask:task response:response originalObj:originalObj parentObj:resultObj];
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
}

-(void)recyle{
    [self.serializerAdapter recyle];
    for (AFNetworkTaskAdapter * _Nonnull adapter in self.sessionAdapters) {
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
