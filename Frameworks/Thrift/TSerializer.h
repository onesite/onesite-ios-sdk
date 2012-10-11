/**
 * TSerializer
 * @author Charles Southerland <csoutherland@onesite.com>
 */

#import "TProtocolFactory.h"
#import "TBase.h"

@interface TSerializer : NSObject {
  id <TProtocolFactory> __protocolFactory;
}

- (id) initWithProtocolFactory:(id)protocolFactory;
- (NSData*) serializeWithObject:(TBase*)object;
- (void) deserializeIntoObject:(TBase*)object withData:(NSData*)data;
- (NSString*) serializeToStringWithObject:(TBase*)object;
- (void) deserializeFromStringIntoObject:(TBase*)object withString:(NSString*)string;

@end

