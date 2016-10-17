

#import "AFNetworkDataBlockAdapter.h"
@interface AFNetworkDataBlockAdapter()

@property (nonatomic,strong) AFNetworkingTaskDataBlock afnetworkingTaskDataBlock;


@end
@implementation AFNetworkDataBlockAdapter

-(void)dataBlock:(AFNetworkingTaskDataBlock _Nullable)dataBlock{
    self.afnetworkingTaskDataBlock = dataBlock;
}
-(AFNetworkDataType)processSuccessWithTask:(NSURLSessionTask * _Nonnull)task originalObj:(id _Nullable)originalObj parentObj:(id _Nullable)parentObj msg:(AFNetworkMsg * _Nullable)msg returnObj:(__nullable id * _Nullable)returnObj{
    
    if(self.afnetworkingTaskDataBlock){
        @try {
             self.afnetworkingTaskDataBlock(msg,originalObj,parentObj);
            return AFNetworkDataTypeData;
        } @catch (NSException *exception) {
            return AFNetworkDataTypeData;
        }
    }else{
        return AFNetworkDataTypeData;
    }
     
}

-(id)processFailWithTask:(NSURLSessionTask * _Nonnull)task msg:(AFNetworkMsg * _Nullable)msg error:(NSError * _Nullable)error{
    return nil;
}

-(void)recyle{
    self.afnetworkingTaskDataBlock = nil;
}
@end
 
