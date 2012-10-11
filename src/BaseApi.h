
#import <TBase.h>

#if NS_BLOCKS_AVAILABLE
typedef void (^BaseAPICallbackResultBlock)(TBase* responseObject);
typedef void (^BaseAPICallbackFailureBlock)(NSError *error);
#endif

enum OnesiteResultCode {
	OnesiteResultCode_OK = 100,
	OnesiteResultCode_HTTP_ERROR = 404
};

@interface BaseApi : NSObject
{
    NSString *_name;
    NSString *_accessToken;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *accessToken;

- (id)initWithAPIName:(NSString*)name;

- (void)executeThriftMethodName:(NSString*)method
              withResponseTBase:(TBase*)responseObject
            withParamDictionary:(NSMutableDictionary*)params;

- (void)executeThriftMethodName:(NSString*)method
                 withResponseTBase:(TBase*)responseObject
               withParamDictionary:(NSMutableDictionary*)params
                    resultCallback:(BaseAPICallbackResultBlock)resultCallback
                     errorCallback:(BaseAPICallbackFailureBlock)errorCallback;

- (void)throwErrorCode:(NSInteger)code
	   withMessage:(NSString*)message
	 errorCallback:(BaseAPICallbackFailureBlock)errorCallback;

@end
