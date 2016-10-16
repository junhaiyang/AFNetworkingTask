 

#import "AFNetworkAdapter.h"
#import "AFNetworkTask.h"



@interface AFNetworkDataBlockAdapter : AFNetworkDataAdapter

-(void)dataBlock:(AFNetworkingTaskDataBlock _Nullable)dataBlock;

@end
