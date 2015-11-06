 

#import <Foundation/Foundation.h>

@interface NSObject (DictionaryData)


+ (NSDictionary *) transformObjcToDictionary:(id) obj;


+ (NSDictionary *) transformObjcToDictionary:(id) obj transients:(NSArray *) transients;

@end
 
