//
//  UserRequest.m
//  AFNetworkingTask
//
//  Created by junhai on 15/11/6.
//  Copyright © 2015年 junhai. All rights reserved.
//

#import "UserRequest.h"
#import "UserData.h"

@implementation UserRequest



- (AFNetworkTask *)requestBaidu:(NSString *)file finish:(AFNetworkTaskFinishedBlock)finish{
    
    NSURL *url =[NSURL URLWithString:@"http://www.baidu.com" ];
     
    
    UserData *data =[UserData new];
    
//    return [AFNetworkRequest GET:@"http://www.baidu.com" target:data selector:@selector(processResult:) finish:finish];
    
//    return [AFNetworkRequest DOWNLOAD:@"http://www.sina.com.cn/" parameters:nil progress:^(CGFloat progress) {
//        NSLog(@"----progress:%f",progress);
//    } finish:finish];
    
    
//    return [AFNetworkRequest GET:@"http://www.baidu.com" parameters:nil processResult:^(id responseObject) {
//        NSLog(@"-----");
//    } finish:finish];
    
    
    return [AFNetworkRequest UPLOAD:@"http://120.26.81.3/pub/up" parameters:nil files:@{@"bin":file}  progress:^(CGFloat progress) {
        
    } finish:^(id responseObject, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        NSLog(@"%@",responseObject);
    }];
    
    
//    return [AFNetworkRequest GET:@"http://www.baidu.com" target:data selector:@selector(processResult:) finish:finish];
    
}

@end
