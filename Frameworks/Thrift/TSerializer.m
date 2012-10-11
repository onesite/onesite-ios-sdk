/**
 * TSerializer
 * @author Charles Southerland <csoutherland@onesite.com>
 */

#import "TSerializer.h"

#import "TProtocol.h"
#import "TBinaryProtocol.h"
#import "TTransport.h"
#import "TMemoryBuffer.h"

@implementation TSerializer

- (id) init
{
	self = [super init];
  if (self) {
    __protocolFactory = [[TBinaryProtocolFactory alloc] init];
  }
  return self;
}

- (id) initWithProtocolFactory:(id)protocolFactory
{
	self = [super init];
  if (self) {
	  __protocolFactory = protocolFactory;
  }
  return self;
}

- (NSData*) serializeWithObject:(TBase*)object
{	
  TMemoryBuffer *buffer = [[TMemoryBuffer alloc] init];
  id <TProtocol> protocol = [__protocolFactory newProtocolOnTransport:buffer];
  [object write:protocol];
	
  return [buffer getBuffer];
}

- (void) deserializeIntoObject:(TBase*)object withData:(NSData*)data
{
  TMemoryBuffer *buffer = [[TMemoryBuffer alloc] initWithData:data];
  id <TProtocol> protocol = [__protocolFactory newProtocolOnTransport:buffer];
  [object read:protocol];
}

- (NSString*) serializeToStringWithObject:(TBase*)object
{
  NSData* data = [self serializeWithObject:object];
  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void) deserializeFromStringIntoObject:(TBase*)object withString:(NSString*)string
{
  NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
  [self deserializeIntoObject:object withData:data];
}

@end

