

#import "AFNetworkTaskManager.h"
#import "MJExtension.h"


static NSString *const kAllBodyObjectInfo = @"kAllBodyObjectInfo"; //整个返回字典的数据
 

@interface AFNetworkMsg: NSObject

@property (nonatomic,assign) NSInteger code NS_AVAILABLE_IOS(7_0);
@property (nonatomic,strong) NSString  *message NS_AVAILABLE_IOS(7_0);

@property (nonatomic,assign) AFNetworkStatusCode errorCode NS_AVAILABLE_IOS(7_0);
@property (nonatomic,assign) NSInteger httpStatusCode NS_AVAILABLE_IOS(7_0);

@property (nonatomic,strong) NSDictionary *responseHeaders NS_AVAILABLE_IOS(7_0);
 
-(BOOL)isSuccess NS_AVAILABLE_IOS(7_0);

-(void)recyle;

@end


@interface AFNetworkAnalysis : NSObject

@property (nonatomic,assign)BOOL completionCustomQueue;

@property (nonatomic,strong)AFNetworkMsg *msg NS_AVAILABLE_IOS(7_0);

@property (nonatomic,assign) AFNetworkResponseProtocolType responseType NS_AVAILABLE_IOS(7_0);  //响应协议类型
@property (nonatomic,assign) AFNetworkRequestProtocolType  requestType NS_AVAILABLE_IOS(7_0);  //请求协议类型

@property (nonatomic,strong,readonly) NSMutableDictionary *requestHeaders NS_AVAILABLE_IOS(7_0);

 

/**
 *
 * 解析出来的数据体
 *
 **/
@property (nonatomic,strong,readonly) NSDictionary *body NS_AVAILABLE_IOS(7_0);

/**
 *
 * 原始数据体
 *
 **/
@property (nonatomic,strong,readonly) id originalBody NS_AVAILABLE_IOS(7_0);

-(void)analysisBody;

-(void)recyle; //自定义对象时声明的新参数一定要自己回收下

@end

@interface AFNetworkCustomQueueAnalysis : AFNetworkAnalysis
@end
