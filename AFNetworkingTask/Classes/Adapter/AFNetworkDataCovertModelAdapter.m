

#import "AFNetworkDataCovertModelAdapter.h"
#import "MJExtension.h"

@interface AFNetworkDataCovertModelAdapter()

@property (nonatomic,strong) Class _Nullable clazzInfo;


@end


@implementation AFNetworkDataCovertModelAdapter


-(void)addStructure:(Class _Nonnull)clazz{
    self.clazzInfo = clazz;
}
    
-(AFNetworkDataType)processSuccessWithTask:(NSURLSessionTask * _Nonnull)task originalObj:(id _Nullable)originalObj parentObj:(id _Nullable)parentObj msg:(AFNetworkMsg * _Nullable)msg returnObj:(__nullable id * _Nullable)returnObj{
     
    
    if([originalObj isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic = originalObj;
        NSObject *object =  [self.clazzInfo mj_objectWithKeyValues:dic];
        *returnObj = object;
    }else if ([originalObj isKindOfClass:[NSArray class]]){
        NSArray *dic = originalObj;
        NSObject *object =  [self.clazzInfo mj_objectWithKeyValues:dic];
        *returnObj = object;
        
    }
     
    return AFNetworkDataTypeData;
}

-(id)processFailWithTask:(NSURLSessionTask * _Nonnull)task msg:(AFNetworkMsg * _Nullable)msg error:(NSError * _Nullable)error{
    return nil;
}

-(void)recyle{
    
}
@end
