//
//  ViewController.m
//  AFNetworkingTask
//
//  Created by junhai on 15/11/6.
//  Copyright © 2015年 junhai. All rights reserved.
//

#import "ViewController.h"
#import "UserRequest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserRequest  *request =[UserRequest new];
    [request requestBaidu:^(id responseObject, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
        NSLog(@"finish .........");
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
     
    // Dispose of any resources that can be recreated.
}

@end
