//
//  SignupViewController.h
//  example
//
//  Created by Janell Pechacek on 9/26/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDatePickerActionSheet.h"

@interface SignupViewController : UITableViewController<UINavigationControllerDelegate, UITextFieldDelegate, UIDatePickerActionSheetDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>
{
	UITextField *_firstname;
	UITextField *_lastname;
	UITextField *_username;
	UITextField *_email;
	UITextField *_birthdate;
	UITextField *_password;
	
	UIButton *_photoAvatar;
}

@property (nonatomic, retain) UITextField *firstname;
@property (nonatomic, retain) UITextField *lastname;
@property (nonatomic, retain) UITextField *username;
@property (nonatomic, retain) UITextField *email;
@property (nonatomic, retain) UITextField *birthdate;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) UIButton *photoAvatar;

- (void)showImagePickerView;
- (void)signupAction;
- (void)backAction;

@end
