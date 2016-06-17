

#import "AFNetworkTaskManager.h"

//@protocol AFNetworkAnalysisDelegate <NSObject>
//
//-(id)analysisBodyAndMsg:
//
//@end

@interface AFNetworkMsg: NSObject

@property (nonatomic,assign) NSInteger code NS_AVAILABLE_IOS(7_0);
@property (nonatomic,strong) NSString  *message NS_AVAILABLE_IOS(7_0);

@property (nonatomic,assign) AFNetworkStatusCode errorCode NS_AVAILABLE_IOS(7_0);
@property (nonatomic,assign) NSInteger httpStatusCode NS_AVAILABLE_IOS(7_0);

@property (nonatomic,strong) NSDictionary *responseHeaders NS_AVAILABLE_IOS(7_0);
 
-(BOOL)isSuccess NS_AVAILABLE_IOS(7_0);

@end


@interface AFNetworkAnalysis : NSObject

@property (nonatomic,assign)BOOL completionCustomQueue;

@property (nonatomic,strong)AFNetworkMsg *msg NS_AVAILABLE_IOS(7_0);

@property (nonatomic,assign) AFNetworkResponseProtocolType responseType NS_AVAILABLE_IOS(7_0);  //响应协议类型
@property (nonatomic,assign) AFNetworkRequestProtocolType  requestType NS_AVAILABLE_IOS(7_0);  //请求协议类型


+(instancetype)defaultAnalysis NS_AVAILABLE_IOS(7_0);
+(instancetype)defaultCustomQueueAnalysis NS_AVAILABLE_IOS(7_0);


/**
 *
 * 需要解析的数据体，可以多个,如果没有就为不做解析,影响返回顺序
 * clazz 为对象class，NSObject 为集合类型
 * @{"key":@[clazz,NSObject],"key":@[clazz,NSArray]}
 *
 **/
@property (nonatomic,strong) NSDictionary *analysises NS_AVAILABLE_IOS(7_0);

/**
 *
 * 解析出来的数据体
 *
 **/
@property (nonatomic,strong) NSDictionary *body NS_AVAILABLE_IOS(7_0);

/**
 *
 * 原始数据体
 *
 **/
@property (nonatomic,strong) id originalBody NS_AVAILABLE_IOS(7_0);

-(void)addAnalysis:(NSString *)key structure:(id)value;


-(NSDictionary *)buildCommonHeader NS_AVAILABLE_IOS(7_0);

@end 
