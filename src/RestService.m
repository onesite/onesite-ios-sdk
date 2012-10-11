//
//  RestService.m
//  onesite-ios-sdk
//
//  Created by Jake Farrell on 1/24/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "RestService.h"
#import "ASIFormDataRequest.h"
#import "NSURL+Extensions.h"

@implementation RestService

@synthesize debug = _debug;

- (id)init
{
	self = [super init];
	if (self) {
		[self setDebug:NO];
	}
	
	return self;
}

// Call designed to use delegate (block can be used with nil delegate)
- (void)requestUrl:(NSURL*)url params:(NSDictionary*)params delegate:(id<RestServiceDelegate>)delegate
{
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setRequestMethod:@"GET"];
	[request addRequestHeader:@"Accept" value:@"application/json"];

	if (params) {
		[request setURL:[url appendNSDictionaryToQueryParams:params]];
	}
	
	if (self.debug) {
		DELOG(@"URL: %@", [[request url] absoluteString]);
	}
	
	[request setCompletionBlock:^{
		if (self.debug) {
			DELOG(@"[REST] finished with code %d: %@", [request responseStatusCode], [request responseString]);
		}
		
		NSData *responseData = [request responseData];
		
		if (self.debug) {
			DELOG(@"%@", [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
		}
		
		if ([delegate respondsToSelector:@selector(restRequestDidFinisWithResult:)]) {
			[delegate restRequestDidFinisWithResult:responseData];
		} 
		
		if (completionBlock){
			completionBlock(responseData);
		}
	}];
	
	[request setFailedBlock:^{
		NSError *error = [request error];
		
		if (self.debug) {
			DELOG(@"[REST] request failed with code %d, %@", [request responseStatusCode], [request responseString]);
		}
		
		if ([delegate respondsToSelector:@selector(restRequestDidFailWithError:)]) {
			[delegate restRequestDidFailWithError:error];
		} 
		
		if (failureBlock){
			failureBlock(error);
		}
	}];
	
	[request setStartedBlock:^{
		if (self.debug) {
			DELOG(@"[REST] starting");
		}	
		
		if ([delegate respondsToSelector:@selector(restRequestDidStart:)]) {
			[delegate restRequestDidStart];
		}
		
		if (startedBlock){
			startedBlock();
		}
	}];
	
	[request startAsynchronous];
}

// Call using blocks
- (void)requestUrl:(NSURL*)url params:(NSDictionary*)params
{
	[self requestUrl:url params:params delegate:nil];
}

// Call designed to use delegate (block can be used with nil delegate)
//
// Convert images over to NSData using:
// - UIImageJPEGRepresentation(img, 0.8)
// - UIImagePNGRepresentation(img)
- (void)postDataToUrl:(NSURL*)url params:(NSDictionary*)params delegate:(id<RestServiceDelegate>)delegate
{
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setRequestMethod:@"POST"];
	
	if (params) {
		[params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {			
			if ([obj isKindOfClass:[NSData class]]) {
				[request addData:obj forKey:key];
			} else {
				[request addPostValue:obj forKey:key];
			}
		}];
	}
	
	if (self.debug) {
		DELOG(@"URL: %@", [[request url] absoluteString]);
	}
	
	[request setCompletionBlock:^{
		if (self.debug) {
			DELOG(@"[REST] finished with code %d: %@", [request responseStatusCode], [request responseString]);
		}
		
		NSData *responseData = [request responseData];
		
		if (self.debug) {
			DELOG(@"%@", [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
		}
		
		if ([delegate respondsToSelector:@selector(restRequestDidFinisWithResult:)]) {
			[delegate restRequestDidFinisWithResult:responseData];
		} 
		
		if (completionBlock){
			completionBlock(responseData);
		}
	}];
	
	[request setFailedBlock:^{
		NSError *error = [request error];
		
		if (self.debug) {
			DELOG(@"[REST] request failed with code %d, %@", [request responseStatusCode], [request responseString]);
		}
		
		if ([delegate respondsToSelector:@selector(restRequestDidFailWithError:)]) {
			[delegate restRequestDidFailWithError:error];
		} 
		
		if (failureBlock){
			failureBlock(error);
		}
	}];
	
	[request setStartedBlock:^{
		if (self.debug) {
			DELOG(@"[REST] starting");
		}	
		
		if ([delegate respondsToSelector:@selector(restRequestDidStart:)]) {
			[delegate restRequestDidStart];
		}
		
		if (startedBlock){
			startedBlock();
		}
	}];

	[request startAsynchronous];
}

// Call using blocks
//
// Convert images over to NSData using:
// - UIImageJPEGRepresentation(img, 0.8)
// - UIImagePNGRepresentation(img)
- (void)postDataToUrl:(NSURL*)url params:(NSDictionary*)params
{
	[self postDataToUrl:url params:params delegate:nil];
}

#pragma mark - Blocks

- (void)setStartedBlock:(RestServiceStarted)aStartedBlock
{
	[startedBlock release];
	startedBlock = [aStartedBlock copy];
}

- (void)setCompletionBlock:(RestServiceResult)aCompletionBlock
{
	[completionBlock release];
	completionBlock = [aCompletionBlock copy];
}

- (void)setFailedBlock:(RestServiceError)aFailedBlock
{
	[failureBlock release];
	failureBlock = [aFailedBlock copy];
}

@end
