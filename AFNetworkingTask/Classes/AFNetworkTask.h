 

#import <Foundation/Foundation.h>
#import "AFNetworkTaskPatch.h"

@interface AFNetworkTask : AFNetworkTaskPatch


- (instancetype _Nonnull)initWithContainer:(AFNetworkContainer * _Nonnull)container;

#pragma mark - GET

-(void)GET:(NSString * _Nonnull)url  finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)GET:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)GET:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finish;

#pragma mark - POST

-(void)POST:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)POST:(NSString * _Nonnull)URLString form:(NSDictionary *  _Nullable)form finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finish;

-(void)POST:(NSString * _Nonnull)URLString data:(id<AFNetworkRequestData> _Nullable)data files:(NSDictionary * _Nullable)files finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)POST:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form files:(NSDictionary * _Nullable)files finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finish;

#pragma mark - PUT

-(void)PUT:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)PUT:(NSString * _Nonnull)URLString form:(NSDictionary *  _Nullable)form finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finish;

-(void)PUT:(NSString * _Nonnull)URLString data:(id<AFNetworkRequestData> _Nullable)data files:(NSDictionary * _Nullable)files finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)PUT:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form files:(NSDictionary * _Nullable)files finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finish;

#pragma mark - PATCH

-(void)PATCH:(NSString * _Nonnull)url finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)PATCH:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)PATCH:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finish;


#pragma mark - DELETE

-(void)DELETE:(NSString * _Nonnull)url finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)DELETE:(NSString * _Nonnull)url data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)DELETE:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finish;


#pragma mark - DOWNLOAD

-(void)DOWNLOAD:(NSString * _Nonnull)url  finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)DOWNLOAD:(NSString * _Nonnull)URLString data:(id<AFNetworkRequestData> _Nullable)data finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finishedBlock;

-(void)DOWNLOAD:(NSString * _Nonnull)URLString form:(NSDictionary * _Nullable)form finishedBlock:(AFNetworkingTaskFinishedBlock _Nullable)finish;


#pragma mark - process  Recyle
-(void)cancel;

-(void)recyle;

@end
