 

#import "AFNetworkTaskSession.h"
#import "AFNetworkActivityLogger.h"
#import "MJExtension.h"
#import "AFNetworkAdapter.h"
#import "AFNetworkTask.h"

 


//@interface AFNetworkContainer(TaskSession)
//     
//    
//    //执行适配器操作
//-(void)sessionRequestAdapter:(NSMutableURLRequest * _Nonnull)request;
//-(void)sessionResponseAdapter:(NSHTTPURLResponse * _Nonnull)response msg:(AFNetworkMsg * _Nullable)msg;
//    
//    //返回处理结果
//-(id _Nullable)processSuccessWithTask:(NSURLSessionTask * _Nonnull)task response:(NSHTTPURLResponse * _Nonnull)response msg:(AFNetworkMsg * _Nullable)msg originalObj:(id _Nullable)originalObj;
//-(void)processFailWithTask:(NSURLSessionTask * _Nonnull)task msg:(AFNetworkMsg * _Nullable)msg error:(NSError *_Nullable)error;
//    
//@end
@interface AFNetworkTask(TaskSession)

@property (nonatomic,strong) NSURLSessionTask *sessionTask;
@property (nonatomic,strong) AFNetworkMsg *msg;
@end

@interface AFNetworkTaskSession(){
    
} 

@property (nonatomic) BOOL finishedTag;

@end

@implementation AFNetworkTaskSession
- (instancetype)initWithContainer:(AFNetworkContainer * _Nonnull)_container
{
    self = [super init];
    if (self) {
         
        
        self.container =  _container;
        if(self.container.completionCustomQueue){
            self.completionQueue = [[self class] afnet_shared_afnetworkCompletionQueue];
        }else{
            self.completionQueue = NULL;
        }
        
//        __block typeof(self) weakSelf = self;
//        [self setTaskDidComplete:^(NSURLSession *session, NSURLSessionTask *task, NSError *error) {
//            if(weakSelf.finishedTag)
//                [weakSelf recyle];
//            else{
//                weakSelf.finishedTag = YES;
//            }
//        }];
        
    }
    return self;
}
//-(void)addDataBlock:(AFNetworkingTaskDataBlock _Nullable)dataBlock{
//    [container addDataBlock:dataBlock];
//}

-(AFHTTPResponseSerializer<AFURLResponseSerialization> * _Nonnull)responseSerializer{
    
    
    return [self.container.serializerAdapter responseSerializer:self.container.responseType];
}
-(AFHTTPRequestSerializer<AFURLRequestSerialization> * _Nonnull)requestSerializer{
    return [self.container.serializerAdapter requestSerializer:self.container.requestType];
}
    





#pragma mark - process  Recyle 
-(void)recyle{
    
    [self.container recyle];
    self.container = nil;
    
}

-(void)dealloc{
//    NSLog(@"------%@ dealloc",self.class);
}

@end
