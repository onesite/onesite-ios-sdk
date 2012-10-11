//
//  RestService.h
//  onesite-ios-sdk
//
//  Created by Jake Farrell on 1/24/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestServiceDelegate.h"

#if NS_BLOCKS_AVAILABLE
typedef void (^RestServiceStarted)(void);
typedef void (^RestServiceResult)(NSData *result);
typedef void (^RestServiceError)(NSError *error);
#endif

@interface RestService : NSObject
{
	BOOL _debug;
	
	//block to execute when request starts
	RestServiceStarted startedBlock;
	
	//block to execute when request completes successfully
	RestServiceResult completionBlock;
	
	//block to execute when request fails
	RestServiceError failureBlock;
}

@property (nonatomic, assign) BOOL debug;

// Use with blocks
- (void)requestUrl:(NSURL*)url params:(NSDictionary*)params;
- (void)postDataToUrl:(NSURL*)url params:(NSDictionary*)params;

// Use with delegate
- (void)requestUrl:(NSURL*)url params:(NSDictionary*)params delegate:(id<RestServiceDelegate>)delegate;
- (void)postDataToUrl:(NSURL*)url params:(NSDictionary*)params delegate:(id<RestServiceDelegate>)delegate;



// Blocks
- (void)setStartedBlock:(RestServiceStarted)aStartedBlock;
- (void)setCompletionBlock:(RestServiceResult)aCompletionBlock;
- (void)setFailedBlock:(RestServiceError)aFailedBlock;

@end
