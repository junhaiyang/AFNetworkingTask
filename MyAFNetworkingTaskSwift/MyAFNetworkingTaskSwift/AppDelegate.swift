//
//  AppDelegate.swift
//  MyAFNetworkingTaskSwift
//
//  Created by junhai on 16/9/29.
//  Copyright © 2016年 junhai. All rights reserved.
//

import UIKit

import AFNetworkingTaskSwift


class ResultData: NSObject {
    var category1:NSArray?  = nil;
    var category2:NSArray?  = nil;
}

class UserData: NSObject {
    var result:ResultData?  = nil;
    var code:Int  = 0;
}

class MyAFNetworkTaskAdapter: AFNetworkTaskAdapter {
    
    open override func request(_ request: NSMutableURLRequest){
        //    //TODO add header
        
        request.addValue("", forHTTPHeaderField: "");
    
    }
    
    open override func response(_ response: HTTPURLResponse, msg: AFNetworkMsg?){
    
    }
    
}

class MyAFNetworkSerializerAdapter: AFNetworkDefaultSerializerAdapter {
    
    open override func requestSerializer(_ requestType: AFNetworkRequestProtocolType) -> AFHTTPRequestSerializer {
        let  requestSerializer:AFHTTPRequestSerializer = super.requestSerializer(requestType);
        
        requestSerializer.setValue("", forHTTPHeaderField: "");
        
        return requestSerializer;
    }
    
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        AFNetworkActivityLogger.shared().level = AFHTTPRequestLoggerLevel.AFLoggerLevelDebug;
        AFNetworkActivityLogger.shared().startLogging();
        
        let  container:AFNetworkContainer = AFNetworkContainer();
        
        container.addDefaultStructure(UserData.classForCoder());
        
        container.completionCustomQueue = true;
        
        
        let serializerAdapter:MyAFNetworkSerializerAdapter = MyAFNetworkSerializerAdapter();
        
        container.serializerAdapter = serializerAdapter;
        
        
        let  task1:AFNetworkTask = AFNetworkTask(container:container);
         
        task1.get("http://xxxxxx") { (msg:AFNetworkMsg, originalObj:Any? , data:AFNetworkResponseData? ) in
           
            if let userData:UserData = data as? UserData {
                print("UserData code .........", userData.code)
            }
            
            
            print("finish .........", msg.httpStatusCode,msg.errorCode.rawValue)
            
        };
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

