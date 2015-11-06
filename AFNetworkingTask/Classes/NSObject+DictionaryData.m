 
#import "NSObject+DictionaryData.h"
#import <objc/message.h>

@implementation NSObject (DictionaryData)
 

+ (NSDictionary *) transformObjcToDictionary:(id) obj {
    return [NSObject transformObjcToDictionary:obj transients:nil];
}


+ (NSDictionary *) transformObjcToDictionary:(id) obj transients:(NSArray *) transients
{
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:0];
    
    for(int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *key = [NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
        
        BOOL isTransients = NO;
        if (transients) {
            NSPredicate *pTransients = [NSPredicate predicateWithFormat:@"SELF=%@", key];
            NSArray *results = [transients filteredArrayUsingPredicate:pTransients];
            isTransients = (results.count != 0);
        }

        if(![obj respondsToSelector:NSSelectorFromString(key)] || isTransients) continue;
        NSString *pType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        NSString *keyValue = nil;
        if ([key isEqualToString:@"_Id"]) keyValue = @"id"; else keyValue = key;
        
        if ([pType hasPrefix:@"T@"]) {
            id value = ((id(*)(id, SEL))objc_msgSend)(obj, NSSelectorFromString(key));
            if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSMutableString class]] ||
                [value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSMutableArray class]] ||
                [value isKindOfClass:[NSData class]] || [value isKindOfClass:[NSMutableData class]] ||
                [value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableDictionary class]] ||
                [value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSNull class]])
            {
                [result setObject:value forKey:keyValue];
            }
            else if (!value) continue;
            else [result setObject:[NSObject transformObjcToDictionary:value transients:transients] forKey:key];
        }
        else if([pType hasPrefix:@"T{"]) {}
        else
        {
            pType = [pType lowercaseString];
            if ([pType hasPrefix:@"ti"] || [pType hasPrefix:@"tb"])
            {
                int value = ((int (*)(id, SEL))objc_msgSend)(obj, NSSelectorFromString(key));
                [result setObject:[NSNumber numberWithInt:value] forKey:keyValue];
            }
            else if ([pType hasPrefix:@"tf"])
            {
                float value = ((float (*)(id, SEL))objc_msgSend)(obj, NSSelectorFromString(key));
                [result setObject:[NSNumber numberWithFloat:value] forKey:keyValue];
            }
            else if([pType hasPrefix:@"td"])
            {
                double value = ((double (*)(id, SEL))objc_msgSend)(obj, NSSelectorFromString(key));
                [result setObject:[NSNumber numberWithDouble:value] forKey:keyValue];
            }
            else if([pType hasPrefix:@"tl"] || [pType hasPrefix:@"tq"])
            {
                long long value = ((long long (*)(id, SEL))objc_msgSend)(obj, NSSelectorFromString(key));
                [result setObject:[NSNumber numberWithLongLong:value] forKey:keyValue];
            }
            else if ([pType hasPrefix:@"tc"])
            {
                char value = ((char (*)(id, SEL))objc_msgSend)(obj, NSSelectorFromString(key));
                [result setObject:[NSNumber numberWithChar:value] forKey:keyValue];
            }
            else if([pType hasPrefix:@"ts"])
            {
                short value = ((short (*)(id, SEL))objc_msgSend)(obj, NSSelectorFromString(key));
                [result setObject:[NSNumber numberWithShort:value] forKey:keyValue];
            }
        }
    }
    free(properties);
    return result;
}

@end
    
    


