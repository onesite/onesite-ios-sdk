//
//  OnesiteLoginDialog.m
//  sso
//
//  Created by Jake Farrell on 1/17/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "OnesiteLoginDialog.h"
#import "Configuration.h"
#import "OnesiteLoginDialog.h"
#import "LROAuth2Client.h"
#import "LROAuth2AccessToken.h"
#import "NSUserDefaults+Extensions.h"

@implementation OnesiteLoginDialog

@synthesize delegate = _delegate;
@synthesize webView;

- (void)setupWithOAuthSettings:(NSString*)clientId secret:(NSString*)secret callBackUrl:(NSString*)callBackUrl authorizeUrl:(NSString*)authorizeUrl accessUrl:(NSString*)accessUrl
{
   	NSString *redirectUrl = ([callBackUrl hasSuffix:@"/"] ? callBackUrl : [NSString stringWithFormat:@"%@/", callBackUrl]);
	
	DELOG(@"Auth URL:      %@", authorizeUrl);
	DELOG(@"Access URL:    %@", accessUrl);
	DELOG(@"Call Back URL: %@", redirectUrl);	
	
	oauthClient = [[LROAuth2Client alloc] initWithClientID:clientId
													secret:secret
											   redirectURL:[NSURL URLWithString:redirectUrl]];
    
	[oauthClient setDelegate:self];
	[oauthClient setDebug:YES];
	[oauthClient setUserURL:[NSURL URLWithString:authorizeUrl]];
	[oauthClient setTokenURL:[NSURL URLWithString:accessUrl]];
}


- (id)init
{
	self = [super initWithNibName:nil bundle:nil];
    if (self) {
		NSString *urlScheme = [[Configuration getInstance] valueForKeyPath:@"Onesite.OnesiteURLScheme"];
		NSString *domainUrl = [[Configuration getInstance] valueForKeyPath:@"Onesite.OnesiteDomain"];
		NSString *clientId = [[Configuration getInstance] valueForKeyPath:@"Onesite.OnesiteOAuthClientId"];
		NSString *secret = [[Configuration getInstance] valueForKeyPath:@"Onesite.OnesiteOAuthSecret"];
		
		NSString *callBackUrl = [NSString stringWithFormat:@"%@://%@", urlScheme, [[Configuration getInstance] valueForKeyPath:@"Onesite.OnesiteOAuthCallBackURL"]];
		NSString *authorizeUrl = [NSString stringWithFormat:@"%@://%@/go/oauth/authorize", urlScheme, domainUrl];
		NSString *accessUrl = [NSString stringWithFormat:@"%@://%@/go/oauth/accessToken", urlScheme, domainUrl];
		
		[self setupWithOAuthSettings:clientId secret:secret callBackUrl:callBackUrl authorizeUrl:authorizeUrl accessUrl:accessUrl];
	}
    return self;
}

- (id)initWithOAuthSettings:(NSString*)clientId secret:(NSString*)secret callBackUrl:(NSString*)callBackUrl authorizeUrl:(NSString*)authorizeUrl accessUrl:(NSString*)accessUrl
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
		[self setupWithOAuthSettings:clientId secret:secret callBackUrl:callBackUrl authorizeUrl:authorizeUrl accessUrl:accessUrl];
	}
    return self;
}

- (void)dealloc
{
	oauthClient.delegate = nil;
	webView.delegate = nil;
	
	[webView release];
	[oauthClient release];
	
	self.delegate = nil;
	[_delegate release];
	
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)loadView
{
	[super loadView];
	
	DELOG(@"Loading webView");
	[self setWebView:[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]];
	[self.webView setOpaque:NO];
	[self.webView setBackgroundColor:[UIColor whiteColor]];
	[self.webView setScalesPageToFit:YES];
	
	[self.view addSubview:self.webView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	DELOG(@"View Did Appear");
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init]; 
	[params setObject:@"touch" forKey:@"display"]; 
	[params setObject:@"1" forKey:@"no_session"]; 
	[params setValue:@"1" forKey:@"no_redir"];
	
	[oauthClient authorizeUsingWebView:self.webView additionalParameters:params];
}

#pragma mark -
#pragma mark <Webview Functions>

// Intercept page requests and when successfully authenticated start processing
- (BOOL) webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
  	DELOG(@"Request: %@", request);
	return YES;
}

#pragma mark - OAuth lifecycle

- (void)refreshAccessToken:(LROAuth2AccessToken *)accessToken
{
	[oauthClient refreshAccessToken:accessToken];
}

#pragma mark -
#pragma mark LROAuth2ClientDelegate methods

- (void)oauthClientDidReceiveAccessCode:(LROAuth2Client *)client
{
	DELOG(@"Received an Access Code");
    
	if ([client accessCode]) {
		NSMutableDictionary *params = [[NSMutableDictionary alloc] init]; 
		[params setObject:@"touch" forKey:@"display"]; 
		[params setObject:@"1" forKey:@"no_session"]; 
		[params setValue:@"1" forKey:@"no_redir"];
		
		[client verifyAuthorizationWithAccessCode:[client accessCode] parameters:params];
	}
}

- (void)oauthClientDidCancel:(LROAuth2Client *)client
{
	DELOG(@"Canceled OAuth Request");
	NSDictionary* dict = [self parseAccessToken:[client.accessToken accessToken]];
	
	if (dict != nil) {
		if ([dict objectForKey:@"nodeId"]) { 
			NSNumber *nodeId = [dict objectForKey:@"nodeId"];
			
			DELOG(@"nodeId: %@", [nodeId stringValue]);
			
			if ([self.delegate respondsToSelector:@selector(onesiteDidFailWithNodeID:)]) {
				[self.delegate onesiteDidFailWithNodeID:nodeId];
			}
		}
	} else {
		if ([self.delegate respondsToSelector:@selector(onesiteDidCancel)]) {
			[self.delegate onesiteDidCancel];
		}
	}	
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)oauthClientDidReceiveAccessToken:(LROAuth2Client *)client
{
	NSDictionary* dict = [self parseAccessToken:[client.accessToken accessToken]];
	
	if (dict != nil) {
		if (([dict objectForKey:@"nodeId"]) && ([dict objectForKey:@"userId"]) && ([dict objectForKey:@"userId"])) { 
			NSNumber *nodeId = [dict objectForKey:@"nodeId"];
			NSNumber *userId = [dict objectForKey:@"userId"];
			NSString *accessToken = [dict objectForKey:@"accessToken"];
			
			DELOG(@"nodeId: %@", [nodeId stringValue]);
			DELOG(@"userId: %@", [userId stringValue]);		
			
			[NSUserDefaults addOnesiteAccount:nodeId uid:userId accessToken:accessToken];
			DELOG(@"Account Saved %@", [NSUserDefaults isOnesiteAccountEnabled:nodeId] ? @"yes":@"no");
			
			if ([self.delegate respondsToSelector:@selector(onesiteDidLogin:)]) {
				[self.delegate onesiteDidLogin:nodeId];
			}
		}
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)oauthClientDidRefreshAccessToken:(LROAuth2Client *)client
{
	DELOG(@"Refreshed Access Token");
	[self oauthClientDidReceiveAccessToken:client];
}

#pragma mark - Helper functions
- (NSDictionary*)parseAccessToken:(NSString*)accessToken
{
	DELOG(@"Access Token = %@", accessToken);
	if (accessToken != nil) {
		NSArray *tokens = [[[accessToken componentsSeparatedByString:@"|"] objectAtIndex:1] componentsSeparatedByString:@"."];
		
		if ([tokens count] == 3) {
			if (([tokens objectAtIndex:1] != nil) && ([tokens objectAtIndex:2] != nil)) {
				NSNumber *nodeId = [NSNumber numberWithInt:[[tokens objectAtIndex:1] intValue]];
				NSNumber *userId = [NSNumber numberWithInt:[[tokens objectAtIndex:2] intValue]];
				
				NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:nodeId, @"nodeId", 
									  userId, @"userId",
									  accessToken, @"accessToken",
									  nil];
				
				return dict;
			}
		}
	}
	
	return nil;
}

@end