

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


-(BOOL)isSuccess NS_AVAILABLE_IOS(7_0);

@end


@interface AFNetworkAnalysis : NSObject

@property (nonatomic,strong)AFNetworkMsg *msg;


/**
 *
 * 需要解析的数据体，可以多个,如果没有就为不做解析
 *
 **/
@property (nonatomic,strong) NSDictionary *analysisDictionary NS_AVAILABLE_IOS(7_0);

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

@end

@interface AFNetworkTaskJSONAnalysis : AFNetworkAnalysis


@end

@interface AFNetworkTaskHTMLAnalysis : AFNetworkAnalysis


@end

@interface AFNetworkTaskXMLAnalysis : AFNetworkAnalysis


@end
