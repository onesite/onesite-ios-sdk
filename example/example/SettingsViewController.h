//
//  SettingsViewController.h
//  example
//
//  Created by Jake Farrell on 1/23/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSSocialAccounts.h"
#import "Facebook.h"
#import "TwitterSessionDelegate.h"

@interface SettingsViewController : UITableViewController<UIActionSheetDelegate, FBSessionDelegate, FBRequestDelegate, TwitterSessionDelegate>
{
	DDSSocialAccounts *_accounts;
	
	UIActionSheet *loginPopupQuery;
}
@property (nonatomic, retain) DDSSocialAccounts *accounts;

- (void)backAction;
- (void)logoutAction;
- (void)showAccountError:(NSString*)provider;
- (void)showConnectError:(NSString*)provider;
- (void)unlinkAccount:(NSString*)provider;

// Facebook
- (void)displayFacebookLogin;

// Twitter
- (void)displayTwitterLogin;

@end
