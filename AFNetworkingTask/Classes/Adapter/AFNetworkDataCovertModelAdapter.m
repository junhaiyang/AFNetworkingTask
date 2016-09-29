

#import "AFNetworkDataCovertModelAdapter.h"
#import "MJExtension.h"

@interface AFNetworkDataCovertModelAdapter()

@property (nonatomic,strong) Class _Nullable clazzInfo;


@end


@implementation AFNetworkDataCovertModelAdapter


-(void)addStructure:(Class _Nonnull)clazz{
    self.clazzInfo = clazz;
}

-(id)processSuccessWithTask:(NSURLSessionTask * _Nonnull)task response:(NSHTTPURLResponse * _Nonnull)response  originalObj:(id _Nullable)originalObj parentObj:(id _Nullable)parentObj{
    
    if(self.clazzInfo==nil)
        return originalObj;
    
    if([originalObj isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic = originalObj;
        NSObject *object =  [self.clazzInfo mj_objectWithKeyValues:dic];
        return object;
    }else if ([originalObj isKindOfClass:[NSArray class]]){
        NSArray *dic = originalObj;
        NSObject *object =  [self.clazzInfo mj_objectWithKeyValues:dic];
        return object;
        
    }
     
    return nil;
}

-(id)processFailWithTask:(NSURLSessionTask * _Nonnull)task error:(NSError * _Nullable)error{
     
}

-(void)recyle{
    
}
@end
