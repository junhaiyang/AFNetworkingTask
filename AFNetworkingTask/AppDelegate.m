//
//  AppDelegate.m
//  AFNetworkingTask
//
//  Created by junhai on 15/11/6.
//  Copyright © 2015年 junhai. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkTaskSession.h"
#import "AFNetworkTask.h"
#import "AFNetworkDataCovertModelAdapter.h"
#import "AFNetworkDefaultSerializerAdapter.h"
#import "UserData.h"
#import "AFNetworkActivityLogger.h"
@interface AppDelegate (){
//    AFNetworkTask *task1;
//    AFNetworkTask *task2;
//    AFNetworkTask *task3;
//    AFNetworkTask *task4;
//    AFNetworkTask *task5;
}

@end

@interface MyAFNetworkSerializerAdapter : AFNetworkDefaultSerializerAdapter

@end
@implementation MyAFNetworkSerializerAdapter
    
-(AFHTTPRequestSerializer<AFURLRequestSerialization> * _Nonnull)requestSerializer:(AFNetworkProtocolType)requestType{
 
    AFHTTPRequestSerializer * _Nonnull requestSerializer =[super requestSerializer:requestType];
     
//    [requestSerializer setValue:@"" forHTTPHeaderField:@""];
    
    
    return requestSerializer;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch. 
    
    [AFNetworkActivityLogger sharedLogger].level = AFLoggerLevelDebug;
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    
    
    {
        AFNetworkContainer *container =[AFNetworkContainer new]; 
        AFNetworkTaskSession *taskSession =[[AFNetworkTaskSession alloc] initWithContainer:container];
        
        AFNetworkTask *task = [[AFNetworkTask alloc] initWithTaskSession:taskSession];
        
        [task addDefaultStructure:[UserData class]];
        
        [task DOWNLOAD:@"https://www.baidu.com" finishedBlock:^(AFNetworkMsg *msg, id originalObj, id data) {
            
            //            {
            //                AFNetworkTask *task2 =[[AFNetworkTask alloc] initWithContainer:container];
            //
            //                [task2 GET:@"http://xxxxxxx" finishedBlock:^(AFNetworkMsg *msg, id originalObj, id<AFNetworkResponseData> data) {
            //
            //                    //            NSLog(@"finish .........%@",data);
            //                }];
            //            }
            
            NSLog(@"finish .........%@",originalObj);
        }];
        
        AFNetworkTask *task2 = [[AFNetworkTask alloc] initWithTaskSession:taskSession];
        
        [task2 DOWNLOAD:@"https://www.baidu.com" finishedBlock:^(AFNetworkMsg *msg, id originalObj, id data) {
            
            //            {
            //                AFNetworkTask *task2 =[[AFNetworkTask alloc] initWithContainer:container];
            //
            //                [task2 GET:@"http://xxxxxxx" finishedBlock:^(AFNetworkMsg *msg, id originalObj, id<AFNetworkResponseData> data) {
            //
            //                    //            NSLog(@"finish .........%@",data);
            //                }];
            //            }
            
            NSLog(@"finish .........%@",originalObj);
        }];
    }
    
    
 
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
