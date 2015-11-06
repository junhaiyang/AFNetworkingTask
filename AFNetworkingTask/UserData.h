//
//  AFNetworkData.h
//  AFNetworkingTask
//
//  Created by junhai on 15/11/6.
//  Copyright © 2015年 junhai. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserData : NSObject

@property (nonatomic,strong) NSString *name;


-(void)processResult:(id)responseObject;
 

@end
