//
//  Onesite.h
//  onesite-ios-sdk
//
//  Created by Jake Farrell on 1/18/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#include "OnesiteConstants.h"

@interface Onesite : NSObject

// Account status methods
+ (NSString*)stringFromAccountStatus:(enum AccountStatus)accountStatus;
+ (enum AccountStatus)accountStatusFromString:(NSString*)string;

// Gender methods
+ (NSString*)stringFromGender:(enum Gender)gender;
+ (enum Gender)genderFromString:(NSString*)string;

// Birthday display methods
+ (NSString*)stringFromBirthdayDisplay:(enum BirthdayDisplay)birthdayDisplay;
+ (enum BirthdayDisplay)birthdayDisplayFromString:(NSString*)string;

// Friendship approval methods
+ (NSString*)stringFromFriendshipApproval:(enum FriendshipApproval)friendshipApproval;
+ (enum FriendshipApproval)friendshipApprovalFromString:(NSString*)string;

// Comments approval methods
+ (NSString*)stringFromCommentsApproval:(enum CommentsApproval)commentsApproval;
+ (enum CommentsApproval)commentsApprovalFromString:(NSString*)string;

// Message privacy methods
+ (NSString*)stringFromMessagePrivacy:(enum MessagePrivacy)messagePrivacy;
+ (enum MessagePrivacy)messagePrivacyFromString:(NSString*)string;

// Email notification methods
+ (NSString*)stringFromEmailNotification:(enum EmailNotification)emailNotification;
+ (enum EmailNotification)emailNotificationFromString:(NSString*)string;

// Group member status methods
+ (NSString*)stringFromGroupMemberStatus:(enum GroupMemberStatus)groupMemberStatus;
+ (enum GroupMemberStatus)groupMemberStatusFromString:(NSString*)string;

@end
