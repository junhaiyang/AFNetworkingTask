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



- (AFNetworkTask *)requestBaidu:(AFNetworkTaskFinishedBlock)finish{
    
    UserData *data =[UserData new];
    
//    return [AFNetworkRequest GET:@"http://www.baidu.com" target:data selector:@selector(processResult:) finish:finish];
    
    return [AFNetworkRequest GET:@"http://www.baidu.com" parameters:nil processResult:^(id responseObject) {
        NSLog(@"----");
    } finish:finish];
    
//    return [AFNetworkRequest GET:@"http://www.baidu.com" target:data selector:@selector(processResult:) finish:finish];
    
}

@end
