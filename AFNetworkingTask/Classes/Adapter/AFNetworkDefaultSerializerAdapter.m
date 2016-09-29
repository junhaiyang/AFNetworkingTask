

#import "AFNetworkDefaultSerializerAdapter.h"
#import "AFTextResponseSerializer.h"
#import "AFHTTPSessionManager.h"

@implementation AFNetworkDefaultSerializerAdapter
 

-(AFHTTPResponseSerializer<AFURLResponseSerialization> * _Nonnull)responseSerializer:(AFNetworkResponseProtocolType)responseType{
    AFHTTPResponseSerializer * _Nonnull responseSerializer;
    if(responseType==AFNetworkResponseProtocolTypeNormal){
        responseSerializer= [AFTextResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml", @"text/asa" ,@"text/asp",@"text/scriptlet",@"text/vnd.wap.wml",@"text/plain",@"text/webviewhtml",@"text/x-ms-odc",@"text/css",@"text/vnd.rn-realtext3d",@"text/vnd.rn-realtext",@"text/iuls",@"text/x-vcard",@"application/json",nil];
    }else{
        responseSerializer= [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/xml", @"application/xml",@"application/x-gzip", nil];
    }
    
    responseSerializer.acceptableStatusCodes  = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
    
    
    return responseSerializer;
}
-(AFHTTPRequestSerializer<AFURLRequestSerialization> * _Nonnull)requestSerializer:(AFNetworkRequestProtocolType)requestType{
    AFHTTPRequestSerializer * _Nonnull requestSerializer;
    if(requestType==AFNetworkRequestProtocolTypeJSON){
        requestSerializer= [AFJSONRequestSerializer serializer];
        //去掉所有限制
        //         requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:nil, nil];
    } else {
        requestSerializer= [AFHTTPRequestSerializer serializer];
    }
     
    
    
    return requestSerializer;
}

@end
