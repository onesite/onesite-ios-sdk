//
//  UIDatePickerActionSheet.m
//  example
//
//  Created by Jake Farrell on 1/25/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "UIDatePickerActionSheet.h"

@implementation UIDatePickerActionSheet

@synthesize dateDelegate = _dateDelegate;
@synthesize datePicker = _datePicker;

- (id)initWithTitle:(NSString*)title delegate:(id<UIDatePickerActionSheetDelegate>)delegate
{
	self = [super initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
	[self setActionSheetStyle:UIActionSheetStyleBlackOpaque];
	
	self.dateDelegate = delegate;
	if (self) {
	}
	return self;
}

- (void)dealloc
{
	[_datePicker release];
    
	[super dealloc];
}

- (void)doneButtonAction
{
	[self.dateDelegate datePickerDidSelectDate:[self.datePicker date]];
	[self dismissWithClickedButtonIndex:[self firstOtherButtonIndex] animated:YES];
}

- (void)cancelButtonAction
{
	[self.dateDelegate datePickerDidCancel];
	[self dismissWithClickedButtonIndex:[self cancelButtonIndex] animated:YES];
}

- (void)showInView:(UIView *)view 
{
	[super showInView:view];
	
	UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
	[pickerDateToolbar sizeToFit];
	
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	[barItems addObject:flexSpace];
	
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doneButtonAction)];
	[barItems addObject:doneBtn];
	
	[pickerDateToolbar setItems:barItems animated:YES];
	
	[self addSubview:pickerDateToolbar];
		
	self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
	[self.datePicker setDatePickerMode:UIDatePickerModeDate];
	[self addSubview:self.datePicker];

	[self setBounds:CGRectMake(0, 0, 320, 485)];
}


@end
