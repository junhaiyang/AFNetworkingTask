//
//  AFNetworkTaskHelper.h
//  Pods
//
//  Created by junhai on 16/9/29.
//
//

#import <Foundation/Foundation.h>

@protocol AFNetworkRequestData <NSObject>
 
@end


@protocol AFNetworkResponsetData <NSObject>



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


typedef NS_ENUM(NSInteger, AFNetworkResponseProtocolType) {
    AFNetworkResponseProtocolTypeNormal = 0,       //响应协议类型，发无任何格式的字符串流方式
    AFNetworkResponseProtocolTypeJSON,              //响应协议类型，发JSON格式符串流方式
    AFNetworkResponseProtocolTypeFile,              //响应协议类型，发文件流方式
};
typedef NS_ENUM(NSInteger, AFNetworkRequestProtocolType) {
    AFNetworkRequestProtocolTypeNormal = 0,       //请求协议类型，标准提交
    AFNetworkRequestProtocolTypeJSON,              //请求协议类型，发JSON格式提交
};


@interface AFNetworkTaskHelper : NSObject

@end
