 

#import "AFNetworkAnalysis.h" 

@implementation AFNetworkMsg

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.code =-1;
    }
    return self;
}

-(BOOL)isSuccess{
    self.code = 200;
}
-(void)recyle{
    self.responseHeaders = nil;
}

@end


@interface AFNetworkAnalysis() 
@property (nonatomic,strong) NSDictionary *analysises NS_AVAILABLE_IOS(7_0);
@property (nonatomic,strong,readwrite) NSDictionary *body NS_AVAILABLE_IOS(7_0);
@property (nonatomic,strong,readwrite) id originalBody NS_AVAILABLE_IOS(7_0);

-(void)addAnalysis:(NSString *)key structure:(Class)clazz;
-(void)addAnalysis:(NSString *)key structureArray:(Class)clazz;

@end

@implementation AFNetworkAnalysis
@synthesize analysises;
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.msg = [AFNetworkMsg new];
        self.completionCustomQueue = NO;
        self.requestType = AFNetworkRequestProtocolTypeNormal;
        self.responseType = AFNetworkResponseProtocolTypeJSON;
        
        analysises =[[NSMutableDictionary alloc] init];
        
    }
    return self;
}
 
-(void)setAnalysises:(NSDictionary *)_analysises{
    analysises =[[NSMutableDictionary alloc] initWithDictionary:_analysises];
} 

-(void)addAnalysis:(NSString *)key structure:(Class)clazz{
    [(NSMutableDictionary *)self.analysises setObject:clazz forKey:key];
}
-(void)addAnalysis:(NSString *)key structureArray:(Class)clazz{
    [(NSMutableDictionary *)self.analysises setObject:@[clazz,[NSArray class]] forKey:key];
}


-(void)analysisBody{
    
    if([self.originalBody isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic = self.originalBody;
        [self.msg mj_setKeyValues:dic];
        
        
        NSMutableDictionary *body =[NSMutableDictionary new];
        
        
        for (NSString *key in self.analysises) {
            NSObject *obj = [self.analysises objectForKey:key];
            
            NSObject *value = nil;
            if([key isEqualToString:kAllBodyObjectInfo]){
                value = dic;
            }else{
                value = [dic objectForKey:key];
            }
            
            
            if([obj isKindOfClass:[NSArray class]]){
                NSArray *array = obj;
                
                if(array.count==1){
                    Class clazz = [array objectAtIndex:0];
                    NSObject *object =  [clazz mj_objectWithKeyValues:value];
                    [body setObject:object forKey:key];
                }else if(array.count==2){
                    Class clazz = [array objectAtIndex:0];
                    Class type = [array objectAtIndex:1];
                    if(![type isSubclassOfClass:[NSArray class]]){
                        NSObject *object =  [clazz mj_objectWithKeyValues:value];
                        [body setObject:object forKey:key];
                    }else{
                        NSArray *object =  [clazz mj_objectArrayWithKeyValuesArray:value];
                        [body setObject:object forKey:key];
                    }
                }else{
                    NSException *exction =[[NSException alloc] initWithName:@"解析方法构造错误" reason:key userInfo:nil];
                    @throw exction;
                }
            }else{
                
                Class clazz = obj;
                NSObject *object =  [clazz mj_objectWithKeyValues:value];
                [body setObject:object forKey:key];
                 
            }
        }
        self.body = body;
    }
    // TODO  自定义数据分析，通过
}
-(NSMutableDictionary *)requestHeaders{
    return nil;
}
-(void)recyle{
    [self.msg recyle];
    self.msg = nil;
    
    
    self.analysises = nil;
    self.body = nil;
    self.originalBody = nil;
}

@end

@implementation AFNetworkCustomQueueAnalysis
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.completionCustomQueue = YES;
        
    }
    return self;
}


@end
