//
//  MainViewController.h
//  example
//
//  Created by Jake Farrell on 1/18/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSSocialAccounts.h"
#import "Facebook.h"
#import "TwitterSessionDelegate.h"
#import "OnesiteSessionDelegate.h"
#import "UserApi.h"

@interface MainViewController : UITableViewController<UINavigationControllerDelegate, FBSessionDelegate, FBRequestDelegate, TwitterSessionDelegate, OnesiteSessionDelegate>
{
	DDSSocialAccounts *_accounts;
    UIButton *_settingsButton;
    User *_user;
}

@property (nonatomic, retain) DDSSocialAccounts *accounts;
@property (nonatomic, retain) UIButton *settingsButton;
@property (nonatomic, retain) User *user;

- (void)showSignup;
- (void)showSettingsView;

// Facebook
- (void)displayFacebookLogin;

// Twitter
- (void)displayTwitterLogin;

// Onesite
- (void)displayOnesiteLogin:(NSDictionary*)account;
- (void)loadOnesiteUserWithAccessToken:(NSString*)accessToken;
- (void)showLoginError;
- (void)createSessionForUser:(User*)user;
- (void)createUserWithExternalAccount:(ExternalAccount*)externalAccount;
- (void)checkSessionResponse:(ResponseSession*)response;
- (void)loadUser;
- (void)resetUser;

@end
