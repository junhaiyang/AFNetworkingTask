

#import "AFNetworkDataCovertModelAdapter.h"
#import "MJExtension.h"

@interface AFNetworkDataCovertModelAdapter()

@property (nonatomic,strong) Class clazzInfo;


@end


@implementation AFNetworkDataCovertModelAdapter


-(void)addStructure:(Class)clazz{
    self.clazzInfo = clazz;
}

-(id)processSuccessWithTask:(NSURLSessionTask *)task response:(NSHTTPURLResponse *)response  originalObj:(id)originalObj parentObj:(id)parentObj{
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

-(id)processFailWithTask:(NSURLSessionTask *)task error:(NSError *)error{

}

-(void)recyle{
    
}
@end
