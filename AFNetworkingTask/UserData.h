//
//  AFNetworkData.h
//  AFNetworkingTask
//
//  Created by junhai on 15/11/6.
//  Copyright © 2015年 junhai. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ResultData : NSObject


@property (nonatomic,strong) NSArray *category1;
@property (nonatomic,strong) NSArray *category2;



@end

@interface UserData : NSObject


@property (nonatomic,strong) ResultData *result;
@property (nonatomic,assign) int code;


 

@end
