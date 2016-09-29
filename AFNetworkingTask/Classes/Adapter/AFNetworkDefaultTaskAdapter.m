 
#import "AFNetworkDefaultTaskAdapter.h"
#import "AFNetworkContainer.h"

@implementation AFNetworkDefaultTaskAdapter


-(void)request:(NSMutableURLRequest * _Nonnull)request{

}
-(void)response:(NSHTTPURLResponse * _Nonnull)response msg:(AFNetworkMsg * _Nullable)msg{ 
    msg.httpStatusCode =response.statusCode;
    msg.responseHeaders = [[NSDictionary alloc] initWithDictionary:[response allHeaderFields]];
}

@end
