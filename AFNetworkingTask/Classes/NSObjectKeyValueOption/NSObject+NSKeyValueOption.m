

#import "NSObject+NSKeyValueOption.h"
#import <objc/message.h>


@implementation NSObject(NSObjectCopyKeyValue)

+ (void) copyObject:(NSObject<NSObjectCopyKeyValue> *) src toObject:(NSObject<NSObjectCopyKeyValue> *) dest{
    [NSObject copyObject:src toObject:dest transients:nil];
}

+ (void) copyObject:(NSObject<NSObjectCopyKeyValue> *) src toObject:(NSObject<NSObjectCopyKeyValue> *) dest transients:(NSArray *) transients
{
    
    if(![src isKindOfClass:[dest class]]){
        NSException *e = [[NSException alloc] initWithName:@"对象类型不一致!" reason:nil userInfo:nil];
        @throw e;
    }else{
        [NSObject copyAnyObject:src toAnyObject:dest transients:transients];
    }
    
}
+ (void) copyAnyObject:(NSObject<NSObjectCopyKeyValue> *) src toAnyObject:(NSObject<NSObjectCopyKeyValue> *) dest{
    [NSObject copyAnyObject:src toAnyObject:dest transients:nil];
}

+ (void) copyAnyObject:(NSObject<NSObjectCopyKeyValue> *) src toAnyObject:(NSObject<NSObjectCopyKeyValue> *) dest transients:(NSArray *) transients
{
    if(![src conformsToProtocol:@protocol(NSObjectCopyKeyValue)]){
        NSException *e = [[NSException alloc] initWithName:@"对象未实现协议 NSObjectCopyKeyValue!" reason:nil userInfo:nil];
        @throw e;
    }
    if(![dest conformsToProtocol:@protocol(NSObjectCopyKeyValue)]){
        NSException *e = [[NSException alloc] initWithName:@"对象未实现协议 NSObjectCopyKeyValue!" reason:nil userInfo:nil];
        @throw e;
    }
    
    NSMutableArray<NSString *> *keys =[NSMutableArray<NSString *> new];
    
    {
        
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList([src class], &outCount);
        for(int i=0;i<outCount;i++)
        {
            objc_property_t property = properties[i];
            
            NSString *key = [NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
            
            [keys addObject:key];
            
        }
        free(properties);
    }
    
    if(![src isKindOfClass:[dest class]]){
        
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList([dest class], &outCount);
        for(int i=0;i<outCount;i++)
        {
            objc_property_t property = properties[i];
            
            NSString *key = [NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
            if(![keys containsObject:key])
                [keys removeObject:key];
            
        }
        free(properties);
    }
    
    [keys removeObjectsInArray:transients];
    
    NSDictionary<NSString *,id> *keyValues = [src dictionaryWithValuesForKeys:keys];
    
    [dest setValuesForKeysWithDictionary:keyValues];
    
}
- (void) setValuesKeysToObject:(NSObject<NSObjectCopyKeyValue> *) dest{
    [NSObject copyAnyObject:(NSObject<NSObjectCopyKeyValue> *)self toAnyObject:dest transients:nil];
}
- (void) setValuesKeysToObject:(NSObject<NSObjectCopyKeyValue> *) dest transients:(NSArray *) transients{
    [NSObject copyAnyObject:(NSObject<NSObjectCopyKeyValue> *)self toAnyObject:dest transients:nil];
}

+ (void) copyDictionary:(NSDictionary *) src toObject:(NSObject<NSObjectCopyKeyValue> *) dest{
    [NSObject copyDictionary:src toObject:dest transients:nil];
}

+ (void) copyDictionary:(NSDictionary *)src toObject:(NSObject<NSObjectCopyKeyValue> *) dest transients:(NSArray *) transients
{
    NSMutableDictionary *keyValues =[[NSMutableDictionary alloc] init];
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([dest class], &outCount);
    for(int i=0;i<outCount;i++)
    {
        objc_property_t property = properties[i];
        
        NSString *key = [NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
        
        NSString *attr = [NSString stringWithCString:property_getAttributes(property) encoding:NSASCIIStringEncoding];
        
        if ([attr hasPrefix:@"T@"]) {
            id value = ((id(*)(id, SEL))objc_msgSend)(dest, NSSelectorFromString(key));
            if([value conformsToProtocol:@protocol(NSObjectCopyKeyValue)]){
                id dicValue = [src objectForKey:key];
                [NSObject copyDictionary:dicValue toObject:value transients:transients];
                continue;
            }
        } 
        
        if([src objectForKey:key]){
            [keyValues setObject:[src objectForKey:key] forKey:key];
        }
        
    }
    free(properties);
    
    [keyValues removeObjectsForKeys:transients];
    
    [dest setValuesForKeysWithDictionary:keyValues];
    
}
- (void) setValuesForKeysFromDictionary:(NSDictionary *) src{
    [self setValuesForKeysFromDictionary:src transients:nil];
}
- (void) setValuesForKeysFromDictionary:(NSDictionary *) src transients:(NSArray *) transients{
    NSMutableDictionary *keyValues =[[NSMutableDictionary alloc] initWithDictionary:src];
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(int i=0;i<outCount;i++)
    {
        objc_property_t property = properties[i];
        
        NSString *key = [NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
        
        
        NSString *attr = [NSString stringWithCString:property_getAttributes(property) encoding:NSASCIIStringEncoding];
        
        if ([attr hasPrefix:@"T@"]) {
            id value = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(key));
            if([value conformsToProtocol:@protocol(NSObjectCopyKeyValue)]){
                id dicValue = [src objectForKey:key];
                [NSObject copyDictionary:dicValue toObject:value transients:transients];
                continue;
            }
        }
        
        if([src objectForKey:key]){
            [keyValues setObject:[src objectForKey:key] forKey:key];
        }
        
    }
    free(properties);
    
    [keyValues removeObjectsForKeys:transients];
    
    [self setValuesForKeysWithDictionary:keyValues];
    
    
#if DEBUG
    
    
#endif

}


+ (NSDictionary<NSString *, id> *)dictionaryKeysValues:(NSObject<NSObjectCopyKeyValue> *) src{
    return [NSObject dictionaryKeysValues:src transients:nil];
    
}
+ (NSDictionary<NSString *, id> *)dictionaryKeysValues:(NSObject<NSObjectCopyKeyValue> *) src transients:(NSArray *) transients{
    NSMutableArray<NSString *> *keys =[NSMutableArray<NSString *> new];
    
    {
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList([src class], &outCount);
        for(int i=0;i<outCount;i++)
        {
            objc_property_t property = properties[i];
            
            NSString *key = [NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
#if DEBUG
            NSString *attr = [NSString stringWithCString:property_getAttributes(property) encoding:NSASCIIStringEncoding];
            if([attr rangeOfString:@",W"].location!=NSNotFound){
                if(![transients containsObject:key]){
                    NSString *class_name = [NSString stringWithCString:class_getName([src class]) encoding:NSASCIIStringEncoding];
                    NSMutableString *string =[NSMutableString new];
                    [string appendString:class_name];
                    [string appendString:@" 存在Weak类型数据："];
                    [string appendString:key];
                    NSException *e = [[NSException alloc] initWithName:string reason:nil userInfo:nil];
                    @throw e;
                }
            }
            
#endif
            
            [keys addObject:key];
            
        }
        free(properties);
    }
    
    [keys removeObjectsInArray:transients];
    
    return [self dictionaryWithValuesForKeys:keys];
}

- (NSDictionary<NSString *, id> *)dictionaryKeysValues{
    return [NSObject dictionaryKeysValues:(NSObject<NSObjectCopyKeyValue> *)self transients:nil];
}
- (NSDictionary<NSString *, id> *)dictionaryKeysValuesWithTransients:(NSArray *) transients{
    return [NSObject dictionaryKeysValues:(NSObject<NSObjectCopyKeyValue> *)self transients:nil];
}

@end

@implementation NSDictionary(NSDictionaryKeyValueCopy)

- (void) setValuesForKeysToObject:(NSObject<NSObjectCopyKeyValue> *) dest{
    [NSObject copyDictionary:self toObject:dest transients:nil];
}
- (void) setValuesForKeysToObject:(NSObject<NSObjectCopyKeyValue> *) dest transients:(NSArray *) transients{
    [NSObject copyDictionary:self toObject:dest transients:transients];
}

@end


@implementation NSDictionary(NSDictionaryGetValue)


- (NSString *)stringForKey:(id)aKey{
    NSObject *obj  =  [self objectForKey:aKey];
    if([obj isKindOfClass:[NSString class]])
        return (NSString *)obj;
    else
        return nil;
}
- (NSNumber *)numberForKey:(id)aKey{
    NSObject *obj  =  [self objectForKey:aKey];
    if([obj isKindOfClass:[NSNumber class]])
        return (NSNumber *)obj;
    else
        return nil;
}

- (NSArray *)arrayForKey:(id)aKey{
    NSObject *obj  =  [self objectForKey:aKey];
    if([obj isKindOfClass:[NSArray class]])
        return (NSArray *)obj;
    else
        return nil;
}
- (NSDictionary *)dictionaryForKey:(id)aKey{
    NSObject *obj  =  [self objectForKey:aKey];
    if([obj isKindOfClass:[NSDictionary class]])
        return (NSDictionary *)obj;
    else
        return nil;
}

@end

@implementation NSDate(NSDateLongLongValue)

- (long long)longLongValue{
    return (long long)(self.timeIntervalSince1970 *1000.0);
}
+ (instancetype)dateWithTimeIntervalLongLongValue:(long long)longLongValue{
    return [NSDate dateWithTimeIntervalSince1970:(longLongValue *1.0)/1000.0];
}

@end