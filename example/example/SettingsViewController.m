//
//  SettingsViewController.m
//  example
//
//  Created by Jake Farrell on 1/23/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "SettingsViewController.h"
#import "NSUserDefaults+Extensions.h"

#import "FacebookWrapper.h"
#import "TwitterLoginDialog.h"

#import "UserApi.h"

@implementation SettingsViewController

@synthesize accounts = _accounts;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.accounts = [DDSSocialAccounts getInstance];		
    }
    return self;
}

- (void)dealloc
{
	[_accounts release], self.accounts = nil;
	
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)loadView
{
	[super loadView];
	
	[self setTitle:@"Settings"];
	[self.view setBackgroundColor:[UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:100]];
	
    UIView *tableBackground = [[UIView alloc] initWithFrame:self.tableView.frame];
    [tableBackground setBackgroundColor:[UIColor clearColor]];
	[self.tableView setBackgroundView:tableBackground];
    
	UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]]];
	[backButton.titleLabel setTextColor:[UIColor whiteColor]];
	[backButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
	[backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6.0, 0, 3.0)];
	[backButton setFrame:CGRectMake(0, 0, 60, 30)];
	[backButton setTitle:@"Back" forState:UIControlStateNormal];
	[backButton setBackgroundImage:[[UIImage imageNamed:@"btn-back"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
	
	[self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];
	[backButton release];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) 
	{
		case 0:
			return [self.accounts count] - 1;
		default:
			return 0;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
	switch (section) 
	{
		case 0:
			return @"Accounts";
		default:
			return @"General";
	}
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
		
		NSString *name = [dataItem objectForKey:@"name"];
		BOOL selected = [self.accounts isEnabled:indexPath.row];
		
		NSLog(@"%@ enabled: %@", name, selected ?@"YES":@"NO");
		
		[cell.textLabel setText:name];
		[cell.textLabel setTextColor:[UIColor blackColor]];
		[cell.textLabel setBackgroundColor:[UIColor clearColor]];
		
		[cell.imageView setImage:[UIImage imageNamed:[dataItem objectForKey:@"icon"]]];
		
		[cell setAccessoryType:selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
	} 
	
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    
    if (section == 0) {
        UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [logoutButton.titleLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:12]];
        [logoutButton.titleLabel setTextColor:[UIColor whiteColor]];
        [logoutButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [logoutButton setFrame:CGRectMake((view.frame.size.width / 2) - 100, 10, 200, 44)];
        [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
        [logoutButton setBackgroundImage:[[UIImage imageNamed:@"btn-red"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:logoutButton];
	}
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 54;
    }
    
    return 0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSMutableDictionary *dataItem;
	
    if (indexPath.section == 0) {
		dataItem = [self.accounts objectAtIndex:indexPath.row];
		
		NSString *selectedCell = [dataItem objectForKey:@"name"];
		NSLog(@"Selected: %@, enabled %@", selectedCell, ([self.accounts isEnabled:indexPath.row]?@"yes":@"no"));
		
		// check to see if they are logged in first, if they are then prompt to logout
		if ([self.accounts isEnabled:indexPath.row]) {
			loginPopupQuery = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Logout from %@?", selectedCell] 
														  delegate:self 
												 cancelButtonTitle:@"Cancel" 
											destructiveButtonTitle:@"Logout" 
												 otherButtonTitles:nil];
			
			[loginPopupQuery setTag:indexPath.row];
			[loginPopupQuery setActionSheetStyle:UIActionSheetStyleBlackOpaque];
			[loginPopupQuery showInView:self.view];
			[loginPopupQuery release];
		} else {
			// log them into the given selected service (@See same code in SocialTableController)
			if ([selectedCell isEqualToString:@"Facebook"]) {
				[self displayFacebookLogin];
			} else if ( [selectedCell isEqualToString:@"Twitter"]) {
				[self displayTwitterLogin];
			}
		}
	}	
}

#pragma mark - Navigation

- (void)backAction
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)logoutAction
{
    [NSUserDefaults resetDefaults];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showAccountError:(NSString *)provider
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:[NSString stringWithFormat:@"Error retrieving %@ profile. Please try again.", provider]
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil]
                          autorelease];
    [alert show];
}

- (void)showConnectError:(NSString *)provider
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:[NSString stringWithFormat:@"Error connecting %@ account. Please try again.", provider]
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil]
                          autorelease];
    [alert show];
}

- (void)unlinkAccount:(NSString*)provider
{
    ExternalAccount *externalAccount = [[[ExternalAccount alloc] init] autorelease];
    [externalAccount setProviderName:provider];
    
    UserApi *api = [[[UserApi alloc] init] autorelease];
    [api setAccessToken:[NSUserDefaults getOnesiteAccessToken]];
    
    [api deleteExternalAccount:externalAccount
                      fromUser:[[[User alloc] init] autorelease]
                resultCallback:^(TBase *responseObject) {
                    if ([provider isEqualToString:@"facebook"]) {
                        [[FacebookWrapper getInstance] logout:self];
                    } else if ([provider isEqualToString:@"twitter"]) {
                        [NSUserDefaults resetTwitterDefaults];
                        [self.tableView reloadData];
                    }
                }
                 errorCallback:nil
     ];
}

#pragma mark - Facebook

-(void) displayFacebookLogin
{
	NSLog(@"Showing Facebook Login");
	[[FacebookWrapper getInstance] login:self];
}

#pragma mark - Facebook Session Delegate
- (void)fbDidLogin {
	NSLog(@"fbDidLogin");
	
    [[FacebookWrapper getInstance] requestGraphPath:@"me" delegate:self];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"fbDidNotLogin");
	[NSUserDefaults resetFacebookDefaults];
    
    [[self tableView] reloadData];
}

- (void)fbDidLogout {
	NSLog(@"fbDidLogout");
	[NSUserDefaults resetFacebookDefaults];
    
    [[self tableView] reloadData];
}

#pragma mark - FBRequestDelegate

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    if (![result isKindOfClass:[NSDictionary class]] || [result objectForKey:@"id"] == nil) {
        [self showAccountError:@"Facebook"];
        return;
    }
    
    NSLog(@"Facebook Access token: %@\nFacebook expDate: %@", [[[FacebookWrapper getInstance] facebook] accessToken], [[[FacebookWrapper getInstance] facebook] expirationDate]);
	
    ExternalAccount *externalAccount = [[[ExternalAccount alloc] initWithProviderName:@"facebook"
                                                                       userIdentifier:[result objectForKey:@"id"]
                                                                          accessToken:[[[FacebookWrapper getInstance] facebook] accessToken]
                                         ] autorelease];
	
    UserApi *api = [[[UserApi alloc] init] autorelease];
    [api setAccessToken:[NSUserDefaults getOnesiteAccessToken]];
    
    [api addExternalAccount:externalAccount
                                       toUser:[[[User alloc] init] autorelease]
                               resultCallback:^(TBase *responseObject) {
                                   ResponseUser *userResponse = (ResponseUser*)responseObject;
                                   
                                   switch ([userResponse.status code]) {
                                       case 100:
                                           [NSUserDefaults setFacebookDefaults:[[[FacebookWrapper getInstance] facebook] accessToken]  expDate:[[[FacebookWrapper getInstance] facebook] expirationDate]];
                                           [self.tableView reloadData];
                                           break;
                                        default:
                                           [self showConnectError:@"Facebook"];
                                           break;
                                   }
                                   
                               }
                                errorCallback:^(NSError *error) {
                                    [self showConnectError:@"Facebook"];
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

-(void) displayTwitterLogin
{
	if (![NSUserDefaults isTwitterLoggedIn]) {
		TwitterLoginDialog *twitterLoginController = [[[TwitterLoginDialog alloc] init] autorelease];
		[twitterLoginController setDelegate:self];
		
		[self presentViewController:twitterLoginController animated:YES completion:nil];
	} else {
		[NSUserDefaults resetTwitterDefaults];
		[[self tableView] reloadData];
	}
}

#pragma mark - Twitter Session delegate
- (void) twitterDidLogin
{
	NSLog(@"twitterDidLogin");
    
    ExternalAccount *externalAccount = [[[ExternalAccount alloc] initWithProviderName:@"twitter"
                                                                       userIdentifier:[NSUserDefaults twitterID]
                                                                          accessToken:[NSUserDefaults twitterOAuthAccessResponse]
                                         ] autorelease];
	
    UserApi *api = [[[UserApi alloc] init] autorelease];
    [api setAccessToken:[NSUserDefaults getOnesiteAccessToken]];
    
    [api addExternalAccount:externalAccount
                                       toUser:[[[User alloc] init] autorelease]
                               resultCallback:^(TBase *responseObject) {
                                   ResponseUser *userResponse = (ResponseUser*)responseObject;
                                   
                                   switch ([userResponse.status code]) {
                                       case 100:
                                           [self.tableView reloadData];
                                           break;
                                       default:
                                           [self showConnectError:@"Twitter"];
                                           [NSUserDefaults resetTwitterDefaults];
                                           [[self tableView] reloadData];
                                           break;
                                   }
                                   
                               }
                                errorCallback:^(NSError *error) {
                                    [self showConnectError:@"Twitter"];
                                    [NSUserDefaults resetTwitterDefaults];
                                    [[self tableView] reloadData];
                                }
     ];
}

- (void) twitterDidCancel
{
	NSLog(@"twitterDidCancel");	
	[[self tableView] reloadData];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    
    NSDictionary *dataItem = [self.accounts objectAtIndex:[actionSheet tag]];
    NSString *selectedCell = [dataItem objectForKey:@"name"];
    
    if ([selectedCell isEqualToString:@"Facebook"]) {
        [self unlinkAccount:@"facebook"];
    } else if ([selectedCell isEqualToString:@"Twitter"]) {
        [self unlinkAccount:@"twitter"];
    }
}

@end
