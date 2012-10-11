//
//  OnesiteLoginDialog.h
//  sso
//
//  Created by Jake Farrell on 1/17/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LROAuth2ClientDelegate.h"
#import	"OnesiteSessionDelegate.h"

@interface OnesiteLoginDialog : UIViewController <UIWebViewDelegate, LROAuth2ClientDelegate> 
{
	id <OnesiteSessionDelegate> _delegate;
	
	LROAuth2Client *oauthClient;
	UIWebView *webView;
}

@property (nonatomic, assign) id <OnesiteSessionDelegate> delegate;
@property (nonatomic, retain) UIWebView *webView;

- (id)init;
- (id)initWithOAuthSettings:(NSString*)clientId secret:(NSString*)secret callBackUrl:(NSString*)callBackUrl authorizeUrl:(NSString*)authorizeUrl accessUrl:(NSString*)accessUrl;
- (NSDictionary*)parseAccessToken:(NSString*)accessToken;

@end

