//
//  UIDatePickerActionSheet.h
//  example
//
//  Created by Jake Farrell on 1/25/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIDatePickerActionSheetDelegate <NSObject>
@required
- (void)datePickerDidSelectDate:(NSDate*)date;
@optional
- (void)datePickerDidCancel;
@end

@interface UIDatePickerActionSheet : UIActionSheet<UIActionSheetDelegate>
{
	id<UIDatePickerActionSheetDelegate> _dateDelegate;
	UIDatePicker *_datePicker;
}
@property (nonatomic, assign) id<UIDatePickerActionSheetDelegate> dateDelegate;
@property (nonatomic, retain) UIDatePicker *datePicker;

- (id)initWithTitle:(NSString*)title delegate:(id<UIDatePickerActionSheetDelegate>)delegate;

@end
