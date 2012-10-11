//
//  TwitterSessionDelegate.h
//  sso
//
//  Created by Jake Farrell on 1/17/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TwitterSessionDelegate <NSObject>
- (void)twitterDidLogin;
- (void)twitterDidCancel;
@end
