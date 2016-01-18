 

#import "NSDate+NSDateTransformCategory.h"


@implementation NSObjectCategoryData


static NSDateFormatter *FORMATOR;
static NSDateFormatter *FORMATOR_YMDHM;
static NSDateFormatter *FORMATOR_YMD;

static NSDateFormatter *FORMATOR_SIMPLE;
static NSDateFormatter *FORMATOR_HOUR_MINUTE;
static NSDateFormatter *FORMATOR_HMS;
 

+(void)load{
    
    FORMATOR = [[NSDateFormatter alloc] init];
    [FORMATOR setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    FORMATOR_YMDHM = [[NSDateFormatter alloc] init];
    [FORMATOR_YMDHM setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    FORMATOR_YMD = [[NSDateFormatter alloc] init];
    [FORMATOR_YMD setDateFormat:@"yyyy-MM-dd"];
    
    FORMATOR_SIMPLE = [[NSDateFormatter alloc] init];
    [FORMATOR_SIMPLE setDateFormat:@"yyyyMMddHHmmss"];
    
    FORMATOR_HOUR_MINUTE = [[NSDateFormatter alloc] init];
    [FORMATOR_HOUR_MINUTE setDateFormat:@"HH:mm"];
    
    FORMATOR_HMS = [[NSDateFormatter alloc] init];
    [FORMATOR_HMS setDateFormat:@"HH:mm:ss"];
}

+(NSDateFormatter *)dateFormatter{
    return FORMATOR;
}

+(NSDateFormatter *)dateFormatter_ymdhm{
    return FORMATOR_YMDHM;
}

+(NSDateFormatter *)dateFormatter_ymd{
    return FORMATOR_YMD;
}

+(NSDateFormatter *)dateFormatter_simple{
    return FORMATOR_SIMPLE;
}

+(NSDateFormatter *)dateFormatter_hm{
    return FORMATOR_HOUR_MINUTE;
}

+(NSDateFormatter *)dateFormatter_hms{
    return FORMATOR_HMS;
}

@end

@implementation NSDate(NSDateTransformCategory)

-(NSString *)transformToString{
    return [[NSObjectCategoryData dateFormatter] stringFromDate:self];
}

-(NSString *)transformToYMDHmString{
    return [[NSObjectCategoryData dateFormatter_ymdhm] stringFromDate:self];
}


-(NSString *)transformToYMDString{
    return [[NSObjectCategoryData dateFormatter_ymd] stringFromDate:self];
}

-(NSString *)transformToSimpleString{
    return [[NSObjectCategoryData dateFormatter_simple] stringFromDate:self];
}

-(NSString *)transformToHmString{
    return [[NSObjectCategoryData dateFormatter_hm] stringFromDate:self];
}

-(NSString *)transformToHmsString{
    return [[NSObjectCategoryData dateFormatter_hms] stringFromDate:self];
}

-(NSString *) compareCurrentTime
{
    NSTimeInterval  timeInterval = [self timeIntervalSinceNow];
    timeInterval = -timeInterval;
    NSInteger temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分前",(int)temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%d小时前",(int)temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%d天前",(int)temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%d个月前",(int)temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%d年前",(int)temp];
    }
    
    return  result;
}

-(NSString *) compareFutureTime
{
    NSTimeInterval  timeInterval = [self timeIntervalSinceNow];
    timeInterval =  timeInterval;
    NSInteger temp = 0;
    NSString *result;
    if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"剩余%d分",(int)temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"剩余%d小时",(int)temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"剩余%d天",(int)temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"剩余%d个月",(int)temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"剩余%d年",(int)temp];
    }
    
    return  result;
}

@end

@implementation NSString(NSDateTransformCategory)

-(NSDate *)transformFromString{
    return [[NSObjectCategoryData dateFormatter] dateFromString:self];
}

-(NSDate *)transformYMDHmFromString{
    return [[NSObjectCategoryData dateFormatter_ymdhm] dateFromString:self];
}
 
-(NSDate *)transformYMDFromString{
    return [[NSObjectCategoryData dateFormatter_ymd] dateFromString:self];
}

-(NSDate *)transformSimpleFromString{
    return [[NSObjectCategoryData dateFormatter_simple] dateFromString:self];
}

-(NSDate *)transformHmFromString{
    return [[NSObjectCategoryData dateFormatter_hm] dateFromString:self];
}

-(NSDate *)transformHmsFromString{
    return [[NSObjectCategoryData dateFormatter_hms] dateFromString:self];
}


@end
