//
//  FacebookWrapper.h
//  sso
//
//  Created by Jake Farrell on 1/17/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//
//  NOTE: For Facebook wrapper to work your app delegate will need to have the following 
//        to catch the custom schema request from safari back to your app for the given
//        Url types defined in the App-info.plist by adding a new row with the following:
//        "URL Types" > "URL Schemes" > fb + your_app_id
//
//
//  - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
//  {
//  	NSLog(@"handleOpenUrl called with %@", url.scheme);
//  	// Oauth Facebook request 
//  	if ([url.scheme hasPrefix:@"fb"]) {
//  		NSLog(@"Facebook URL");
//  		return [[[FacebookWrapper getInstance] facebook] handleOpenURL:url];
//      }
//  	return YES;
//  }


#import <Foundation/Foundation.h>
#import "Facebook.h"

@interface FacebookWrapper : NSObject<FBSessionDelegate, FBRequestDelegate>
{
  	Facebook *facebook;
}

@property (nonatomic, assign) Facebook *facebook;

+(id)getInstance;

- (void)login:(id<FBSessionDelegate>)delegate;
- (void)logout:(id<FBSessionDelegate>)delegate;
- (BOOL)isLoggedIn;

- (void)requestGraphPath:(NSString*)path delegate:(id) delegate;

@end
