//
//  AFNetworkAnalysis.m
//  Pods
//
//  Created by junhai on 16/6/13.
//
//

#import "AFNetworkAnalysis.h"

@implementation AFNetworkMsg



-(BOOL)isSuccess{
    self.code = 200;
}

@end
@implementation AFNetworkAnalysis

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.msg = [AFNetworkMsg new];
        
        self.requestType = AFNetworkRequestProtocolTypeNormal;
        self.responseType = AFNetworkResponseProtocolTypeJSON;
        
    }
    return self;
}

+(instancetype)defaultAnalysis{
    AFNetworkAnalysis *analysis =[AFNetworkAnalysis new];
    
    return analysis;
}
-(NSDictionary *)buildCommonHeader{
    
    
}
@end
