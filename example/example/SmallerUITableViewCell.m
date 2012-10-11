//
//  SmallerUITableViewCell.m
//  example
//
//  Created by Jake Farrell on 1/25/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "SmallerUITableViewCell.h"

@implementation SmallerUITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect frame = self.frame;
	frame.size.width = 200;
	self.frame = frame;
	self.contentView.frame = self.frame;
}

@end
