 

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
@synthesize taskAdapters;
@synthesize dataAdapters;

- (instancetype)init
{
    self = [super init];
    if (self) { 
        taskAdapters= [[NSMutableArray alloc] initWithCapacity:0];
        
        [taskAdapters addObject:[AFNetworkDefaultTaskAdapter new]];
        
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

-(void)addTaskAdapter:(AFNetworkTaskAdapter * _Nonnull)adapter{
    [taskAdapters addObject:adapter];
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
-(NSMutableArray<AFNetworkTaskAdapter *> *_Nonnull)taskAdapters{
    if(taskAdapters.count==0){
        return @[[AFNetworkDefaultTaskAdapter new]];
    }
    
    return taskAdapters;

}



-(void)taskRequestAdapter:(NSMutableURLRequest * _Nonnull)request{
    for (AFNetworkTaskAdapter *adapter in self.taskAdapters) {
        [adapter request:request];
    }
}
-(void)taskResponseAdapter:(NSHTTPURLResponse * _Nonnull)response{
    for (AFNetworkTaskAdapter *adapter in self.taskAdapters) {
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
    self.msg.httpStatusCode = error.code;
}

-(void)recyle{
    [self.serializerAdapter recyle];
    for (AFNetworkTaskAdapter * _Nonnull adapter in self.taskAdapters) {
        [adapter recyle];
    }
    for (AFNetworkDataAdapter * _Nonnull adapter in self.dataAdapters) {
        [adapter recyle];
    }
    
    serializerAdapter = nil;
    
    [taskAdapters removeAllObjects];
    taskAdapters = nil;
    
    [dataAdapters removeAllObjects];
    dataAdapters = nil;
    

}

@end
