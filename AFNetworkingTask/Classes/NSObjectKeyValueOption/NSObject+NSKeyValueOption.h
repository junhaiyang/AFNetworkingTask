 

#import <Foundation/Foundation.h>

@protocol NSObjectCopyKeyValue

@end

@interface NSObject(NSObjectKeyValueCopy)

/**
 *
 * 对象值复制，要求两个对象class必须一致
 * src: 源数据
 * dest: 目标数据
 * transients: 忽略数据
 *
 **/
+ (void) copyObject:(NSObject<NSObjectCopyKeyValue> *) src toObject:(NSObject<NSObjectCopyKeyValue> *) dest;
+ (void) copyObject:(NSObject<NSObjectCopyKeyValue> *) src toObject:(NSObject<NSObjectCopyKeyValue> *) dest transients:(NSArray *) transients;

/**
 *
 * 对象值复制，对象class 任意
 * src: 源数据
 * dest: 目标数据
 * transients: 忽略数据
 *
 **/
+ (void) copyAnyObject:(NSObject<NSObjectCopyKeyValue> *) src toAnyObject:(NSObject<NSObjectCopyKeyValue> *) dest;
+ (void) copyAnyObject:(NSObject<NSObjectCopyKeyValue> *) src toAnyObject:(NSObject<NSObjectCopyKeyValue> *) dest transients:(NSArray *) transients;

/**
 *
 * 对象值复制，对象class 任意
 * dest: 目标数据
 * transients: 忽略数据
 *
 **/
- (void) setValuesKeysToObject:(NSObject<NSObjectCopyKeyValue> *) dest;
- (void) setValuesKeysToObject:(NSObject<NSObjectCopyKeyValue> *) dest transients:(NSArray *) transients;

/**
 *
 * 对象值复制，字典拷贝到对象
 * src: 源字典
 * dest: 目标数据
 * transients: 忽略数据
 *
 **/
+ (void) copyDictionary:(NSDictionary *)src toObject:(NSObject<NSObjectCopyKeyValue> *) dest;
+ (void) copyDictionary:(NSDictionary *)src toObject:(NSObject<NSObjectCopyKeyValue> *) dest transients:(NSArray *) transients;

/**
 *
 * 对象值复制，字典拷贝到对象
 * src: 源字典
 * transients: 忽略数据
 *
 **/
- (void) setValuesForKeysFromDictionary:(NSDictionary *) src;
- (void) setValuesForKeysFromDictionary:(NSDictionary *) src transients:(NSArray *) transients;

/**
 *
 * 对象拷贝到字典
 * src: 源对象
 * transients: 忽略数据
 *
 **/
+ (NSDictionary<NSString *, id> *)dictionaryKeysValues:(NSObject<NSObjectCopyKeyValue> *) src;
+ (NSDictionary<NSString *, id> *)dictionaryKeysValues:(NSObject<NSObjectCopyKeyValue> *) src transients:(NSArray *) transients;

- (NSDictionary<NSString *, id> *)dictionaryKeysValues;
- (NSDictionary<NSString *, id> *)dictionaryKeysValuesWithTransients:(NSArray *) transients;

@end


@interface NSDictionary(NSDictionaryKeyValueCopy)


/**
 *
 * 对象拷贝到字典
 * src: 源对象
 * transients: 忽略数据
 *
 **/
- (void) setValuesForKeysToObject:(NSObject<NSObjectCopyKeyValue> *) dest;
- (void) setValuesForKeysToObject:(NSObject<NSObjectCopyKeyValue> *) dest transients:(NSArray *) transients;

@end

/**
 *
 * 字典数据
 *
 **/
@interface NSDictionary<__covariant KeyType, __covariant ObjectType>(NSDictionaryGetValue)


- (NSString *)stringForKey:(id)aKey;
- (NSNumber *)numberForKey:(id)aKey;
- (NSArray<ObjectType> *)arrayForKey:(id)aKey;
- (NSDictionary<KeyType, ObjectType> *)dictionaryForKey:(id)aKey;

@end
/**
 *
 * 时间操作
 *
 **/
@interface NSDate(NSDateLongLongValue)

- (long long)longLongValue;
+ (instancetype)dateWithTimeIntervalLongLongValue:(long long)longLongValue;

@end
