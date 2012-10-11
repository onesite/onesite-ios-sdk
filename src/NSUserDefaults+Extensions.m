//
//  NSUserDefaultsExtension.m
//  sso
//
//  Created by Jake Farrell on 1/17/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "NSUserDefaults+Extensions.h"
#import "NSString+Extensions.h"
#import "FacebookWrapper.h"
#import "Configuration.h"

#define defaults (NSUserDefaults *)[NSUserDefaults standardUserDefaults]

// ONEsite accounts
#define kDefaultsONESiteAccounts					@"kDefaultsONESiteAccounts"					// NSDictionary { nodeId : {name, accessToken} }

// Facebook account
#define kDefaultsFacebookAccessToken				@"kDefaultsFacebookAccessToken"				// NSString
#define kDefaultsFacebookExpirationDate				@"kDefaultsFacebookExpirationDate"			// NSDate

// Twitter account
#define kDefaultsTwitterOAuthAccessKey				@"kDefaultsTwitterOAuthAccessKey"			// NSString
#define kDefaultsTwitterOAuthAccessSecret			@"kDefaultsTwitterOAuthAccessSecret"		// NSString
#define kDefaultsTwitterOAuthAccessResponse			@"kDefaultsTwitterOAuthAccessResponse"		// NSString
#define kDefaultsTwitterID							@"kDefaultsTwitterID"						// NSNumber
#define kDefaultsTwitterUsername					@"kDefaultsTwitterUsername"					// NSString

@implementation NSUserDefaults (Extensions)

#pragma mark - ONESite accounts

+ (void)addOnesiteAccount:(NSNumber*)nodeId uid:(NSNumber*)uid accessToken:(NSString*)accessToken
{
	NSMutableDictionary* dict = [self getDictionaryWithKey:kDefaultsONESiteAccounts];
	
	if (dict == nil) {
		dict = [[NSMutableDictionary alloc] init];
	}
	
	NSMutableDictionary *account = [dict objectForKey:[nodeId stringValue]];
	
	if (account == nil) {
		account = [[NSMutableDictionary alloc] init];
	}
	
	[account setValue:uid forKey:@"userId"];
	[account setValue:accessToken forKey:@"accessToken"];
	
	[dict setValue:account forKey:[nodeId stringValue]];
	
	[self saveDictionaryWithKey:kDefaultsONESiteAccounts dict:dict];
}

+ (NSDictionary*)getOnesiteAccount:(NSNumber*)nodeId
{
    NSMutableDictionary* dict = [self getDictionaryWithKey:kDefaultsONESiteAccounts];
	
	if (dict != nil) {
        if ([dict objectForKey:[nodeId stringValue]]) {
            return [dict objectForKey:[nodeId stringValue]];
        }
	}
    
    return nil;
}

+ (void)removeOnesiteAccount:(NSNumber*)nodeId
{
	NSMutableDictionary* dict = [self getDictionaryWithKey:kDefaultsONESiteAccounts];
	
	if (dict != nil) {
		[dict removeObjectForKey:[nodeId stringValue]];
	}
	
	[self saveDictionaryWithKey:kDefaultsONESiteAccounts dict:dict];
}

+ (BOOL)isOnesiteAccountEnabled:(NSNumber*)nodeId
{
	NSMutableDictionary* dict = [self getDictionaryWithKey:kDefaultsONESiteAccounts];
	
	if (dict != nil) {
		if ([dict objectForKey:[nodeId stringValue]]) {
			DELOG(@"Found nodeId");
			return YES;
		}
	}
	
	return NO;
}

+ (NSString*)getOnesiteAccessToken
{
    NSNumber *nodeId = [NSNumber numberWithInt:[[[Configuration getInstance] valueForKeyPath:@"Onesite.OnesiteNodeId"] intValue]];
    
    NSDictionary *account = [self getOnesiteAccount:nodeId];
    if (account != nil && [account objectForKey:@"accessToken"]) {
        return [account objectForKey:@"accessToken"];
    }
    
    return nil;
}

#pragma mark - Facebook

+ (NSString*)getFacebookAccessToken
{
	return [defaults objectForKey:kDefaultsFacebookAccessToken];
}

+ (NSDate*) getFacebookExpirationDate
{
	return (NSDate*)[defaults objectForKey:kDefaultsFacebookExpirationDate];
}

+ (BOOL)isFacebookLoggedIn
{
	return [[FacebookWrapper getInstance] isLoggedIn];
}

+ (void)setFacebookDefaults:(NSString*)accessToken expDate:(NSDate*)expDate
{
	if ((accessToken != nil) && (expDate != nil)) {
		DELOG(@"Saving Facebook defaults");
		[defaults setObject:accessToken forKey:kDefaultsFacebookAccessToken];
		[defaults setObject:expDate forKey:kDefaultsFacebookExpirationDate];
		[defaults synchronize];
	}	
}

+ (void)resetFacebookDefaults
{
	NSArray *savedValues = [NSArray arrayWithObjects:kDefaultsFacebookAccessToken,
							kDefaultsFacebookExpirationDate,
							nil];
	
	for (id key in savedValues) {
		[defaults removeObjectForKey:key];
	}
	
	[defaults synchronize];
}


#pragma mark - Twitter

+ (NSString*)twitterOAuthAccessKey
{
	return [defaults objectForKey:kDefaultsTwitterOAuthAccessKey];
}

+ (NSString*)twitterOAuthAccessSecret
{
	return [defaults objectForKey:kDefaultsTwitterOAuthAccessSecret];
}

+ (NSString*)twitterID
{
	return [defaults objectForKey:kDefaultsTwitterID];
}

+ (NSString*)twitterUsername
{
	return [defaults objectForKey:kDefaultsTwitterUsername];
}

+ (NSString*)twitterOAuthAccessResponse
{
	return [defaults objectForKey:kDefaultsTwitterOAuthAccessResponse];
}

+ (BOOL)isTwitterLoggedIn
{
	if (([defaults objectForKey:kDefaultsTwitterOAuthAccessKey] != nil) && ([defaults objectForKey:kDefaultsTwitterOAuthAccessSecret] != nil)){
		return YES;
	}
	
	return NO;
}

+ (void)setTwitterDefaults:(NSString*)accessKey secret:(NSString*)accessSecret resp:(NSString*)resp uid:(NSString*)uid username:(NSString*)name
{
	if ((accessKey != nil) && (accessSecret != nil) && (resp != nil)) {
		[defaults setObject:uid forKey:kDefaultsTwitterID];
		[defaults setObject:name forKey:kDefaultsTwitterUsername];
		[defaults setObject:accessKey forKey:kDefaultsTwitterOAuthAccessKey];
		[defaults setObject:accessSecret forKey:kDefaultsTwitterOAuthAccessSecret];
		[defaults setObject:resp forKey:kDefaultsTwitterOAuthAccessResponse];
		[defaults synchronize];
	}	
}

+ (void)setTwitterDefaultsWithResponse:(NSString*)resp
{
    NSString *accessKey, *accessSecret, *uid, *username;
    
    NSArray *nvps = [[resp urlDecode] componentsSeparatedByString:@"&"];
    for (NSString *component in nvps) {
        NSArray *nvp = [component componentsSeparatedByString:@"="];
        if ([[nvp objectAtIndex:0] isEqualToString:@"oauth_token"]) {
            accessKey = [nvp objectAtIndex:1];
        } else if ([[nvp objectAtIndex:0] isEqualToString:@"oauth_token_secret"]) {
            accessSecret = [nvp objectAtIndex:1];
        } else if ([[nvp objectAtIndex:0] isEqualToString:@"user_id"]) {
            uid = [nvp objectAtIndex:1];
        } else if ([[nvp objectAtIndex:0] isEqualToString:@"screen_name"]) {
            username = [nvp objectAtIndex:1];
        }
    }
    
    [self setTwitterDefaults:accessKey secret:accessSecret resp:resp uid:uid username:username];
}

+ (void)resetTwitterDefaults
{
	NSArray *savedValues = [NSArray arrayWithObjects:kDefaultsTwitterID,
							kDefaultsTwitterUsername,
							kDefaultsTwitterOAuthAccessKey,
							kDefaultsTwitterOAuthAccessSecret,
							kDefaultsTwitterOAuthAccessResponse,
							nil];
	
	for (id key in savedValues) {
		[defaults removeObjectForKey:key];
	}
	
	[defaults synchronize];
}

#pragma mark - Global

+ (void)resetDefaults
{
	[self resetFacebookDefaults];
	[self resetTwitterDefaults];
	
	// Reset any other defaults user may have set
	NSArray *savedValues = [NSArray arrayWithObjects:kDefaultsONESiteAccounts,
							nil];
	
	for (id key in savedValues) {
		[defaults removeObjectForKey:key];
	}
	
	[defaults synchronize];
	
}

+ (void)saveDictionaryWithKey:(NSString*)key dict:(NSMutableDictionary*)dict
{
	DELOG(@"Saving key %@ with %d items", key, [dict count]);
	[defaults setObject:dict forKey:key];
	[defaults synchronize];	
}

+ (NSMutableDictionary*)getDictionaryWithKey:(NSString*)key
{
	if ([defaults dictionaryForKey:key]) {
		DELOG(@"Found Dict for key %@ with %d items", key, [[defaults dictionaryForKey:key] count]);
		
		return [[NSMutableDictionary alloc] initWithDictionary:[defaults dictionaryForKey:key]];
	}
	
	return nil;
}

@end

