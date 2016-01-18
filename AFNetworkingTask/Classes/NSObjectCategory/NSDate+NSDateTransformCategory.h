

#import <Foundation/Foundation.h>

@interface NSObjectCategoryData:NSObject
 
+(NSDateFormatter *)dateFormatter;

+(NSDateFormatter *)dateFormatter_ymdhm;

+(NSDateFormatter *)dateFormatter_ymd;

+(NSDateFormatter *)dateFormatter_simple;

+(NSDateFormatter *)dateFormatter_hm;

+(NSDateFormatter *)dateFormatter_hms;


@end

@interface NSDate(NSDateTransformCategory)


-(NSString *)transformToString;

-(NSString *)transformToYMDHmString;

-(NSString *)transformToYMDString;

-(NSString *)transformToSimpleString;

-(NSString *)transformToHmString;

-(NSString *)transformToHmsString;

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
-(NSString *) compareCurrentTime;

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
-(NSString *) compareFutureTime;

@end

@interface NSString(NSDateTransformCategory)

-(NSDate *)transformFromString;

-(NSDate *)transformYMDHmFromString;

-(NSDate *)transformYMDFromString;

-(NSDate *)transformSimpleFromString;

-(NSDate *)transformHmFromString;

-(NSDate *)transformHmsFromString;

@end