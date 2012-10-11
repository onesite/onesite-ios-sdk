#import "SessionApi.h"
#import "OnesiteApi.h"

static SessionApi* _instance = nil;

@implementation SessionApi : BaseApi

+ (id)getInstance
{
	if (!_instance) {
		_instance = [[SessionApi alloc] init];
	}
	return _instance;
}

- (id)init
{
	self = [super initWithAPIName:@"1/session"];
	if (!self) {
	}
	return self;
}

- (void)createSession:(Session*)session withSessionOptions:(SessionOptions *)sessionOptions resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
	NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    
    if ([session ipIsSet]) {
        [dictionary setObject:[session ip] forKey:[NSString stringWithFormat:@"ip"]];
    }
    
    if ([session agentIsSet]) {
        [dictionary setObject:[session agent] forKey:[NSString stringWithFormat:@"agent"]];
    }
    
    if ([session expiresTimeIsSet]) {
        [dictionary setObject:[NSNumber numberWithLong:[session expiresTime]] forKey:[NSString stringWithFormat:@"expires"]];
    }
    
	if ([session userIsSet]) {
		User* user = [session user];
		if ([user idIsSet] && [user id] != 0) {
			[dictionary setObject:[NSNumber numberWithLong:[user id]] forKey:[NSString stringWithFormat:@"user_id"]];
		} else if ([user usernameIsSet]) {
			[dictionary setObject:[user username] forKey:[NSString stringWithFormat:@"username"]];
		} else if ([user emailIsSet]) {
			[dictionary setObject:[user email] forKey:[NSString stringWithFormat:@"email"]];
		} else {
			[dictionary setObject:[NSNumber numberWithBool:true] forKey:[NSString stringWithFormat:@"anonymous"]];
		}
	} else {
		[dictionary setObject:[NSNumber numberWithBool:true] forKey:[NSString stringWithFormat:@"anonymous"]];
	}

	if ([session sessionDataIsSet]) {
		[dictionary setObject:[session sessionData] forKey:[NSString stringWithFormat:@"session_data"]];
	}
    
    if (sessionOptions != NULL) {
        if ([sessionOptions useAccessTokenIsSet]) {
            [dictionary setObject:[NSNumber numberWithBool:[sessionOptions useAccessToken]] forKey:[NSString stringWithFormat:@"use_access_token"]];
        }
    }

	[self executeThriftMethodName:[NSString stringWithFormat:@"create"]
		    withResponseTBase:[ResponseSession alloc]
		  withParamDictionary:dictionary
		       resultCallback:resultCallback
			errorCallback:errorCallback
	];
}

- (void)createCrossDomainUser:(User*)user withCallbackUrl:(NSString*)callbackUrl withIp:(NSString*)ip withExpiresFromNow:(long)expiresFromNow resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
	NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];

	[dictionary setObject:ip forKey:[NSString stringWithFormat:@"ip"]];
	[dictionary setObject:callbackUrl forKey:[NSString stringWithFormat:@"callback_url"]];
	[dictionary setObject:[NSNumber numberWithLong:expiresFromNow] forKey:[NSString stringWithFormat:@"expires"]];

	if ([user idIsSet] && [user id] != 0) {
		[dictionary setObject:[NSNumber numberWithLong:[user id]] forKey:[NSString stringWithFormat:@"user_id"]];
	} else if ([user usernameIsSet]) {
		[dictionary setObject:[user username] forKey:[NSString stringWithFormat:@"username"]];
	} else if ([user emailIsSet]) {
		[dictionary setObject:[user email] forKey:[NSString stringWithFormat:@"email"]];
	} else {
		[self throwErrorCode:OnesiteSessionResultCode_MISSING_USERNAME withMessage:@"Missing valid User identifier" errorCallback:errorCallback];
	}

	[self executeThriftMethodName:[NSString stringWithFormat:@"createCrossDomain"]
		    withResponseTBase:[ResponseString alloc]
		  withParamDictionary:dictionary
		       resultCallback:resultCallback
			errorCallback:errorCallback
	];
}

- (void)loginUser:(User*)user withPassword:(NSString*)password withAgent:(NSString*)agent withIp:(NSString*)ip withExpiresFromNow:(long)expiresFromNow resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
	NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];

	[dictionary setObject:ip forKey:[NSString stringWithFormat:@"ip"]];
	[dictionary setObject:agent forKey:[NSString stringWithFormat:@"agent"]];
	[dictionary setObject:[NSNumber numberWithLong:expiresFromNow] forKey:[NSString stringWithFormat:@"expires"]];

	if ([user idIsSet] && [user id] != 0) {
		[dictionary setObject:[NSNumber numberWithLong:[user id]] forKey:[NSString stringWithFormat:@"user_id"]];
	} else if ([user usernameIsSet]) {
		[dictionary setObject:[user username] forKey:[NSString stringWithFormat:@"username"]];
	} else if ([user emailIsSet]) {
		[dictionary setObject:[user email] forKey:[NSString stringWithFormat:@"email"]];
	} else {
		[self throwErrorCode:OnesiteSessionResultCode_MISSING_USERNAME withMessage:@"Missing valid User identifier" errorCallback:errorCallback];
	}

	if (password) {
		[dictionary setObject:password forKey:[NSString stringWithFormat:@"password"]];
	} else {
		[self throwErrorCode:OnesiteSessionResultCode_MISSING_PARAMETERS withMessage:@"No password provided" errorCallback:errorCallback];
	}

	[self executeThriftMethodName:[NSString stringWithFormat:@"login"]
		    withResponseTBase:[ResponseSession alloc]
		  withParamDictionary:dictionary
		       resultCallback:resultCallback
			errorCallback:errorCallback
	];
}

- (void)loginCrossDomainUser:(User*)user withPassword:(NSString*)password withCallbackUrl:(NSString*)callbackUrl withIp:(NSString*)ip withExpiresFromNow:(long)expiresFromNow resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
	NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];

	[dictionary setObject:ip forKey:[NSString stringWithFormat:@"ip"]];
	[dictionary setObject:callbackUrl forKey:[NSString stringWithFormat:@"callback_url"]];
	[dictionary setObject:[NSNumber numberWithLong:expiresFromNow] forKey:[NSString stringWithFormat:@"expires"]];

	if ([user idIsSet] && [user id] != 0) {
		[dictionary setObject:[NSNumber numberWithLong:[user id]] forKey:[NSString stringWithFormat:@"user_id"]];
	} else if ([user usernameIsSet]) {
		[dictionary setObject:[user username] forKey:[NSString stringWithFormat:@"username"]];
	} else if ([user emailIsSet]) {
		[dictionary setObject:[user email] forKey:[NSString stringWithFormat:@"email"]];
	} else {
		[self throwErrorCode:OnesiteSessionResultCode_MISSING_USERNAME withMessage:@"Missing valid User identifier" errorCallback:errorCallback];
	}

	if (password) {
		[dictionary setObject:password forKey:[NSString stringWithFormat:@"password"]];
	} else {
		[self throwErrorCode:OnesiteSessionResultCode_MISSING_PARAMETERS withMessage:@"No password provided" errorCallback:errorCallback];
	}

	[self executeThriftMethodName:[NSString stringWithFormat:@"loginCrossDomain"]
		    withResponseTBase:[ResponseString alloc]
		  withParamDictionary:dictionary
		       resultCallback:resultCallback
			errorCallback:errorCallback
	];
}

- (void)logoutSession:(Session*)session resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
	NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];

	if ([session coreUIsSet]) {
		[dictionary setObject:[session coreU] forKey:[NSString stringWithFormat:@"core_u"]];
	} else if ([session accessTokenIsSet]) {
		[dictionary setObject:[session accessToken] forKey:[NSString stringWithFormat:@"access_token"]];
	} else if ([session userIsSet]) {
        User* user = [session user];
        
        if ([user idIsSet] && [user id] != 0) {
            [dictionary setObject:[NSNumber numberWithLong:[user id]] forKey:[NSString stringWithFormat:@"user_id"]];
        } else if ([user usernameIsSet]) {
            [dictionary setObject:[user username] forKey:[NSString stringWithFormat:@"username"]];
        } else if ([user emailIsSet]) {
            [dictionary setObject:[user email] forKey:[NSString stringWithFormat:@"email"]];
        } else {
            [self throwErrorCode:OnesiteSessionResultCode_MISSING_PARAMETERS withMessage:@"Insufficient session data to logout" errorCallback:errorCallback];
        }
    } else {
        [self throwErrorCode:OnesiteSessionResultCode_MISSING_PARAMETERS withMessage:@"Insufficient session data to logout" errorCallback:errorCallback];
    }

	[self executeThriftMethodName:[NSString stringWithFormat:@"logout"]
		    withResponseTBase:[ResponseString alloc]
		  withParamDictionary:dictionary
		       resultCallback:resultCallback
			errorCallback:errorCallback
	];
}

- (void)checkSession:(Session*)session resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
	NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];

	if ([session accessTokenIsSet]) {
		[dictionary setObject:[session accessToken] forKey:[NSString stringWithFormat:@"access_token"]];
	} else {
		[dictionary setObject:[session coreU] forKey:[NSString stringWithFormat:@"core_u"]];
		[dictionary setObject:[session coreX] forKey:[NSString stringWithFormat:@"core_x"]];
	}

	[dictionary setObject:[session ip] forKey:[NSString stringWithFormat:@"ip"]];
	[dictionary setObject:[session agent] forKey:[NSString stringWithFormat:@"agent"]];

	[self executeThriftMethodName:[NSString stringWithFormat:@"check"]
		    withResponseTBase:[ResponseSession alloc]
		  withParamDictionary:dictionary
		       resultCallback:resultCallback
			errorCallback:errorCallback
	];
}

- (void)joinCrossDomainCallbackUrl:(NSString*)callbackUrl withDomain:(NSString*)domain withIp:(NSString*)ip withAgent:(NSString*)agent resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
	NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];

	[dictionary setObject:callbackUrl forKey:[NSString stringWithFormat:@"callback_url"]];
	[dictionary setObject:domain forKey:[NSString stringWithFormat:@"domain"]];
	[dictionary setObject:ip forKey:[NSString stringWithFormat:@"ip"]];
	[dictionary setObject:agent forKey:[NSString stringWithFormat:@"agent"]];

	[self executeThriftMethodName:[NSString stringWithFormat:@"joinCrossDomain"]
		    withResponseTBase:[ResponseString alloc]
		  withParamDictionary:dictionary
		       resultCallback:resultCallback
			errorCallback:errorCallback
	];
}

@end

