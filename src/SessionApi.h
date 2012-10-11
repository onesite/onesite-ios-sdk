#import "BaseApi.h"
#import "OnesiteDao.h"
#import "OnesiteApi.h"

enum OnesiteSessionResultCode {
	OnesiteSessionResultCode_MISSING_PARAMETERS = 190,
	OnesiteSessionResultCode_MISSING_USERNAME = 203
};

@interface SessionApi : BaseApi {
}

+ (id)getInstance;
- (void)createSession:(Session*)session withSessionOptions:(SessionOptions*)sessionOptions resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)createCrossDomainUser:(User*)user withCallbackUrl:(NSString*)callbackUrl withIp:(NSString*)ip withExpiresFromNow:(long)expiresFromNow resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)loginUser:(User*)user withPassword:(NSString*)password withAgent:(NSString*)agent withIp:(NSString*)ip withExpiresFromNow:(long)expiresFromNow resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)loginCrossDomainUser:(User*)user withPassword:(NSString*)password withCallbackUrl:(NSString*)callbackUrl withIp:(NSString*)ip withExpiresFromNow:(long)expiresFromNow resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)logoutSession:(Session*)session resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)checkSession:(Session*)session resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)joinCrossDomainCallbackUrl:(NSString*)callbackUrl withDomain:(NSString*)domain withIp:(NSString*)ip withAgent:(NSString*)agent resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;


@end

