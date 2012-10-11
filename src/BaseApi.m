
#import "BaseAPI.h"
#import "OnesiteService.h"
#import "NSError+Extensions.h"
#import <TSerializer.h>

@implementation BaseApi

@synthesize name = _name;
@synthesize accessToken = _accessToken;

- (id)init
{
    self = [super init];
    if (self) {
        [self setName:nil];
        [self setAccessToken:nil];
    }
    return self;
}

- (id)initWithAPIName:(NSString*)name
{
    self = [super init];
    if (self) {
        [self setName:name];
        [self setAccessToken:nil];
    }
    return self;
}

- (void)dealloc
{
    [_name release], self.name = nil;
    [_accessToken release], self.accessToken = nil;

    [super dealloc];
}

- (void)executeThriftMethodName:(NSString*)method
              withResponseTBase:(TBase*)responseObject
            withParamDictionary:(NSMutableDictionary*)params
{
    [self executeThriftMethodName:method
                withResponseTBase:responseObject
              withParamDictionary:params
                   resultCallback:nil
                    errorCallback:nil
     ];
}

- (void)executeThriftMethodName:(NSString*)method withResponseTBase:(TBase*)responseObject withParamDictionary:(NSMutableDictionary*)params resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    if ([self name] != nil) {
        [params setObject:[[[[self name] stringByAppendingString:[NSString stringWithFormat:@"/"]] stringByAppendingString:method] stringByAppendingString:[NSString stringWithFormat:@".thrift"]] forKey:[NSString stringWithFormat:@"method"]];
    } else {
        [params setObject:[method stringByAppendingString:[NSString stringWithFormat:@".thrift"]] forKey:[NSString stringWithFormat:@"method"]];
    }

    if ([self accessToken] != nil) {
        [params setObject:[self accessToken] forKey:@"accessToken"];
    }

    OnesiteService* onesiteSession = [[OnesiteService alloc] init];
    [onesiteSession callRestServiceWithParameters:params resultCallback:^(NSData* data)
     {
         TSerializer* serializer = [[TSerializer alloc] init];
         [serializer deserializeIntoObject:responseObject withData:data];
         DELOG(@"Deserialized Apache Thrift object");
         free(serializer);

         if (resultCallback) {
             resultCallback(responseObject);
         }
     } errorCallback:^(NSError* error)
     {
         DELOG(@"%s", [[error localizedDescription] UTF8String]);

         if (errorCallback) {
             errorCallback(error);
         } else {
            exit(EXIT_FAILURE);
         }
     }];
}

- (void)throwErrorCode:(NSInteger)code withMessage:(NSString*)message errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
	NSError* error = [NSError errorWithDomain:[NSString stringWithFormat:@"com.onesite.sdk"] code:code message:message];
	if (errorCallback) {
		errorCallback(error);
	} else {
		exit(EXIT_FAILURE);
	}
}

@end
