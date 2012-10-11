//
//  OnesiteService.m
//  onesite-ios-sdk
//
//  Created by Jake Farrell on 1/27/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "OnesiteService.h"
#import "Configuration.h"
#import "RestService.h"

@implementation OnesiteService

@synthesize debug = _debug;
@synthesize serviceUrl = _serviceUrl;

- (id)init
{
	self = [super init];
	if (self) {
		[self setDebug:NO];
		[self setServiceUrl:[NSString stringWithFormat:@"%@://%@/",
						   [[Configuration getInstance] valueForKeyPath:@"Onesite.OnesiteURLScheme"], 
						   [[Configuration getInstance] valueForKeyPath:@"Onesite.OnesiteServiceURL"]
						   ]];
	}
	
	return self;
}

- (void)dealloc
{
	[_serviceUrl release], self.serviceUrl = nil;
	
	[super dealloc];
}

- (void)callRestServiceWithParameters:(NSDictionary*)params
					   resultCallback:(OnesiteServiceCallbackResultBlock)resultCallback
						errorCallback:(OnesiteServiceCallbackFailureBlock)errorCallback
{	
	RestService *svc = [[RestService alloc] init];
	[svc setDebug:self.debug];
	
	[svc setStartedBlock:^{ 
		if (self.debug) {
			DELOG(@"Started Onesite service request");
		}
	}];
	
	[svc setCompletionBlock:^(NSData *result) {
		if (self.debug) {
			DELOG(@"Completed Onesite service request");
		}
		
		resultCallback(result);
	}];
	
	[svc setFailedBlock:^(NSError *error){ 
		if (self.debug) {
			DELOG(@"Onesite service request Failed");
		}
		errorCallback(error);
	}];
	
    if ([[params objectForKey:@"method"] substringToIndex:1] != @"0") {
        if ([params objectForKey:@"accessToken"] == nil) {
            [params setValue:[[Configuration getInstance] valueForKeyPath:@"Onesite.OnesiteOAuthClientId"] forKey:@"client_id"];
            [params setValue:[[Configuration getInstance] valueForKeyPath:@"Onesite.OnesiteOAuthSecret"] forKey:@"client_secret"];
        }
    } else if ([params objectForKey:@"devkey"] == nil) {
        [params setValue:[[Configuration getInstance] valueForKeyPath:@"Onesite.OnesiteDevKey"]
                  forKey:@"devkey"
         ];
    }
    
	[svc requestUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.serviceUrl, [params objectForKey:@"method"]]] params:params];	
}


@end
