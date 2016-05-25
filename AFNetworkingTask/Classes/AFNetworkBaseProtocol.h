 

#import "AFNetworkTaskManager.h"
@class AFNetworkBaseProtocol;

typedef void(^AFNetworkingFinishedBlock)(AFNetworkBaseProtocol *request, AFNetworkStatusCode errorCode, NSInteger httpStatusCode)  NS_AVAILABLE_IOS(5_0);  //请求协议类型

@interface AFNetworkBaseProtocol : AFNetworkTaskManager

 
@property (nonatomic,strong) AFNetworkingFinishedBlock networkingFinishedBlock;

-(void)finishedWithMainQueue:(AFNetworkingFinishedBlock)finishedBlock  NS_AVAILABLE_IOS(5_0);

-(void)finishedWithCustomQueue:(AFNetworkingFinishedBlock)finishedBlock  NS_AVAILABLE_IOS(5_0);
 
-(BOOL)requestSuccess;

-(void)buildPostFileRequest:(NSString *)url files:(NSDictionary *)files;

-(void)buildPostFileRequest:(NSString *)url form:(NSDictionary *)form files:(NSDictionary *)files;

-(void)buildPostRequest:(NSString *)url form:(NSDictionary *)form;

-(void)buildGetRequest:(NSString *)url;

-(void)buildGetRequest:(NSString *)url form:(NSDictionary *)form;

-(void)buildDeleteRequest:(NSString *)url;


-(void)prepareRequest;
-(void)processDictionary:(id)dictionary;



@end
