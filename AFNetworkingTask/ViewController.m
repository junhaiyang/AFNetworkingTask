//
//  ViewController.m
//  AFNetworkingTask
//
//  Created by junhai on 15/11/6.
//  Copyright © 2015年 junhai. All rights reserved.
//

#import "ViewController.h" 
#import "AFNetworkTaskSession.h"

@interface ViewController ()

@end

@implementation ViewController


-(void)showCamera{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    
    [self presentViewController:picker  animated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSString *savedImagePath=[ NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.png",[[NSDate date] timeIntervalSince1970]]];
    
     [UIImageJPEGRepresentation(selectedImage,1.0) writeToFile:savedImagePath atomically:YES];
    
    
    AFNetworkTaskSession *task =[AFNetworkTaskSession init];
    [task GET:@"http://www.baidu.com" finishedBlock:^(AFNetworkMsg *msg, id originalObj, NSDictionary *jsonBody) {
         NSLog(@"finish .........");
    }];
    
//    UserRequest  *request =[UserRequest new];
//    [request requestBaidu:savedImagePath finish:^(id responseObject, AFNetworkStatusCode errorCode, NSInteger httpStatusCode) {
//         
//        NSLog(@"finish .........");
//    }];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [self.view addSubview:imageView];
    
//    [imageView setImageWithURL:[NSURL URLWithString:@"http://i.quanminxingtan.com/56444a5dac9bdf37f4065c14"]];
    
    
//    http://img2.imgtn.bdimg.com/it/u=2114170278,1962373724&fm=21&gp=0.jpg
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self showCamera];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
     
    // Dispose of any resources that can be recreated.
}

@end
