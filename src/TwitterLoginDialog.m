//
//  TwitterLoginDialog.m
//  sso
//
//  Created by Jake Farrell on 1/17/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "TwitterLoginDialog.h"
#import "Configuration.h"
#import "NSUserDefaults+Extensions.h"

@implementation TwitterLoginDialog

@synthesize consumer = _consumer;
@synthesize storedRequestToken = _storedRequestToken;
@synthesize storedAccessToken =  _storedAccessToken;
@synthesize delegate = _delegate;

- (void) dealloc
{
	[_consumer release];	
	[_storedRequestToken release];
	[_storedAccessToken release];	
	
	self.delegate = nil;
	[_delegate release];
	
	[super dealloc];
}

- (id)init
{
	self = [super init];
	if (self != nil) {
		[self setTitle:@"Twitter"];
        [self setHidesBottomBarWhenPushed:YES];
	}
	return self;
}

- (void)loadView
{
	[super loadView];
	[self setupPage];
	
	pageLoaded = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (!pageLoaded) {
		[self setupPage];
	}
	
	[self.navigationController setNavigationBarHidden:YES animated:YES];	
	pageLoaded = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setupPage
{
	UIImage *loadingImage = [UIImage imageNamed:@"twitter_loading"];
	
	if (loadingImage != nil) {
		[self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:loadingImage]];
	}
	
	// Start OAuth process
	[self setupConsumer];
	
	// Once a consumer has been setup then get the request token
	[self performSelector:@selector(getRequestToken) withObject:nil afterDelay:.2];
}

- (void)closeWindow
{ 
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) handleError
{
	[NSUserDefaults resetTwitterDefaults];
	
	if ([self.delegate respondsToSelector:@selector(twitterDidCancel)]) {
		[self.delegate twitterDidCancel];
	}
	
	[self closeWindow];
}

#pragma mark <Webview Functions>

// Intercept page requests and when successfully authenticated start processing
- (BOOL) webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSString *callbackUrl = [[Configuration getInstance] valueForKeyPath:@"Twitter.TwitterCallBackURL"];
	
  	NSRange callBackTest = [[[request URL] absoluteString] rangeOfString:callbackUrl];
	NSRange verifier_start = [request.URL.query rangeOfString:@"oauth_verifier="];
	
	if (verifier_start.location != NSNotFound) {
		DELOG(@"Verifier Found!");
	}
	
	DELOG(@"REQ URL: %@", request.URL.query);
	
	if (callBackTest.location != NSNotFound) {
		DELOG(@"GOT THE AUTH TOKEN");
		[self getAccessToken];
		return NO;
	}
	
	return YES;
}

#pragma mark <Oauth Functions>

- (void) setupConsumer
{
	if (self.consumer != nil) {
		[self.consumer release];
		self.consumer = nil;
	}
	
	NSString *apiKey = [[Configuration getInstance] valueForKeyPath:@"Twitter.TwitterAPIKey"];	
	NSString *apiSecret = [[Configuration getInstance] valueForKeyPath:@"Twitter.TwitterAPISecret"];	
	
	[self setConsumer:[[OAConsumer alloc] initWithKey:apiKey secret:apiSecret]];
}

- (void) getRequestToken
{
	NSString *callBackDomain = [[Configuration getInstance] valueForKeyPath:@"Twitter.TwitterCallBackDomain"];	
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"]
																   consumer:self.consumer
																	  token:nil
																	  realm:callBackDomain
														  signatureProvider:nil];
	[request setHTTPMethod:@"GET"];	
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenCallback:didFinishWithResponse:)
                  didFailSelector:@selector(requestTokenCallback:didFailWithError:)];
}

- (void) requestTokenCallback:(OAServiceTicket*)ticket didFinishWithResponse:(NSData*)data
{
	if (ticket.didSucceed) {
		// Token acquired, remove the msg presented to the user in viewDidLoad
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		[self setStoredRequestToken:[[OAToken alloc] initWithHTTPResponseBody:responseBody]];
		
		DELOG(@"Request secret and key:\nSecret: %@\nKey: %@ \n\n", [self.storedRequestToken secret], [self.storedRequestToken key]);
		NSString *urlString = [NSString stringWithFormat:@"%@?oauth_token=%@", @"https://api.twitter.com/oauth/authorize", [self.storedRequestToken key]];
		DELOG(@"Request string: %@ \n\n", urlString);
		
		NSURL *url = [NSURL URLWithString:urlString];
		
		// Open Auth in Safari
		// [[UIApplication sharedApplication] openURL:url];
		
		// Open Auth within App in a webview
		UIWebView *oAuthWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
		[oAuthWebView setDelegate:self];
		[oAuthWebView setOpaque:NO];
		[oAuthWebView setBackgroundColor:[UIColor clearColor]];
		[oAuthWebView setScalesPageToFit:YES];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[oAuthWebView loadRequest:requestObj];
		
		[self.view addSubview:oAuthWebView];
	} else {
		DELOG(@"Got error while requesting request token. %@", ticket.response);
		[self handleError];
	}
}

- (void) requestTokenCallback:(OAServiceTicket*)ticket didFailWithError:(NSError*)error
{
	DELOG(@"Got error while requesting request token. %@", ticket.response);
	[self handleError];
}

- (void)getAccessToken
{
	OAToken *requestToken = self.storedRequestToken;
	
	DELOG(@"Getting access token for request token: %@ : %@ \n\n", [requestToken key], [requestToken secret]);
	
	NSString *callbackUrl = [[Configuration getInstance] valueForKeyPath:@"Twitter.TwitterCallBackURL"];
	NSString *callBackDomain = [[Configuration getInstance] valueForKeyPath:@"Twitter.TwitterCallBackDomain"];	
  		
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"]
																   consumer:self.consumer
																	  token:requestToken
																	  realm:callBackDomain
														  signatureProvider:nil];
	
	[request setOAuthParameterName:@"oauth_callback" withValue:callbackUrl];
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	[fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(accessTokenCallback:didFinishWithData:)
                  didFailSelector:@selector(accessTokenCallback:didFailWithError:)];
	[request release];
	[fetcher release];
}

- (void)accessTokenCallback:(OAServiceTicket*)ticket didFinishWithData:(NSData*)data
{
	// Request token sent, Access Token acquired sucessfully, remove the msg presented to the user in viewDidLoad
	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		[self setStoredAccessToken:[[OAToken alloc] initWithHTTPResponseBody:responseBody]];
		
		DELOG(@"Got an access token:\nAccess Token Key: %@\nAccess Token Secret: %@\nResp: %@", [self.storedAccessToken key], [self.storedAccessToken secret], [self.storedAccessToken body]);
		
		// Successful login, save the Secret and Key and go continue to next page
		[NSUserDefaults setTwitterDefaults:[self.storedAccessToken key] 
									secret:[self.storedAccessToken secret] 
									  resp:[self.storedAccessToken body]
									   uid:[self.storedAccessToken getValueFromBody:@"user_id"]
								  username:[self.storedAccessToken getValueFromBody:@"screen_name"]];
		
		if ([self.delegate respondsToSelector:@selector(twitterDidLogin)]) {
			[self.delegate twitterDidLogin];
		}
		
		[self closeWindow];
	} else {
		DELOG(@"Got error while requesting access token. %@", ticket.response);		
		[self handleError];
	}
}

- (void)accessTokenCallback:(OAServiceTicket*)ticket didFailWithError:(NSError*)error
{
	DELOG(@"Got error while requesting access token. %@", ticket.response);		
	[self handleError];
}

@end

