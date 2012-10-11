//
//  FacebookWrapper.m
//  sso
//
//  Created by Jake Farrell on 1/17/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "FacebookWrapper.h"
#import "FBConnect.h"
#import "Configuration.h"
#import "NSUserDefaults+Extensions.h"

static FacebookWrapper *_instance = nil;

@implementation FacebookWrapper
@synthesize facebook;

+ (id)getInstance
{	
	if (!_instance)
		_instance = [[FacebookWrapper alloc] init];
	
	return _instance;
}

- (id)init
{
	self = [super init];
    if (self) {
		NSString *appId = [[Configuration getInstance] valueForKeyPath:@"Facebook.FacebookAppId"];
		
		facebook = [[Facebook alloc] initWithAppId:appId andDelegate:self];
		
		// Check to see if there are any values stored in NSUserDefaults
		if (([NSUserDefaults getFacebookAccessToken] != nil) && ([NSUserDefaults getFacebookExpirationDate] != nil)) { 
			[facebook setAccessToken:[NSUserDefaults getFacebookAccessToken]];
			[facebook setExpirationDate:[NSUserDefaults getFacebookExpirationDate]];
		}
	}
	
	return self;
}

- (void)login:(id<FBSessionDelegate>)delegate
{
	DELOG(@"FB login");
	
	[facebook setSessionDelegate:(delegate != nil) ? delegate : self];
	
	// Check to see if there are any values stored in NSUserDefaults
	if (([NSUserDefaults getFacebookAccessToken] != nil) && ([NSUserDefaults getFacebookExpirationDate] != nil)) { 
		[facebook setAccessToken:[NSUserDefaults getFacebookAccessToken]];
		[facebook setExpirationDate:[NSUserDefaults getFacebookExpirationDate]];
	}
	
	// Verify the user's logged in status
	if (![self isLoggedIn]) {
		NSArray *appPermissions = [[Configuration getInstance] valueForKeyPath:@"Facebook.FacebookAppPermissions"];
		[facebook authorize:appPermissions];
	} else {
		// Already logged in
		DELOG(@"Facebook Access token: %@\nFacebook expDate: %@", facebook.accessToken, facebook.expirationDate);
	}
}

- (void)logout:(id<FBSessionDelegate>)delegate 
{
	DELOG(@"FB logout");
	[facebook setSessionDelegate:(delegate != nil) ? delegate : self];
	[facebook logout];
}

- (BOOL)isLoggedIn
{
	return [facebook isSessionValid];
}

- (void)requestGraphPath:(NSString*)path delegate:(id)delegate 
{
	DELOG(@"FB requestWithGraphPath %@", path);
	if (path != nil) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		[facebook requestWithGraphPath:path andDelegate:(delegate !=nil) ? delegate : self];
	}
}

#pragma mark - Facebook Session Delegate

- (void)fbDidLogin
{
	DELOG(@"fbDidLogin");
	[NSUserDefaults setFacebookDefaults:facebook.accessToken expDate:facebook.expirationDate];
    // [facebook requestWithGraphPath:@"me" andParams:nil andDelegate:self];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
	DELOG(@"fbDidNotLogin");
	[NSUserDefaults resetFacebookDefaults];
}

- (void)fbDidLogout
{
	DELOG(@"fbDidLogout");
	[NSUserDefaults resetFacebookDefaults];
}

#pragma mark - Facebook Request Delegate

- (void)request:(FBRequest *)request didLoad:(id)result 
{
	DELOG(@"FB Request didLoad");
	
	/* Grab info from the 'me' graph request 
	 if ([result isKindOfClass:[NSDictionary class]]) {
	 NSDictionary* dict = result;		
	 NSNumber* uid = [[dict valueForKey:@"id"] intValue];
	 NSString *email = (NSString*)[dict valueForKey:@"email"];
	 NSString *first_name = (NSString*)[dict valueForKey:@"first_name"];
	 NSString *last_name = (NSString*)[dict valueForKey:@"last_name"];
	 NSString *display_name = (NSString*)[dict valueForKey:@"first_name"];
	 NSString *birthday = (NSString*)[dict valueForKey:@"birthday"];
	 NSString *avatar = [NSString stringWithFormat:@"https://graph.facebook.com/%d/picture?type=large", uid];
	 }
	 */
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error 
{
	DELOG(@"FB Request Error %@", error);
}

#pragma mark - Memory

- (void) dealloc 
{
	[facebook release], facebook = nil;	
	[super dealloc];
}

@end
