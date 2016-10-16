 

#import <Foundation/Foundation.h>
#import "AFNetworkTaskSessionPatch.h"

@class AFNetworkTask;

@interface AFNetworkTaskSession : AFNetworkTaskSessionPatch 


- (instancetype _Nonnull)initWithContainer:(AFNetworkContainer * _Nonnull)container;

//-(void)addDataBlock:(AFNetworkingTaskDataBlock _Nullable)dataBlock;


#pragma mark - process  Recyle 

-(void)recyle;

@end
