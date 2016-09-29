 
#import "AFNetworkDefaultTaskAdapter.h"
#import "AFNetworkContainer.h"

@implementation AFNetworkDefaultTaskAdapter


-(void)request:(NSMutableURLRequest *)request{

}
-(void)response:(NSHTTPURLResponse *)response msg:(AFNetworkMsg *)msg{ 
    msg.httpStatusCode =response.statusCode;
    msg.responseHeaders = [[NSDictionary alloc] initWithDictionary:[response allHeaderFields]];
}

@end
