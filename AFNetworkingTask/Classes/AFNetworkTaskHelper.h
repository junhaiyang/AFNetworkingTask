 

#import <Foundation/Foundation.h>

@protocol AFNetworkRequestData <NSObject>
 
@end 

typedef NS_ENUM(NSInteger, AFNetworkStatusCode) {
    AFNetworkStatusCodeUnknown = 0,      //状态未知
    AFNetworkStatusCodeNoWork  = -50,   //取消
    AFNetworkStatusCodeCancel  = -100,   //取消
    AFNetworkStatusCodeSuccess = 200,    //成功
    AFNetworkStatusCodeHttpError   = -200,    //http未知错误
    AFNetworkStatusCodeDataError   = -300,    //数据解析错误
    AFNetworkStatusCodeProcessError   = -400,    //处理错误
    AFNetworkStatusCodeUnknownError   = -500,    //未知错误
    AFNetworkStatusCodeAuthFail   = -600    //本地判断无权限
};


typedef NS_ENUM(NSInteger, AFNetworkProtocolType) {
    AFNetworkProtocolTypeNormal = 0,       //默认表单方式
    AFNetworkProtocolTypeJSON,              //JSON格式符串流方式
};


typedef NS_ENUM(NSInteger, AFNetworkDataType) {
    AFNetworkDataTypeIgron = 0,           //忽略数据
    AFNetworkDataTypeData,              //使用为回调数据
};

 
