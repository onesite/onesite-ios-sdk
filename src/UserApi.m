#import "UserApi.h"
#import "Onesite.h"
#import "NSError+Extensions.h"

static UserApi *_instance = nil;

@interface UserApi (hidden)
  - (NSMutableDictionary*)generateDictionaryFromUser:(User*)user;
  - (NSMutableDictionary*)generateCreateDictionaryFromUser:(User*)user withPassword:(Password*)password withUserCreateOptions:(UserCreateOptions*)options withSessionOptions:(SessionOptions*)sessionOptions errorCallback:(BaseAPICallbackFailureBlock)errorCallback;
@end

@implementation UserApi (hidden)

- (NSMutableDictionary*)generateDictionaryFromUser:(User*)user
{
    NSMutableDictionary* dictionary;
    dictionary = [[NSMutableDictionary alloc] init];

    if ([user usernameIsSet]) {
        [dictionary setObject:[user username] forKey:[NSString stringWithFormat:@"username"]];
    }

    if ([user displayNameIsSet]) {
        [dictionary setObject:[user displayName] forKey:[NSString stringWithFormat:@"display_name"]];
    }

    if ([user accountStatusIsSet]) {
        [dictionary setObject:[Onesite stringFromAccountStatus:[user accountStatus]] forKey:[NSString stringWithFormat:@"account_status"]];
    }

    if ([user avatarIsSet]) {
        [dictionary setObject:[user avatar] forKey:[NSString stringWithFormat:@"avatar"]];
    }

    if ([user profileIsSet]) {
        Profile* profile = [user profile];

        if ([profile birthdayIsSet]) {
            [dictionary setObject:[NSNumber numberWithLong:[profile birthday]] forKey:[NSString stringWithFormat:@"birthday"]];
        }

        if ([profile firstNameIsSet]) {
            [dictionary setObject:[profile firstName] forKey:[NSString stringWithFormat:@"first_name"]];
        }

        if ([profile lastNameIsSet]) {
            [dictionary setObject:[profile lastName] forKey:[NSString stringWithFormat:@"last_name"]];
        }

        if ([profile genderIsSet]) {
            [dictionary setObject:[Onesite stringFromGender:[profile gender]] forKey:[NSString stringWithFormat:@"gender"]];
        }

        if ([profile addressIsSet]) {
            [dictionary setObject:[profile address] forKey:[NSString stringWithFormat:@"address"]];
        }

        if ([profile address2IsSet]) {
            [dictionary setObject:[profile address2] forKey:[NSString stringWithFormat:@"address2"]];
        }

        if ([profile cityIsSet]) {
            [dictionary setObject:[profile city] forKey:[NSString stringWithFormat:@"city"]];
        }

        if ([profile stateIsSet]) {
            [dictionary setObject:[profile state] forKey:[NSString stringWithFormat:@"state"]];
        }

        if ([profile zipIsSet]) {
            [dictionary setObject:[profile zip] forKey:[NSString stringWithFormat:@"zip"]];
        }

        if ([profile countryIsSet]) {
            [dictionary setObject:[profile country] forKey:[NSString stringWithFormat:@"country"]];
        }

        if ([profile locationIsSet]) {
            [dictionary setObject:[profile location] forKey:[NSString stringWithFormat:@"location"]];
        }

        if ([profile phoneIsSet]) {
            [dictionary setObject:[profile phone] forKey:[NSString stringWithFormat:@"phone"]];
        }

        if ([profile quoteIsSet]) {
            [dictionary setObject:[profile quote] forKey:[NSString stringWithFormat:@"quote"]];
        }

        if ([profile localeIsSet]) {
            [dictionary setObject:[profile locale] forKey:[NSString stringWithFormat:@"locale"]];
        }

        if ([profile timezoneIsSet]) {
            [dictionary setObject:[NSNumber numberWithLong:[profile timezone]] forKey:[NSString stringWithFormat:@"timezone"]];
        }
    }

    if ([user preferencesIsSet]) {
        Preferences* preferences = [user preferences];

        if ([preferences birthdayDisplayIsSet]) {
            [dictionary setObject:[Onesite stringFromBirthdayDisplay:[preferences birthdayDisplay]] forKey:[NSString stringWithFormat:@"birthday_display"]];
        }

        if ([preferences friendshipApprovalIsSet]) {
            [dictionary setObject:[Onesite stringFromFriendshipApproval:[preferences friendshipApproval]] forKey:[NSString stringWithFormat:@"friends_approval"]];
        }

        if ([preferences commentsApprovalIsSet]) {
            [dictionary setObject:[Onesite stringFromCommentsApproval:[preferences commentsApproval]] forKey:[NSString stringWithFormat:@"comments_approval"]];
        }

        if ([preferences messagePrivacyIsSet]) {
            [dictionary setObject:[Onesite stringFromMessagePrivacy:[preferences messagePrivacy]] forKey:[NSString stringWithFormat:@"message_privacy"]];
        }

        if ([preferences emailNotificationIsSet]) {
            [dictionary setObject:[Onesite stringFromEmailNotification:[preferences emailNotification]] forKey:[NSString stringWithFormat:@"email_notification"]];
        }

        if ([preferences searchableIsSet]) {
            [dictionary setObject:[NSNumber numberWithBool:[preferences searchable]] forKey:[NSString stringWithFormat:@"searchable"]];
        }

        if ([preferences showOnlineStatusIsSet]) {
            [dictionary setObject:[NSNumber numberWithBool:[preferences showOnlineStatus]] forKey:[NSString stringWithFormat:@"show_online_status"]];
        }
    }

    return dictionary;
}

- (NSMutableDictionary*)generateCreateDictionaryFromUser:(User*)user withPassword:(Password*)password withUserCreateOptions:(UserCreateOptions*)options withSessionOptions:(SessionOptions*)sessionOptions errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [self generateDictionaryFromUser:user];

    if ([user emailIsSet]) {
        [dictionary setObject:[user email] forKey:[NSString stringWithFormat:@"email"]];
    } else if (!([user externalAccountsIsSet] && [[user externalAccounts] count] > 0)) {
        [self throwErrorCode:OnesiteUserResultCode_MISSING_PARAMETERS withMessage:@"Missing User email address" errorCallback:errorCallback];
    }

    if ([user siteIsSet]) {
        if ([[user site] subdirIsSet]) {
            [dictionary setObject:[[user site] subdir] forKey:[NSString stringWithFormat:@"subdir"]];
        }
    }

    if ([user externalAccountsIsSet] && [[user externalAccounts] count] > 0) {
        ExternalAccount* account = [[user externalAccounts] objectAtIndex:0];
        [dictionary setObject:[account providerName] forKey:[NSString stringWithFormat:@"external_provider_name"]];
        [dictionary setObject:[account userIdentifier] forKey:[NSString stringWithFormat:@"external_user_identifier"]];
        [dictionary setObject:[account accessToken] forKey:[NSString stringWithFormat:@"external_access_token"]];
    }

    if ([password passwordIsSet]) {
        [dictionary setObject:[password password] forKey:[NSString stringWithFormat:@"password"]];
    }

    if (options != NULL) {
        if ([options couponCodeIsSet]) {
            [dictionary setObject:[options couponCode] forKey:[NSString stringWithFormat:@"coupon_code"]];
        }

        if ([options groupMemberStatusIsSet]) {
            [dictionary setObject:[Onesite stringFromGroupMemberStatus:[options groupMemberStatus]] forKey:[NSString stringWithFormat:@"group_member_status"]];
        }

        if ([options joinInitialGroupIsSet]) {
            [dictionary setObject:[NSNumber numberWithBool:[options joinInitialGroup]] forKey:[NSString stringWithFormat:@"join_group"]];
        }

        if ([options addInitialFriendIsSet]) {
            [dictionary setObject:[NSNumber numberWithBool:[options addInitialFriend]] forKey:[NSString stringWithFormat:@"add_friend"]];
        }

        if ([options referringUrlIsSet]) {
            [dictionary setObject:[options referringUrl] forKey:[NSString stringWithFormat:@"referring_url"]];
        }

        if ([options sendConfirmationEmailIsSet]) {
            [dictionary setObject:[NSNumber numberWithBool:[options sendConfirmationEmail]] forKey:[NSString stringWithFormat:@"send_confirmation_email"]];
        }
    }

    if (sessionOptions != NULL) {
        if ([sessionOptions useAccessTokenIsSet]) {
            [dictionary setObject:[NSNumber numberWithBool:[sessionOptions useAccessToken]] forKey:[NSString stringWithFormat:@"use_access_token"]];
        }
    }

    return dictionary;
}

@end

@implementation UserApi : BaseApi

+ (id)getInstance
{
    if (!_instance) {
        _instance = [[UserApi alloc] init];
    }
    return _instance;
}

- (id)init
{
    self = [super initWithAPIName:@"1/user"];
    if (self) {
    }
    return self;
}

- (void)createUser:(User*)user withPassword:(Password*)password withUserCreateOptions:(UserCreateOptions*)options resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [self generateCreateDictionaryFromUser:user withPassword:password withUserCreateOptions:options withSessionOptions:NULL errorCallback:errorCallback];

    NSArray* externalAccounts = [[NSArray alloc] initWithArray:[user externalAccounts]];

    [self executeThriftMethodName:[NSString stringWithFormat:@"create"]
                withResponseTBase:[ResponseUser alloc]
              withParamDictionary:dictionary
                   resultCallback:^(TBase *responseObject) {
                       // Add any additional external accounts that were not passed at sign up.
                       if ([externalAccounts count] > 1) {
                           User *newUser = [(ResponseUser*)responseObject user];
                           NSMutableArray *addedAccounts = [[NSMutableArray alloc] initWithObjects:[externalAccounts objectAtIndex:0], nil];
                           for (int i = 1; i < [externalAccounts count]; i++) {
                               [self addExternalAccount:[externalAccounts objectAtIndex:i]
                                                 toUser:newUser
                                         resultCallback:^(TBase *responseObject) {
                                             if ([[(ResponseBoolean*)responseObject status] code] == 100) {
                                                 [addedAccounts addObject:[externalAccounts objectAtIndex:i]];
                                             }
                                         }
                                          errorCallback:nil
                                ];
                           }
                           
                           if ([addedAccounts count] > 0) {
                               [newUser setExternalAccounts:addedAccounts];
                           }
                           
                           [(ResponseUser*)responseObject setUser:newUser];
                       }
                       
                       if (resultCallback) {
                           resultCallback(responseObject);
                       }
                   }
                    errorCallback:errorCallback
     ];
}

- (void)createSessionUser:(User*)user withPassword:(Password*)password withUserCreateOptions:(UserCreateOptions*)options withSessionOptions:(SessionOptions*)sessionOptions resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [self generateCreateDictionaryFromUser:user withPassword:password withUserCreateOptions:options withSessionOptions:sessionOptions errorCallback:errorCallback];

    NSArray* externalAccounts = [[NSArray alloc] initWithArray:[user externalAccounts]];

    [self executeThriftMethodName:[NSString stringWithFormat:@"createWithSession"]
                withResponseTBase:[ResponseSession alloc]
              withParamDictionary:dictionary
                   resultCallback:^(TBase *responseObject) {
                       // Add any additional external accounts that were not passed at sign up.
                       if ([externalAccounts count] > 1) {
                           Session *newSession = [(ResponseSession*)responseObject session];
                           
                           NSMutableArray *addedAccounts = [[NSMutableArray alloc] initWithObjects:[externalAccounts objectAtIndex:0], nil];
                           for (int i = 1; i < [externalAccounts count]; i++) {
                               [self addExternalAccount:[externalAccounts objectAtIndex:i]
                                                 toUser:[newSession user]
                                         resultCallback:^(TBase *responseObject) {
                                             if ([[(ResponseBoolean*)responseObject status] code] == 100) {
                                                 [addedAccounts addObject:[externalAccounts objectAtIndex:i]];
                                             }
                                         }
                                          errorCallback:nil
                                ];
                           }
                           
                           if ([addedAccounts count] > 0) {
                               [[newSession user] setExternalAccounts:addedAccounts];
                           }
                           
                           [(ResponseSession*)responseObject setSession:newSession];
                       }
                       
                       if (resultCallback) {
                           resultCallback(responseObject);
                       }
                   }
                    errorCallback:errorCallback
     ];
}

- (void)deleteUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    if ([user idIsSet] && [user id] > 0)  {
        [dictionary setObject:[NSNumber numberWithLong:[user id]] forKey:[NSString stringWithFormat:@"user_id"]];
    } else if ([user usernameIsSet]) {
        [dictionary setObject:[user username] forKey:[NSString stringWithFormat:@"username"]];
    } else if ([user emailIsSet]) {
        [dictionary setObject:[user email] forKey:[NSString stringWithFormat:@"email"]];
    } else if ([self accessToken] == nil) {
        [self throwErrorCode:OnesiteUserResultCode_MISSING_USERNAME withMessage:@"Missing valid User identifier" errorCallback:errorCallback];
    }

    [self executeThriftMethodName:[NSString stringWithFormat:@"delete"]
                withResponseTBase:[ResponseBoolean alloc]
              withParamDictionary:dictionary
                   resultCallback:resultCallback
                    errorCallback:errorCallback
     ];
}

- (void)updateUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [self generateDictionaryFromUser:user];
    if ([user idIsSet] && [user id] > 0)  {
        [dictionary setObject:[NSNumber numberWithLong:[user id]] forKey:[NSString stringWithFormat:@"user_id"]];
    } else if ([user usernameIsSet]) {
        [dictionary setObject:[user username] forKey:[NSString stringWithFormat:@"username"]];
    } else if ([user emailIsSet]) {
        [dictionary setObject:[user email] forKey:[NSString stringWithFormat:@"email"]];
    } else if ([self accessToken] == nil) {
        [self throwErrorCode:OnesiteUserResultCode_MISSING_USERNAME withMessage:@"Missing valid User identifier" errorCallback:errorCallback];
    }

    [self executeThriftMethodName:[NSString stringWithFormat:@"update"]
                withResponseTBase:[ResponseUser alloc]
              withParamDictionary:dictionary
                   resultCallback:resultCallback
                    errorCallback:errorCallback
     ];
}

- (void)getDetailsOfUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [self generateDictionaryFromUser:user];
    if ([user idIsSet] && [user id] > 0)  {
        [dictionary setObject:[NSNumber numberWithLong:[user id]] forKey:[NSString stringWithFormat:@"user_id"]];
    } else if ([user usernameIsSet]) {
        [dictionary setObject:[user username] forKey:[NSString stringWithFormat:@"username"]];
    } else if ([user emailIsSet]) {
        [dictionary setObject:[user email] forKey:[NSString stringWithFormat:@"email"]];
    } else if ([self accessToken] == nil) {
        [self throwErrorCode:OnesiteUserResultCode_MISSING_USERNAME withMessage:@"Missing valid User identifier" errorCallback:errorCallback];
    }

    [self executeThriftMethodName:[NSString stringWithFormat:@"getDetails"]
              withResponseTBase:[ResponseUser alloc]
            withParamDictionary:dictionary
                 resultCallback:resultCallback
                    errorCallback:errorCallback
     ];
}

- (void)isAvailableUsername:(NSString*)username resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:username forKey:[NSString stringWithFormat:@"username"]];

    [self executeThriftMethodName:[NSString stringWithFormat:@"isUsernameTaken"]
                withResponseTBase:[ResponseBoolean alloc]
              withParamDictionary:dictionary
                   resultCallback:resultCallback
                    errorCallback:^(NSError* error) {
			    if ([error code] == OnesiteUserResultCode_USERNAME_TAKEN) {
                    ResponseBoolean* responseObject = [[ResponseBoolean alloc] init];
                    [responseObject setContent:false];
				    resultCallback(responseObject);
			    } else {
				    errorCallback(error);
			    }
		    }
     ];
}

- (void)isAvailableEmail:(NSString*)email resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:email forKey:[NSString stringWithFormat:@"email"]];

    [self executeThriftMethodName:[NSString stringWithFormat:@"isEmailTaken"]
                withResponseTBase:[ResponseBoolean alloc]
              withParamDictionary:dictionary
                   resultCallback:resultCallback
                    errorCallback:^(NSError* error) {
			    if ([error code] == OnesiteUserResultCode_EMAIL_TAKEN) {
				    ResponseBoolean* responseObject = [[ResponseBoolean alloc] init];
                    [responseObject setContent:false];
				    resultCallback(responseObject);
			    } else {
				    errorCallback(error);
			    }
		    }
     ];
}

- (void)isAvailableSubdir:(NSString*)subdir resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:subdir forKey:[NSString stringWithFormat:@"subdir"]];

    [self executeThriftMethodName:[NSString stringWithFormat:@"isSubdirTaken"]
                withResponseTBase:[ResponseBoolean alloc]
              withParamDictionary:dictionary
                   resultCallback:resultCallback
                    errorCallback:^(NSError* error) {
			    if ([error code] == OnesiteUserResultCode_SUBDIR_TAKEN) {
				    ResponseBoolean* responseObject = [[ResponseBoolean alloc] init];
                    [responseObject setContent:false];
				    resultCallback(responseObject);
			    } else {
				    errorCallback(error);
			    }
		    }
     ];
}

- (void)isAvailableExternalAccount:(ExternalAccount*)account resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[account providerName] forKey:[NSString stringWithFormat:@"external_provider_name"]];
    [dictionary setObject:[account userIdentifier] forKey:[NSString stringWithFormat:@"external_user_identifier"]];

    [self executeThriftMethodName:[NSString stringWithFormat:@"isExternalAccountTaken"]
                withResponseTBase:[ResponseBoolean alloc]
              withParamDictionary:dictionary
                   resultCallback:resultCallback
                    errorCallback:^(NSError* error) {
			    if ([error code] == OnesiteUserResultCode_ACCOUNT_TAKEN) {
				    ResponseBoolean* responseObject = [[ResponseBoolean alloc] init];
                    [responseObject setContent:false];
				    resultCallback(responseObject);
			    } else {
				    errorCallback(error);
			    }
		    }
     ];
}

- (void)addExternalAccount:(ExternalAccount*)account toUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [self generateDictionaryFromUser:user];
    if ([user idIsSet] && [user id] > 0)  {
        [dictionary setObject:[NSNumber numberWithLong:[user id]] forKey:[NSString stringWithFormat:@"user_id"]];
    } else if ([user usernameIsSet]) {
        [dictionary setObject:[user username] forKey:[NSString stringWithFormat:@"username"]];
    } else if ([user emailIsSet]) {
        [dictionary setObject:[user email] forKey:[NSString stringWithFormat:@"email"]];
    } else if ([self accessToken] == nil) {
        [self throwErrorCode:OnesiteUserResultCode_MISSING_USERNAME withMessage:@"Missing valid User identifier" errorCallback:errorCallback];
    }
    [dictionary setObject:[account providerName] forKey:[NSString stringWithFormat:@"external_provider_name"]];
    [dictionary setObject:[account userIdentifier] forKey:[NSString stringWithFormat:@"external_user_identifier"]];
    [dictionary setObject:[account accessToken] forKey:[NSString stringWithFormat:@"external_access_token"]];

    [self executeThriftMethodName:[NSString stringWithFormat:@"addExternalAccount"]
                withResponseTBase:[ResponseBoolean alloc]
              withParamDictionary:dictionary
                   resultCallback:resultCallback
                    errorCallback:errorCallback
     ];
}

- (void)updateExternalAccount:(ExternalAccount*)account forUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [self generateDictionaryFromUser:user];
    if ([user idIsSet] && [user id] > 0)  {
        [dictionary setObject:[NSNumber numberWithLong:[user id]] forKey:[NSString stringWithFormat:@"user_id"]];
    } else if ([user usernameIsSet]) {
        [dictionary setObject:[user username] forKey:[NSString stringWithFormat:@"username"]];
    } else if ([user emailIsSet]) {
        [dictionary setObject:[user email] forKey:[NSString stringWithFormat:@"email"]];
    } else if ([self accessToken] == nil) {
        [self throwErrorCode:OnesiteUserResultCode_MISSING_USERNAME withMessage:@"Missing valid User identifier" errorCallback:errorCallback];
    }
    [dictionary setObject:[account providerName] forKey:[NSString stringWithFormat:@"external_provider_name"]];
    [dictionary setObject:[account userIdentifier] forKey:[NSString stringWithFormat:@"external_user_identifier"]];
    [dictionary setObject:[account accessToken] forKey:[NSString stringWithFormat:@"external_access_token"]];

    [self executeThriftMethodName:[NSString stringWithFormat:@"updateExternalAccount"]
                withResponseTBase:[ResponseBoolean alloc]
              withParamDictionary:dictionary
                   resultCallback:resultCallback
                    errorCallback:errorCallback
     ];
}

- (void)deleteExternalAccount:(ExternalAccount*)account fromUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [self generateDictionaryFromUser:user];
    if ([user idIsSet] && [user id] > 0)  {
        [dictionary setObject:[NSNumber numberWithLong:[user id]] forKey:[NSString stringWithFormat:@"user_id"]];
    } else if ([user usernameIsSet]) {
        [dictionary setObject:[user username] forKey:[NSString stringWithFormat:@"username"]];
    } else if ([user emailIsSet]) {
        [dictionary setObject:[user email] forKey:[NSString stringWithFormat:@"email"]];
    } else if ([self accessToken] == nil) {
        [self throwErrorCode:OnesiteUserResultCode_MISSING_USERNAME withMessage:@"Missing valid User identifier" errorCallback:errorCallback];
    }
    [dictionary setObject:[account providerName] forKey:[NSString stringWithFormat:@"external_provider_name"]];

    [self executeThriftMethodName:[NSString stringWithFormat:@"deleteExternalAccount"]
                withResponseTBase:[ResponseBoolean alloc]
              withParamDictionary:dictionary
                   resultCallback:resultCallback
                    errorCallback:errorCallback
     ];
}

- (void)getExternalAccount:(ExternalAccount*)account fromUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [self generateDictionaryFromUser:user];
    if ([user idIsSet] && [user id] > 0)  {
        [dictionary setObject:[NSNumber numberWithLong:[user id]] forKey:[NSString stringWithFormat:@"user_id"]];
    } else if ([user usernameIsSet]) {
        [dictionary setObject:[user username] forKey:[NSString stringWithFormat:@"username"]];
    } else if ([user emailIsSet]) {
        [dictionary setObject:[user email] forKey:[NSString stringWithFormat:@"email"]];
    } else if ([self accessToken] == nil) {
        [self throwErrorCode:OnesiteUserResultCode_MISSING_USERNAME withMessage:@"Missing valid User identifier" errorCallback:errorCallback];
    }
    [dictionary setObject:[account providerName] forKey:[NSString stringWithFormat:@"external_provider_name"]];

    [self executeThriftMethodName:[NSString stringWithFormat:@"getExternalAccount"]
                withResponseTBase:[ResponseExternalAccount alloc]
              withParamDictionary:dictionary
                   resultCallback:resultCallback
                    errorCallback:errorCallback
     ];
}

- (void)addExternalProperty:(ExternalProperty*)property toUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [self generateDictionaryFromUser:user];
    if ([user idIsSet] && [user id] > 0)  {
        [dictionary setObject:[NSNumber numberWithLong:[user id]] forKey:[NSString stringWithFormat:@"user_id"]];
    } else if ([user usernameIsSet]) {
        [dictionary setObject:[user username] forKey:[NSString stringWithFormat:@"username"]];
    } else if ([user emailIsSet]) {
        [dictionary setObject:[user email] forKey:[NSString stringWithFormat:@"email"]];
    } else if ([self accessToken] == nil) {
        [self throwErrorCode:OnesiteUserResultCode_MISSING_USERNAME withMessage:@"Missing valid User identifier" errorCallback:errorCallback];
    }
    [dictionary setObject:[property name] forKey:[NSString stringWithFormat:@"name"]];
    [dictionary setObject:[property type] forKey:[NSString stringWithFormat:@"type"]];
    [dictionary setObject:[property value] forKey:[NSString stringWithFormat:@"value"]];

    [self executeThriftMethodName:[NSString stringWithFormat:@"addExternalProperty"]
                withResponseTBase:[ResponseBoolean alloc]
              withParamDictionary:dictionary
                   resultCallback:resultCallback
                    errorCallback:errorCallback
     ];
}

- (void)getExternalProperty:(ExternalProperty*)property fromUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [self generateDictionaryFromUser:user];
    if ([user idIsSet] && [user id] > 0)  {
        [dictionary setObject:[NSNumber numberWithLong:[user id]] forKey:[NSString stringWithFormat:@"user_id"]];
    } else if ([user usernameIsSet]) {
        [dictionary setObject:[user username] forKey:[NSString stringWithFormat:@"username"]];
    } else if ([user emailIsSet]) {
        [dictionary setObject:[user email] forKey:[NSString stringWithFormat:@"email"]];
    } else if ([self accessToken] == nil) {
        [self throwErrorCode:OnesiteUserResultCode_MISSING_USERNAME withMessage:@"Missing valid User identifier" errorCallback:errorCallback];
    }
    [dictionary setObject:[property name] forKey:[NSString stringWithFormat:@"name"]];
    [dictionary setObject:[property type] forKey:[NSString stringWithFormat:@"type"]];

    [self executeThriftMethodName:[NSString stringWithFormat:@"getExternalProperty"]
                withResponseTBase:[ResponseExternalProperty alloc]
              withParamDictionary:dictionary
                   resultCallback:resultCallback
                    errorCallback:errorCallback
     ];
}

- (void)deleteExternalProperty:(ExternalProperty*)property fromUser:(User*)user resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [self generateDictionaryFromUser:user];
    if ([user idIsSet] && [user id] > 0)  {
        [dictionary setObject:[NSNumber numberWithLong:[user id]] forKey:[NSString stringWithFormat:@"user_id"]];
    } else if ([user usernameIsSet]) {
        [dictionary setObject:[user username] forKey:[NSString stringWithFormat:@"username"]];
    } else if ([user emailIsSet]) {
        [dictionary setObject:[user email] forKey:[NSString stringWithFormat:@"email"]];
    } else if ([self accessToken] == nil) {
        [self throwErrorCode:OnesiteUserResultCode_MISSING_USERNAME withMessage:@"Missing valid User identifier" errorCallback:errorCallback];
    }
    [dictionary setObject:[property name] forKey:[NSString stringWithFormat:@"name"]];
    [dictionary setObject:[property type] forKey:[NSString stringWithFormat:@"type"]];

    [self executeThriftMethodName:[NSString stringWithFormat:@"deleteExternalProperty"]
                withResponseTBase:[ResponseBoolean alloc]
              withParamDictionary:dictionary
                   resultCallback:resultCallback
                    errorCallback:errorCallback
     ];
}

- (void)getUserByExternalProperty:(ExternalProperty*)property resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[property name] forKey:[NSString stringWithFormat:@"name"]];
    [dictionary setObject:[property type] forKey:[NSString stringWithFormat:@"type"]];
    [dictionary setObject:[property value] forKey:[NSString stringWithFormat:@"value"]];

    [self executeThriftMethodName:[NSString stringWithFormat:@"getUserByExternalProperty"]
                withResponseTBase:[ResponseUser alloc]
              withParamDictionary:dictionary
                   resultCallback:resultCallback
                    errorCallback:errorCallback
     ];
}

- (void)validateCredentialsForNodeId:(long)nodeID forUsername:(NSString*)username forPassword:(NSString*)password resultCallback:(BaseAPICallbackResultBlock)resultCallback errorCallback:(BaseAPICallbackFailureBlock)errorCallback
{
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[NSNumber numberWithLong:nodeID] forKey:[NSString stringWithFormat:@"nodeID"]];
    [dictionary setObject:username forKey:[NSString stringWithFormat:@"username"]];
    [dictionary setObject:password forKey:[NSString stringWithFormat:@"password"]];
    [dictionary setObject:[NSString stringWithFormat:@"1"] forKey:[NSString stringWithFormat:@"no_redir"]];

    [self executeThriftMethodName:[NSString stringWithFormat:@"validateCredentials"]
                withResponseTBase:[ResponseLong alloc]
              withParamDictionary:dictionary
                   resultCallback:resultCallback
                    errorCallback:errorCallback
     ];
}

@end

