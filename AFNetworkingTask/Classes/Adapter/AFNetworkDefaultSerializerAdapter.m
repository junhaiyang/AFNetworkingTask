

#import "AFNetworkDefaultSerializerAdapter.h"
#import "AFTextResponseSerializer.h"
#import "AFHTTPSessionManager.h"

@implementation AFNetworkDefaultSerializerAdapter
 

-(AFHTTPResponseSerializer<AFURLResponseSerialization> * _Nonnull)responseSerializer:(AFNetworkProtocolType)responseType{
    AFHTTPResponseSerializer * _Nonnull responseSerializer;
    if(responseType==AFNetworkProtocolTypeNormal){
        responseSerializer= [AFTextResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml", @"text/asa" ,@"text/asp",@"text/scriptlet",@"text/vnd.wap.wml",@"text/plain",@"text/webviewhtml",@"text/x-ms-odc",@"text/css",@"text/vnd.rn-realtext3d",@"text/vnd.rn-realtext",@"text/iuls",@"text/x-vcard",@"application/json",nil];
    }else{
        responseSerializer= [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/xml", @"application/xml",@"application/x-gzip", nil];
    }
    
    responseSerializer.acceptableStatusCodes  = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
    
    
    return responseSerializer;
}
-(AFHTTPRequestSerializer<AFURLRequestSerialization> * _Nonnull)requestSerializer:(AFNetworkProtocolType)requestType{
    AFHTTPRequestSerializer * _Nonnull requestSerializer;
    if(requestType==AFNetworkProtocolTypeJSON){
        requestSerializer= [AFJSONRequestSerializer serializer]; 
    } else {
        requestSerializer= [AFHTTPRequestSerializer serializer];
    }
     
    
    
    return requestSerializer;
}

@end
