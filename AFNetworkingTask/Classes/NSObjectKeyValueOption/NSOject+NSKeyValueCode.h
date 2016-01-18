 
#import <Foundation/Foundation.h>

@interface NSObject(NSKeyValueCode)

+(id)objectKeyValueDecode:(NSData *)data;

+(NSData *) objectKeyValueEncode:(id)obj;

@end
