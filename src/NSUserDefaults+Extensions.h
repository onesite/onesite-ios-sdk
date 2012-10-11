//
//  NSUserDefaultsExtension.h
//  sso
//
//  Created by Jake Farrell on 1/17/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Extensions)

// ONESite Accounts
+ (BOOL)isOnesiteAccountEnabled:(NSNumber*)nodeId;
+ (void)removeOnesiteAccount:(NSNumber*)nodeId;
+ (void)addOnesiteAccount:(NSNumber*)nodeId uid:(NSNumber*)uid accessToken:(NSString*)accessToken;
+ (NSDictionary*)getOnesiteAccount:(NSNumber*)nodeId;
+ (NSString*)getOnesiteAccessToken;

// Facebook
+ (NSString*)getFacebookAccessToken;
+ (NSDate*)getFacebookExpirationDate;

+ (BOOL)isFacebookLoggedIn;
+ (void)setFacebookDefaults:(NSString*)accessToken expDate:(NSDate*)expDate;
+ (void)resetFacebookDefaults;

// Twitter
+ (NSString*)twitterOAuthAccessKey;
+ (NSString*)twitterOAuthAccessSecret;
+ (NSString*)twitterID;
+ (NSString*)twitterUsername;
+ (NSString*)twitterOAuthAccessResponse;

+ (BOOL)isTwitterLoggedIn;
+ (void)setTwitterDefaults:(NSString*)accessKey secret:(NSString*)accessSecret resp:(NSString*)resp uid:(NSString*)uid username:(NSString*)name;
+ (void)setTwitterDefaultsWithResponse:(NSString*)resp;
+ (void)resetTwitterDefaults;

// Global
+ (void) resetDefaults;
+ (NSMutableDictionary*) getDictionaryWithKey:(NSString*)key;
+ (void) saveDictionaryWithKey:(NSString*)key dict:(NSDictionary*)dict;

@end