//
//  AFNetworkAnalysis.m
//  Pods
//
//  Created by junhai on 16/6/13.
//
//

#import "AFNetworkAnalysis.h"

@implementation AFNetworkMsg

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.code =-1;
    }
    return self;
}

-(BOOL)isSuccess{
    self.code = 200;
}

@end
@implementation AFNetworkAnalysis
@synthesize analysises;
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.msg = [AFNetworkMsg new];
        self.completionCustomQueue = NO;
        self.requestType = AFNetworkRequestProtocolTypeNormal;
        self.responseType = AFNetworkResponseProtocolTypeJSON;
        
        analysises =[[NSMutableDictionary alloc] init];
        
    }
    return self;
}

+(instancetype)defaultAnalysis{
    AFNetworkAnalysis *analysis =[AFNetworkAnalysis new];
    
    return analysis;
}
+(instancetype)defaultCustomQueueAnalysis{
    AFNetworkAnalysis *analysis =[AFNetworkAnalysis new];
    analysis.completionCustomQueue = YES;
    return analysis;
}
-(void)setAnalysises:(NSDictionary *)_analysises{
    analysises =[[NSMutableDictionary alloc] initWithDictionary:_analysises];
}
-(void)addAnalysis:(NSString *)key structure:(id)value{
    [(NSMutableDictionary *)self.analysises setObject:value forKey:key];

} 
@end
