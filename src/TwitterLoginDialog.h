//
//  TwitterLoginDialog.h
//  sso
//
//  Created by Jake Farrell on 1/17/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterSessionDelegate.h"
#import "OAMutableURLRequest.h"
#import "OAServiceTicket.h"
#import "OAConsumer.h"
#import "OADataFetcher.h"
#import "OAToken.h"

@interface TwitterLoginDialog : UIViewController <UIWebViewDelegate>
{
	id <TwitterSessionDelegate> _delegate;
	
	BOOL pageLoaded;
	
	OAConsumer *_consumer;	
	OAToken *_storedRequestToken;
	OAToken *_storedAccessToken;	
}

@property (nonatomic, assign) id <TwitterSessionDelegate> delegate;

@property(nonatomic, retain)OAConsumer *consumer;
@property(nonatomic, retain)OAToken *storedRequestToken;
@property(nonatomic, retain)OAToken *storedAccessToken;

- (void) setupPage;

- (void) setupConsumer;
- (void) getRequestToken;
- (void) getAccessToken;


@end
