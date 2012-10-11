//
//  Onesite.m
//  onesite-ios-sdk
//
//  Created by Jake Farrell on 1/18/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "Onesite.h"

@implementation Onesite

#pragma mark Account status methods

+ (NSString*)stringFromAccountStatus:(enum AccountStatus)accountStatus
{
    switch (accountStatus) {
        case AccountStatus_PENDING:
            return @"pending";
        case AccountStatus_GOOD_STANDING:
            return @"good-standing";
        case AccountStatus_DELINQUENT:
            return @"delinquent";
        case AccountStatus_INACTIVE:
            return @"inactive";
        case AccountStatus_DISABLED:
            return @"disabled";
        case AccountStatus_DELETED:
            return @"deleted";
        default:
            return @"";
    }
}

+ (enum AccountStatus)accountStatusFromString:(NSString *)string
{
    if ([string isEqualToString:@"pending"]) {
        return AccountStatus_PENDING;
    } else if ([string isEqualToString:@"good-standing"]) {
        return AccountStatus_GOOD_STANDING;
    } else if ([string isEqualToString:@"delinquent"]) {
        return AccountStatus_DELINQUENT;
    } else if ([string isEqualToString:@"inactive"]) {
        return AccountStatus_INACTIVE;
    } else if ([string isEqualToString:@"disabled"]) {
        return AccountStatus_DISABLED;
    } else if ([string isEqualToString:@"deleted"]) {
        return AccountStatus_DELETED;
    } else {
        return AccountStatus_PENDING;
    }
}

#pragma mark Gender methods

+ (NSString*)stringFromGender:(enum Gender)gender
{
    switch (gender) {
        case Gender_MALE:
            return @"male";
        case Gender_FEMALE:
            return @"female";
        case Gender_UNSPECIFIED:
            return @"unspecified";
        default:
            return @"";
    }
}

+ (enum Gender)genderFromString:(NSString *)string
{
    if ([string isEqualToString:@"male"]) {
        return Gender_MALE;
    } else if ([string isEqualToString:@"female"]) {
        return Gender_FEMALE;
    } else if ([string isEqualToString:@"unspecified"]) {
        return Gender_UNSPECIFIED;
    } else {
        return Gender_UNSPECIFIED;
    }
}

#pragma mark Birthday display methods

+ (NSString*)stringFromBirthdayDisplay:(enum BirthdayDisplay)birthdayDisplay
{
    switch (birthdayDisplay) {
        case BirthdayDisplay_FULL:
            return @"full";
        case BirthdayDisplay_BIRTHDAY_ONLY:
            return @"birthday_only";
        case BirthdayDisplay_AGE_ONLY:
            return @"age_only";
        case BirthdayDisplay_OWNER:
            return @"private";
        case BirthdayDisplay_FRIENDS:
            return @"friends";
        default:
            return @"";
    }
}

+ (enum BirthdayDisplay)birthdayDisplayFromString:(NSString *)string
{
    if ([string isEqualToString:@"full"]) {
        return BirthdayDisplay_FULL;
    } else if ([string isEqualToString:@"birthday_only"]) {
        return BirthdayDisplay_BIRTHDAY_ONLY;
    } else if ([string isEqualToString:@"age_only"]) {
        return BirthdayDisplay_AGE_ONLY;
    } else if ([string isEqualToString:@"private"]) {
        return BirthdayDisplay_OWNER;
    } else if ([string isEqualToString:@"friends"]) {
        return BirthdayDisplay_FRIENDS;
    } else {
        return BirthdayDisplay_OWNER;
    }
}

+ (NSString*)stringFromFriendshipApproval:(enum FriendshipApproval)friendshipApproval
{
    switch (friendshipApproval) {
        case FriendshipApproval_AUTO_APPROVE:
            return @"auto-approve";
        case FriendshipApproval_MANUALLY:
            return @"manually";
        default:
            break;
    }
}

+ (enum FriendshipApproval)friendshipApprovalFromString:(NSString *)string
{
    if ([string isEqualToString:@"auto-approve"]) {
        return FriendshipApproval_AUTO_APPROVE;
    } else if ([string isEqualToString:@"manually"]) {
        return FriendshipApproval_MANUALLY;
    } else {
        return FriendshipApproval_MANUALLY;
    }
}

+ (NSString*)stringFromCommentsApproval:(enum CommentsApproval)commentsApproval
{
    switch (commentsApproval) {
        case CommentsApproval_AUTO_APPROVE_ALL:
            return @"auto-approve-all";
        case CommentsApproval_AUTO_APPROVE_FRIENDS_ONLY:
            return @"auto-approve-friends-only";
        case CommentsApproval_MANUALLY:
            return @"manually";
        default:
            break;
    }
}

+ (enum CommentsApproval)commentsApprovalFromString:(NSString *)string
{
    if ([string isEqualToString:@"auto-approve-all"]) {
        return CommentsApproval_AUTO_APPROVE_ALL;
    } else if ([string isEqualToString:@"auto-approve-friends-only"]) {
        return CommentsApproval_AUTO_APPROVE_FRIENDS_ONLY;
    } else if ([string isEqualToString:@"manually"]) {
        return CommentsApproval_MANUALLY;
    } else {
        return CommentsApproval_MANUALLY;
    }
}

+ (NSString*)stringFromMessagePrivacy:(enum MessagePrivacy)messagePrivacy
{
    switch (messagePrivacy) {
        case MessagePrivacy_ALLOW_ALL:
            return @"allow-all";
        case MessagePrivacy_FRIENDS_ONLY:
            return @"friends-only";
        default:
            break;
    }
}

+ (enum MessagePrivacy)messagePrivacyFromString:(NSString *)string
{
    if ([string isEqualToString:@"allow-all"]) {
        return MessagePrivacy_ALLOW_ALL;
    } else if ([string isEqualToString:@"friends-only"]) {
        return MessagePrivacy_FRIENDS_ONLY;
    } else {
        return MessagePrivacy_FRIENDS_ONLY;
    }
}

#pragma mark Email notification methods

+ (NSString*)stringFromEmailNotification:(enum EmailNotification)emailNotification
{
    switch (emailNotification) {
        case EmailNotification_NONE:
            return @"none";
        case EmailNotification_DAILY:
            return @"daily";
        case EmailNotification_WEEKLY:
            return @"weekly";
        case EmailNotification_ONGOING:
            return @"ongoing";
        default:
            break;
    }
}

+ (enum EmailNotification)emailNotificationFromString:(NSString *)string
{
    if ([string isEqualToString:@"none"]) {
        return EmailNotification_NONE;
    } else if ([string isEqualToString:@"daily"]) {
        return EmailNotification_DAILY;
    } else if ([string isEqualToString:@"weekly"]) {
        return EmailNotification_WEEKLY;
    } else if ([string isEqualToString:@"ongoing"]) {
        return EmailNotification_ONGOING;
    } else {
        return EmailNotification_ONGOING;
    }
}

#pragma mark Group member status methods

+ (NSString*)stringFromGroupMemberStatus:(enum GroupMemberStatus)groupMemberStatus
{
    switch (groupMemberStatus) {
        case GroupMemberStatus_PENDING:
            return @"pending";
        case GroupMemberStatus_MEMBER:
            return @"member";
        case GroupMemberStatus_MODERATOR:
            return @"moderator";
        case GroupMemberStatus_OWNER:
            return @"owner";
        case GroupMemberStatus_INVITED:
            return @"invited";
        case GroupMemberStatus_BANNED:
            return @"banned";
        default:
            break;
    }
}

+ (enum GroupMemberStatus)groupMemberStatusFromString:(NSString *)string
{
    if ([string isEqualToString:@"pending"]) {
        return GroupMemberStatus_PENDING;
    } else if ([string isEqualToString:@"member"]) {
        return GroupMemberStatus_MEMBER;
    } else if ([string isEqualToString:@"moderator"]) {
        return GroupMemberStatus_MODERATOR;
    } else if ([string isEqualToString:@"owner"]) {
        return GroupMemberStatus_OWNER;
    } else if ([string isEqualToString:@"invited"]) {
        return GroupMemberStatus_INVITED;
    } else if ([string isEqualToString:@"banned"]) {
        return GroupMemberStatus_BANNED;
    } else {
        return GroupMemberStatus_PENDING;
    }
}

@end
