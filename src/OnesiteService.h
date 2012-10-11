//
//  OnesiteService.h
//  onesite-ios-sdk
//
//  Created by Jake Farrell on 1/27/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <Foundation/Foundation.h>

#if NS_BLOCKS_AVAILABLE
typedef void (^OnesiteServiceCallbackResultBlock)(NSData *result);
typedef void (^OnesiteServiceCallbackFailureBlock)(NSError *error);
#endif

@interface OnesiteService : NSObject
{
	NSString *_serviceUrl;
	BOOL _debug;
	
}
@property(nonatomic, assign) BOOL debug;
@property(nonatomic, retain) NSString *serviceUrl;

- (void)callRestServiceWithParameters:(NSDictionary*)params
					   resultCallback:(OnesiteServiceCallbackResultBlock)resultCallback
						errorCallback:(OnesiteServiceCallbackFailureBlock)errorCallback;

@end
