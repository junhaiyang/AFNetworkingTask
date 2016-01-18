 

#import "NSOject+NSKeyValueCode.h"
#define  NSCODE_KEY_VALUE @"ns_code_key_value"

@implementation NSObject(NSKeyValueCode)

+(id) objectKeyValueDecode:(NSData *) data{
    if(!data)
        return nil;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *myDictionary = [unarchiver decodeObjectForKey:NSCODE_KEY_VALUE];
    [unarchiver finishDecoding];
    return [myDictionary objectForKey:NSCODE_KEY_VALUE];
    
}

+(NSData *) objectKeyValueEncode:(id)obj{
    if(!obj)
        return nil;
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:(NSMutableData *)data];
    [archiver encodeObject:[[NSDictionary alloc] initWithObjectsAndKeys:obj,NSCODE_KEY_VALUE, nil] forKey:NSCODE_KEY_VALUE];
    [archiver finishEncoding];
    
    return data;
}

@end
