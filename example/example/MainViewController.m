//
//  MainViewController.m
//  example
//
//  Created by Jake Farrell on 1/18/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "MainViewController.h"

#import "SettingsViewController.h"
#import "SignupViewController.h"

#import "NSUserDefaults+Extensions.h"
#import "FacebookWrapper.h"
#import "TwitterLoginDialog.h"
#import "OnesiteLoginDialog.h"
#import "SessionApi.h"
#import "Configuration.h"

@implementation MainViewController

@synthesize accounts = _accounts;
@synthesize settingsButton = _settingsButton;
@synthesize user = _user;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self setAccounts:[DDSSocialAccounts getInstance]];
    }
    return self;
}

- (void)dealloc
{
    [_accounts release], self.accounts = nil;
    [_settingsButton release], self.settingsButton = nil;
    [_user release], self.user = nil;
    
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)loadView
{
	[super loadView];
    
	[self.view setBackgroundColor:[UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:100]];
    
    UIView *tableBackground = [[UIView alloc] initWithFrame:self.tableView.frame];
    [tableBackground setBackgroundColor:[UIColor clearColor]];
	[self.tableView setBackgroundView:tableBackground];
    
	[self setSettingsButton:[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)]];
	[self.settingsButton setImage:[UIImage imageNamed:@"icn-settings"] forState:UIControlStateNormal];
	[self.settingsButton setShowsTouchWhenHighlighted:YES];
	[self.settingsButton addTarget:self action:@selector(showSettingsView) forControlEvents:UIControlEventTouchUpInside];
    [self.settingsButton setHidden:YES];
	UIBarButtonItem *settingsBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingsButton];
	
    [self.navigationItem setRightBarButtonItem:settingsBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([NSUserDefaults getOnesiteAccessToken]) {
        [self loadOnesiteUserWithAccessToken:[NSUserDefaults getOnesiteAccessToken]];
    } else {
        [self resetUser];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self user] != nil) {
        return 0;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return [self.accounts count];
		default:
			return 0;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return @"Sign In";
		default:
			return @"General";
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 54;
    }
    
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    if (section == 0) {
        [footer setFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
        [footer setBackgroundColor:[UIColor clearColor]];
        
        UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [signupButton.titleLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:12]];
        [signupButton.titleLabel setTextColor:[UIColor whiteColor]];
        [signupButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [signupButton setFrame:CGRectMake((footer.frame.size.width / 2) - 100, 10, 200, 44)];
        [signupButton setTitle:@"Signup" forState:UIControlStateNormal];
        [signupButton setBackgroundImage:[[UIImage imageNamed:@"btn-red"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [signupButton addTarget:self action:@selector(showSignup) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:signupButton];
    }
    
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[cell.textLabel setBackgroundColor:[UIColor clearColor]];
    
    if (indexPath.section == 0) {
        NSMutableDictionary *dataItem = [self.accounts objectAtIndex:indexPath.row];
		[dataItem setObject:cell forKey:@"cell"];
		
		[cell.textLabel setText:[dataItem objectForKey:@"name"]];
		[cell.textLabel setTextColor:[UIColor blackColor]];
		[cell.textLabel setBackgroundColor:[UIColor clearColor]];
		
		[cell.imageView setImage:[UIImage imageNamed:[dataItem objectForKey:@"icon"]]];
		
		[cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSMutableDictionary *dataItem;
	
    if (indexPath.section == 0) {
		dataItem = [self.accounts objectAtIndex:indexPath.row];
		
		NSString *selectedCell = [dataItem objectForKey:@"name"];
        if ([selectedCell isEqualToString:@"Facebook"]) {
            [self displayFacebookLogin];
        } else if ( [selectedCell isEqualToString:@"Twitter"]) {
            [self displayTwitterLogin];
        } else {
            [self displayOnesiteLogin:dataItem];
        }
	}
}

#pragma mark - Methods

- (void)showSignup
{
    SignupViewController *signup = [[[SignupViewController alloc] init] autorelease];
    [self.navigationController pushViewController:signup animated:YES];
}

- (void)showSettingsView
{
	SettingsViewController *settingView = [[[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
	[self.navigationController pushViewController:settingView animated:YES];
}

#pragma mark - Facebook

- (void)displayFacebookLogin
{
	NSLog(@"Showing Facebook Login");
    if ([NSUserDefaults isFacebookLoggedIn]) {
        [[FacebookWrapper getInstance] requestGraphPath:@"me" delegate:self];
    } else {
        [[FacebookWrapper getInstance] login:self];
    }
}

#pragma mark - FBSessionDelegate

- (void)fbDidLogin
{
	NSLog(@"fbDidLogin");
    
    [[FacebookWrapper getInstance] requestGraphPath:@"me" delegate:self];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
	NSLog(@"fbDidNotLogin");
}

#pragma mark - FBRequestDelegate

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    if (![result isKindOfClass:[NSDictionary class]] || [result objectForKey:@"id"] == nil) {
        [self showLoginError];
        return;
    }
    
    NSLog(@"Facebook Access token: %@\nFacebook expDate: %@", [[[FacebookWrapper getInstance] facebook] accessToken], [[[FacebookWrapper getInstance] facebook] expirationDate]);
	[NSUserDefaults setFacebookDefaults:[[[FacebookWrapper getInstance] facebook] accessToken]  expDate:[[[FacebookWrapper getInstance] facebook] expirationDate]];
    
    ExternalProperty *extProp = [[[ExternalProperty alloc] initWithName:@"facebook"
                                                                  type:@"user_id"
                                                                 value:[result objectForKey:@"id"]
                                  ] autorelease];
	
    [[UserApi getInstance] getUserByExternalProperty:extProp
                    resultCallback:^(TBase *responseObject) {
                        ResponseUser *userResponse = (ResponseUser*)responseObject;
                        
                        switch ([userResponse.status code]) {
                            case 100:
                                // User found.
                                [self createSessionForUser:[userResponse user]];
                                break;
                                
                            case 218:
                                // User not found, so create.
                                [self createUserWithExternalAccount:[
                                     [[ExternalAccount alloc] initWithProviderName:@"facebook"
                                                                    userIdentifier:[result objectForKey:@"id"]
                                                                       accessToken:[NSUserDefaults getFacebookAccessToken]
                                      ] autorelease]
                                 ];
                                break;
                                
                            default:
                                break;
                        }
                    }
                     errorCallback:^(NSError *error) {
                         [self showLoginError];
                     }
     ];
}

- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
    
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)requestLoading:(FBRequest *)request
{
    
}

#pragma mark - Twitter

-(void)displayTwitterLogin
{
    TwitterLoginDialog *twitterLoginController = [[[TwitterLoginDialog alloc] init] autorelease];
    [twitterLoginController setDelegate:self];
    
    [self presentViewController:twitterLoginController animated:YES completion:nil];
}

#pragma mark - TwitterSessionDelegate

- (void)twitterDidLogin
{
	NSLog(@"twitterDidLogin");
    
    // Check for an existing user with this Twitter account.
    ExternalProperty *extProp = [[[ExternalProperty alloc] initWithName:@"twitter" type:@"user_id" value:[NSUserDefaults twitterID]] autorelease];
    
    [[UserApi getInstance] getUserByExternalProperty:extProp
                    resultCallback:^(TBase *responseObject) {
                        ResponseUser *userResponse = (ResponseUser*)responseObject;
                        
                        switch ([userResponse.status code]) {
                            case 100:
                                // User found.
                                [self createSessionForUser:[userResponse user]];
                                break;
                                
                            case 218:
                                // User not found, so create.
                                [self createUserWithExternalAccount:[
                                     [[ExternalAccount alloc] initWithProviderName:@"twitter"
                                                                    userIdentifier:[NSUserDefaults twitterID]
                                                                       accessToken:[NSUserDefaults twitterOAuthAccessResponse]
                                      ] autorelease]
                                 ];
                                break;
                                
                            default:
                                break;
                        }
                    }
                     errorCallback:^(NSError *error) {
                         [self showLoginError];
                     }
     ];
}

- (void)twitterDidCancel
{
	NSLog(@"twitterDidCancel");
}

#pragma mark - Onesite

- (void)displayOnesiteLogin:(NSDictionary*)account
{
	// Onesite Account
	NSString *selectedUrl = [NSString stringWithFormat:@"%@", [[account objectForKey:@"url"] lowercaseString]];
	
	if (selectedUrl) {
		/* Example of using the OnesiteLoginDialog to login to facebook
         OnesiteLoginDialog *loginView = [[OnesiteLoginDialog alloc] initWithOAuthSettings:[[Constants getInstance] valueForKeyPath@"Facebook.FacebookAPIKey"]
         secret:[[Constants getInstance] valueForKeyPath@"Facebook.FacebookSecret"]
         callBackUrl:[[Constants getInstance] valueForKeyPath@"Onesite.OnesiteOAuthCallBackURL"]
         authorizeUrl:@"https://graph.facebook.com/oauth/authorize"
         accessUrl:@"https://graph.facebook.com/oauth/access_token"];
		 */
		
		OnesiteLoginDialog *loginView = [[OnesiteLoginDialog alloc] init];
		loginView.delegate = self;
		
		[self presentViewController:loginView animated:YES completion:nil];
	}
}

- (void)loadOnesiteUserWithAccessToken:(NSString*)accessToken
{
    UserApi *userApi = [[UserApi alloc] init];
    [userApi setAccessToken:accessToken];
    [userApi getDetailsOfUser:[[User alloc] init] resultCallback:^(TBase *responseObject) {
        if ([[(ResponseUser*)responseObject status] code] == 100) {
            [self setUser:[(ResponseUser*)responseObject user]];
            [NSUserDefaults resetFacebookDefaults];
            [NSUserDefaults resetTwitterDefaults];
            
            for (ExternalAccount *externalAccount in [self.user externalAccounts]) {
                if ([externalAccount.providerName isEqualToString:@"facebook"]) {
                    [NSUserDefaults setFacebookDefaults:[externalAccount accessToken] expDate:nil];
                } else if ([externalAccount.providerName isEqualToString:@"twitter"]) {
                    [NSUserDefaults setTwitterDefaultsWithResponse:[externalAccount accessToken]];
                }
            }
            
            [self loadUser];
        } else {
            [self resetUser];
            [self showLoginError];
        }
    } errorCallback:^(NSError *error) {
        [self resetUser];
        [self showLoginError];
    }];
    
    [userApi release];
}

- (void)showLoginError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"An error occurred during login. Please try again."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil
                          ];
    [alert show];
    [alert release];
}

- (void)createSessionForUser:(User *)user
{
    Session *session = [[[Session alloc] init] autorelease];
    [session setUser:user];
    
    [[SessionApi getInstance] createSession:session
                         withSessionOptions:[[[SessionOptions alloc] initWithUseAccessToken:YES] autorelease]
                             resultCallback:^(TBase *responseObject) {
                                 [self checkSessionResponse:(ResponseSession*)responseObject];
                             }
                              errorCallback:^(NSError *error) {
                                  [self showLoginError];
                              }
     ];
}

- (void)createUserWithExternalAccount:(ExternalAccount*)externalAccount
{
    User *user = [[[User alloc] init] autorelease];
    [user setExternalAccounts:[[NSArray alloc] initWithObjects:externalAccount, nil]];
    
#warning TODO: Fix error alert that appears just before refreshing user display.
    
    [[UserApi getInstance] createSessionUser:user
                                withPassword:[[[Password alloc] init] autorelease]
                       withUserCreateOptions:[[[UserCreateOptions alloc] init] autorelease]
                          withSessionOptions:[[[SessionOptions alloc] initWithUseAccessToken:YES] autorelease]
                              resultCallback:^(TBase *responseObject) {
                                  [self checkSessionResponse:(ResponseSession*)responseObject];
                              }
                               errorCallback:^(NSError *error) {
                                   [self showLoginError];
                               }
     ];
}

- (void)checkSessionResponse:(ResponseSession*)response
{
    if ([response.status code] != 100
        || [[response.session user] id] <= 0
        || [response.session accessToken] == nil
    ) {
        [self showLoginError];
        return;
    }
    
    NSNumber *nodeId = [NSNumber numberWithInt:[[[Configuration getInstance] valueForKeyPath:@"Onesite.OnesiteNodeId"] intValue]];
    [NSUserDefaults addOnesiteAccount:nodeId
                                  uid:[NSNumber numberWithInt:[[response.session user] id]]
                          accessToken:[response.session accessToken]
     ];
    
    [self setUser:[response.session user]];
    
    [NSUserDefaults resetFacebookDefaults];
    [NSUserDefaults resetTwitterDefaults];
    
    for (ExternalAccount *externalAccount in [self.user externalAccounts]) {
        if ([externalAccount.providerName isEqualToString:@"facebook"]) {
            [NSUserDefaults setFacebookDefaults:[externalAccount accessToken] expDate:nil];
        } else if ([externalAccount.providerName isEqualToString:@"twitter"]) {
            [NSUserDefaults setTwitterDefaultsWithResponse:[externalAccount accessToken]];
        }
    }
    
    [self loadUser];
}

- (void)loadUser
{
    CGRect frame = [self.tableView frame];
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    frame = CGRectMake((view.frame.size.width - 100)/2, (view.frame.size.height - 100)/3, 100, 100);
    UIImageView *avatar = [[[UIImageView alloc] initWithFrame:frame] autorelease];
    [avatar setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.user avatar]]]]];
    [view addSubview:avatar];
    
    frame = CGRectMake(10, avatar.frame.origin.y + avatar.frame.size.height + 10, view.frame.size.width - 20, 50);
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    [label setText:[NSString stringWithFormat:@"Hello, %@!", [self.user displayName]]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setNumberOfLines:0];
    [view addSubview:label];
    
    frame.origin.y += frame.size.height;
    UILabel *helpLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
    [helpLabel setText:@"Click the settings icon to link your other accounts."];
    [helpLabel setBackgroundColor:[UIColor clearColor]];
    [helpLabel setTextAlignment:NSTextAlignmentCenter];
    [helpLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [helpLabel setNumberOfLines:0];
    [view addSubview:helpLabel];
    
    [self.tableView setTableHeaderView:view];
    [self.settingsButton setHidden:NO];
    
    [[self tableView] reloadData];
}

- (void)resetUser
{
    [self setUser:nil];
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.settingsButton setHidden:YES];
    [[self tableView] reloadData];
}

#pragma mark - OnesiteSessionDelegate

- (void)onesiteDidLogin:(NSNumber *)nodeId
{
    NSLog(@"onesiteDidLogin");
    
    [self loadOnesiteUserWithAccessToken:[[NSUserDefaults getOnesiteAccount:nodeId] objectForKey:@"accessToken"]];
}

- (void)onesiteDidFailWithNodeID:(NSNumber *)nodeId
{
    NSLog(@"onesiteDidFailWithNodeID: %@", [nodeId stringValue]);
}

- (void)onesiteDidCancel
{
	NSLog(@"onesiteDidCancel");
}

@end
