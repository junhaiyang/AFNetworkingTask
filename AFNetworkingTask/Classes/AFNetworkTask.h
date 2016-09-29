 

#import <Foundation/Foundation.h>
#import "AFNetworkTaskPatch.h"

@interface AFNetworkTask : AFNetworkTaskPatch


- (instancetype)initWithContainer:(AFNetworkContainer *)container;

#pragma mark - GET

-(void)GET:(NSString *)url  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock;

-(void)GET:(NSString *)url data:(id<AFNetworkRequestData>)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock;

-(void)GET:(NSString *)URLString form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finish;

#pragma mark - POST

-(void)POST:(NSString *)url data:(id<AFNetworkRequestData>)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock;

-(void)POST:(NSString *)URLString form:(id)form finishedBlock:(AFNetworkingTaskFinishedBlock)finish;

-(void)POST:(NSString *)URLString data:(id<AFNetworkRequestData>)data files:(NSDictionary *)files finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock;

-(void)POST:(NSString *)URLString form:(NSDictionary *)form files:(NSDictionary *)files finishedBlock:(AFNetworkingTaskFinishedBlock)finish;

#pragma mark - PUT

-(void)PUT:(NSString *)url data:(id<AFNetworkRequestData>)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock;

-(void)PUT:(NSString *)URLString form:(id)form finishedBlock:(AFNetworkingTaskFinishedBlock)finish;

-(void)PUT:(NSString *)URLString data:(id<AFNetworkRequestData>)data files:(NSDictionary *)files finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock;

-(void)PUT:(NSString *)URLString form:(NSDictionary *)form files:(NSDictionary *)files finishedBlock:(AFNetworkingTaskFinishedBlock)finish;

#pragma mark - PATCH

-(void)PATCH:(NSString *)url finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock;

-(void)PATCH:(NSString *)url data:(id<AFNetworkRequestData>)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock;

-(void)PATCH:(NSString *)URLString form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finish;


#pragma mark - DELETE

-(void)DELETE:(NSString *)url finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock;

-(void)DELETE:(NSString *)url data:(id<AFNetworkRequestData>)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock;

-(void)DELETE:(NSString *)URLString form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finish;


#pragma mark - DOWNLOAD

-(void)DOWNLOAD:(NSString *)url  finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock;

-(void)DOWNLOAD:(NSString *)URLString data:(id<AFNetworkRequestData>)data finishedBlock:(AFNetworkingTaskFinishedBlock)finishedBlock;

-(void)DOWNLOAD:(NSString *)URLString form:(NSDictionary *)form finishedBlock:(AFNetworkingTaskFinishedBlock)finish;


#pragma mark - process  Recyle
-(void)cancel;

-(void)recyle;

@end
