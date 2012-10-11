//
//  SignupViewController.m
//  example
//
//  Created by Janell Pechacek on 9/26/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "SignupViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "SmallerUITableViewCell.h"
#import "UserApi.h"
#import "NSUserDefaults+Extensions.h"
#import "Configuration.h"

@implementation SignupViewController

@synthesize firstname = _firstname;
@synthesize lastname = _lastname;
@synthesize email = _email;
@synthesize username = _username;
@synthesize birthdate = _birthdate;
@synthesize password = _password;
@synthesize photoAvatar = _photoAvatar;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
	[_firstname release], self.firstname = nil;
	[_lastname release], self.lastname = nil;
	[_email release], self.email = nil;
	[_username release], self.username = nil;
    [_birthdate release], self.birthdate = nil;
	[_password release], self.password = nil;
	[_photoAvatar release], self.photoAvatar = nil;
	
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)loadView
{
	[super loadView];
    
    [self setTitle:@"Signup"];
	[self.view setBackgroundColor:[UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:100]];
	
    UIView *tableBackground = [[UIView alloc] initWithFrame:self.tableView.frame];
    [tableBackground setBackgroundColor:[UIColor clearColor]];
	[self.tableView setBackgroundView:tableBackground];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
    
	UIImageView *photoBorder = [[[UIImageView alloc] initWithFrame:CGRectMake(210, 10, 91, 98)] autorelease];
	[photoBorder setImage:[UIImage imageNamed:@"ui-photo-border"]];
	[self.view addSubview:photoBorder];
	
	[self setPhotoAvatar:[[UIButton alloc] initWithFrame:CGRectMake(photoBorder.frame.origin.x + 11, photoBorder.frame.origin.y + 10, 69, 70)]];
	[self.photoAvatar setImage:[UIImage imageNamed:@"ui-add-photo"] forState:UIControlStateNormal];
	[self.photoAvatar addTarget:self action:@selector(showImagePickerView) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.photoAvatar];
    
	UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
	[footer setBackgroundColor:[UIColor clearColor]];
	[self.tableView setTableFooterView:footer];
	
	UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[signupButton.titleLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:12]];
	[signupButton.titleLabel setTextColor:[UIColor whiteColor]];
	[signupButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
	[signupButton setFrame:CGRectMake((footer.frame.size.width / 2) - 100, 10, 200, 44)];
	[signupButton setTitle:@"Signup" forState:UIControlStateNormal];
	[signupButton setBackgroundImage:[[UIImage imageNamed:@"btn-red"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
	[signupButton addTarget:self action:@selector(signupAction) forControlEvents:UIControlEventTouchUpInside];
	[footer addSubview:signupButton];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return 2;
		case 1:
			return 3;
		case 2:
			return 1;
		default:
			return 0;
	}
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		if ([indexPath section] == 0) {
			cell = [[[SmallerUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		} else {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
	}
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 12, 280, 30)];
	[textField setDelegate:self];
    [textField setAdjustsFontSizeToFitWidth:YES];
    [textField setTextColor:[UIColor blackColor]];
	[textField setBackgroundColor:[UIColor clearColor]];
	[textField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[textField setTextAlignment:NSTextAlignmentLeft];
	[textField setClearButtonMode:UITextFieldViewModeNever];
	[textField setKeyboardType:UIKeyboardTypeDefault];
	[textField setReturnKeyType:UIReturnKeyNext];
	[textField setEnabled: YES];
	
	if ([indexPath section] == 0) {
		[textField setFrame:CGRectMake(20, 12, 170, 30)];
		
		if ([indexPath row] == 0) {
			[self setFirstname:textField];
			[textField setPlaceholder:@"First Name"];
			[textField setTag:0];
		} else if ([indexPath row] == 1) {
			[self setLastname:textField];
			[textField setPlaceholder:@"Last Name"];
			[textField setTag:1];
		}
	} else if ([indexPath section] == 1) {
		if ([indexPath row] == 0) {
			[self setEmail:textField];
			[textField setPlaceholder:@"Email"];
			[textField setKeyboardType:UIKeyboardTypeEmailAddress];
			[textField setTag:2];
		} else if ([indexPath row] == 1) {
			[self setUsername:textField];
			[textField setPlaceholder:@"Username"];
			[textField setTag:3];
		} else if ([indexPath row] == 2) {
			[self setBirthdate:textField];
			[textField setPlaceholder:@"Birth Date"];
			[textField setEnabled:NO];
			[textField setTag:4];
		}
	} else if ([indexPath section] == 2) {
		if ([indexPath row] == 0) {
			[self setPassword:textField];
			[textField setPlaceholder:@"Password"];
			[textField setSecureTextEntry:YES];
			[textField setReturnKeyType:UIReturnKeyDone];
			[textField setTag:5];
		}
	}
	
	[cell addSubview:textField];
	[textField release];
	
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath section] == 1) {
		if ([indexPath row] == 2) {
			UIDatePickerActionSheet *datePicker = [[UIDatePickerActionSheet alloc] initWithTitle:@"Select Birthday" delegate:self];
			[datePicker showInView:self.view];
			[datePicker release];
		}
	}
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
	NSInteger nextTag = textField.tag + 1;
	if ([self.password tag] == [textField tag]){
		[textField resignFirstResponder];
	} else {
		if ([self.firstname tag] == nextTag) {
			[self.firstname becomeFirstResponder];
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		} else if ([self.lastname tag] == nextTag) {
			[self.lastname becomeFirstResponder];
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		} else if ([self.email tag] == nextTag) {
			[self.email becomeFirstResponder];
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		} else if ([self.username tag] == nextTag) {
			[self.username becomeFirstResponder];
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		} else if ([self.birthdate tag] == nextTag) {
			[self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		} else if ([self.password tag] == nextTag) {
			[self.password becomeFirstResponder];
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		}
	}
	
	return YES;
}

#pragma mark - UIDatePickerActionSheetDelegate

- (void)datePickerDidSelectDate:(NSDate*)date
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateStyle:NSDateFormatterLongStyle];
	[self.birthdate setText:[NSString stringWithFormat:@"%@", [df stringFromDate:date]]];
	[df release];
	
	[self textFieldShouldReturn:self.birthdate];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch ([actionSheet tag]) {
		case 0:
			if (buttonIndex == 0) {
				NSLog(@"Existing Photo");
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];
				[picker setDelegate:self];
				[picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                [self presentViewController:picker animated:YES completion:nil];
				[picker release];
			}
			break;
		case 1:
			if (buttonIndex == 0) {
				NSLog(@"Existing Photo");
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];
				[picker setDelegate:self];
				[picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                [self presentViewController:picker animated:YES completion:nil];
				[picker release];
			} else if (buttonIndex == 1) {
				NSLog(@"Camera");
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];
				[picker setDelegate:self];
				[picker setSourceType:UIImagePickerControllerSourceTypeCamera];
                [self presentViewController:picker animated:YES completion:nil];
				[picker release];
			}
			break;
        default:
            break;
	}
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[picker parentViewController] dismissViewControllerAnimated:YES completion:nil];
	
    // MediaType can be kUTTypeImage or kUTTypeMovie. If it's a movie then you can get the URL to the actual file itself.
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // NSString* videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
	
    if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        UIImage* picture = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!picture)
			picture = [info objectForKey:UIImagePickerControllerOriginalImage];
		
		[self.photoAvatar setImage:picture forState:UIControlStateNormal];
    }
	
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Methods

- (void)showImagePickerView
{
	UIActionSheet *sheet;
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:@"Cancel"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"Choose An Existing Photo", @"Take A Photo", nil
                 ];
		[sheet setActionSheetStyle:UIActionSheetStyleDefault];
        [sheet setTag:1];
		[sheet showInView:self.view];
		[sheet release];
    } else {
		sheet = [[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:@"Cancel"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"Choose An Existing Photo", nil
                 ];
		[sheet setActionSheetStyle:UIActionSheetStyleDefault];
        [sheet setTag:0];
		[sheet showInView:self.view];
		[sheet release];
	}
}

- (void)signupAction
{
    if ([self.firstname text] == nil
        || [self.lastname text] == nil
        || [self.username text] == nil
        || [self.email text] == nil
        || [self.birthdate text] == nil
        || [self.password text] == nil
        ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill out all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
	NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
	[df setDateStyle:NSDateFormatterLongStyle];
    
    NSDate *birthdate = [df dateFromString:[self.birthdate text]];
    
    User *user = [[User alloc] init];
    [user setUsername:[self.username text]];
    [user setEmail:[self.email text]];
    
    Profile *profile = [[Profile alloc] init];
    [profile setFirstName:[self.firstname text]];
    [profile setLastName:[self.lastname text]];
    [profile setBirthday:[birthdate timeIntervalSince1970]];
    
    [user setProfile:profile];
    
    [[UserApi getInstance] createSessionUser:user
                  withPassword:[[[Password alloc] initWithPassword:[self.password text] encoded:NO] autorelease]
         withUserCreateOptions:[[[UserCreateOptions alloc] init] autorelease]
            withSessionOptions:[[[SessionOptions alloc] initWithUseAccessToken:YES] autorelease]
                resultCallback:^(TBase *responseObject) {
                    ResponseSession *sessionResponse = (ResponseSession*)responseObject;
                    if ([sessionResponse.status code] == 100
                        && [[sessionResponse.session user] id] > 0
                        && [sessionResponse.session accessToken] != nil
                    ) {
                        NSNumber *nodeId = [NSNumber numberWithInt:[[[Configuration getInstance] valueForKeyPath:@"Onesite.OnesiteNodeId"] intValue]];
                        
                        [NSUserDefaults addOnesiteAccount:nodeId
                                                      uid:[NSNumber numberWithInt:[[sessionResponse.session user] id]]
                                              accessToken:[sessionResponse.session accessToken]
                         ];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        [self showSignupError];
                    }
                }
                 errorCallback:^(NSError *error) {
                     [self showSignupError];
                 }
     ];
}

- (void)backAction
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)showSignupError
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"An error occurred during signup. Please try again."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil
                           ] autorelease];
    [alert show];
}

@end
