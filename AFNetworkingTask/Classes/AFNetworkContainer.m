 

#import "AFNetworkContainer.h"
#import "AFNetworkDefaultSerializerAdapter.h"
#import "AFNetworkDefaultTaskAdapter.h" 
#import "AFNetworkDataCovertModelAdapter.h"

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
        sessionAdapters= [[NSMutableArray alloc] initWithCapacity:0];
        dataAdapters= [[NSMutableArray alloc] initWithCapacity:0];
        
        self.msg =  [AFNetworkMsg new];
        
        self.responseType =AFNetworkResponseProtocolTypeJSON;
        self.requestType =AFNetworkRequestProtocolTypeNormal;
        
        self.completionCustomQueue = NO;
    }
    return self;
}

-(void)addDefaultStructure:(Class)clazz{
    AFNetworkDataCovertModelAdapter *dataAdapter =[AFNetworkDataCovertModelAdapter new];
    [dataAdapter addStructure:clazz]; 
    [self addDataAdapter:dataAdapter];

}

-(void)addSessionAdapter:(AFNetworkTaskAdapter *)adapter{
    [sessionAdapters addObject:adapter];
}
-(void)addDataAdapter:(AFNetworkDataAdapter *)adapter{
    [dataAdapters addObject:adapter];
}

-(AFNetworkSerializerAdapter *)serializerAdapter{
    if(serializerAdapter==nil){
        return [AFNetworkDefaultSerializerAdapter new];
    }
    
    return serializerAdapter;
}
-(NSArray<AFNetworkTaskAdapter *> *)sessionAdapters{
    if(sessionAdapters.count==0){
        return @[[AFNetworkDefaultTaskAdapter new]];
    }
    
    return sessionAdapters;

}



-(void)sessionRequestAdapter:(NSMutableURLRequest *)request{
    for (AFNetworkTaskAdapter *adapter in self.sessionAdapters) {
        [adapter request:request];
    }
}
-(void)sessionResponseAdapter:(NSHTTPURLResponse *)response{
    for (AFNetworkTaskAdapter *adapter in self.sessionAdapters) {
        [adapter response:response msg:self.msg];
    }
}


-(id)processSuccessWithTask:(NSURLSessionTask *)task response:(NSHTTPURLResponse *)response  originalObj:(id)originalObj{
    id resultObj = originalObj;
    for (AFNetworkDataAdapter *adapter in self.dataAdapters) {
       resultObj =  [adapter processSuccessWithTask:task response:response originalObj:originalObj parentObj:resultObj];
    }
    
    return resultObj;
}
-(void)processFailWithTask:(NSURLSessionTask *)task error:(NSError *)error{
    for (AFNetworkDataAdapter *adapter in self.dataAdapters) {
         [adapter processFailWithTask:task error:error];
    }
}

-(void)recyle{
    [self.serializerAdapter recyle];
    for (AFNetworkTaskAdapter *adapter in self.sessionAdapters) {
        [adapter recyle];
    }
    for (AFNetworkDataAdapter *adapter in self.dataAdapters) {
        [adapter recyle];
    }
    
    serializerAdapter = nil;
    
    [sessionAdapters removeAllObjects];
    sessionAdapters = nil;
    
    [dataAdapters removeAllObjects];
    dataAdapters = nil;
    

}

@end
