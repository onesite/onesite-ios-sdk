/**
 * ONEsite User API
 *
 * @author Charles Southerland <csoutherland@onesite.com>
 */

#import "BaseApi.h"
#import "OnesiteDao.h"
#import "OnesiteApi.h"

enum OnesiteUserResultCode {
	OnesiteUserResultCode_MISSING_PARAMETERS = 190,
	OnesiteUserResultCode_INVALID_USER = 200,
	OnesiteUserResultCode_MISSING_USERNAME = 203,
	OnesiteUserResultCode_USERNAME_TAKEN = 207,
	OnesiteUserResultCode_EMAIL_TAKEN = 208,
	OnesiteUserResultCode_SUBDIR_TAKEN = 209,
	OnesiteUserResultCode_ACCOUNT_TAKEN = 210
};

@interface UserApi : BaseApi {
}

+ (id)getInstance;
- (void)createUser:(User*)user withPassword:(Password*)password withUserCreateOptions:(UserCreateOptions*)options resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)createSessionUser:(User*)user withPassword:(Password*)password withUserCreateOptions:(UserCreateOptions*)options withSessionOptions:(SessionOptions*)sessionOptions resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)deleteUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)updateUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)getDetailsOfUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)isAvailableUsername:(NSString*)username resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)isAvailableEmail:(NSString*)email resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)isAvailableSubdir:(NSString*)subdir resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)isAvailableExternalAccount:(ExternalAccount*)account resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)addExternalAccount:(ExternalAccount*)account toUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)updateExternalAccount:(ExternalAccount*)account forUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)deleteExternalAccount:(ExternalAccount*)account fromUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)getExternalAccount:(ExternalAccount*)account fromUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)addExternalProperty:(ExternalProperty*)property toUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void) getExternalProperty:(ExternalProperty*)property fromUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)deleteExternalProperty:(ExternalProperty*)property fromUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)getUserByExternalProperty:(ExternalProperty*)property resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
- (void)validateCredentialsForNodeId:(long)nodeID forUsername:(NSString*)username forPassword:(NSString*)password resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback;

@end
