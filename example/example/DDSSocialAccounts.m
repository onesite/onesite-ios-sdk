//
//  DDSSocialAccounts.m
//  example
//
//  Created by Jake Farrell on 1/23/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "DDSSocialAccounts.h"
#import "NSUserDefaults+Extensions.h"

static DDSSocialAccounts *_instance = nil;

@implementation DDSSocialAccounts

@synthesize data = _data;

+ (id)getInstance {
	
	if (!_instance)
		_instance = [[DDSSocialAccounts alloc] init];
	
	return _instance;
}

- (id)init
{
	self = [super init];
    if (self) {
		self.data = [[NSMutableArray alloc] init];
		
		[self addAccount:@"Facebook" icon:@"icn-social-facebook" url:nil active:YES nodeId:nil];
		[self addAccount:@"Twitter" icon:@"icn-social-twitter" url:nil active:YES nodeId:nil];
#warning Configure for your network.
//		[self addAccount:@"Your Network" icon:@"icn-social-onesite" url:@"example.com" active:YES nodeId:[NSNumber numberWithInt:1]];
		
	}
    return self;
}

- (void)dealloc
{
	[_data release];
	
	[super dealloc];
}

#pragma mark - Methods

- (void)addAccount:(NSString*)name icon:(NSString*)icon url:(NSString*)url active:(BOOL)active nodeId:(NSNumber*)nodeId 
{
	if (name) {					
		NSDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict setValue:name forKey:@"name"];
		[dict setValue:icon forKey:@"icon"];
		[dict setValue:url forKey:@"url"];
		[dict setValue:[NSNumber numberWithBool:active] forKey:@"active"]; // stores if they should post with or not
		[dict setValue:nodeId forKey:@"nodeId"];
		
		[self.data addObject:dict];
		[dict release];	
	}
}

- (BOOL)isEnabled:(NSUInteger)index
{
	NSDictionary *dict = [self.data objectAtIndex:index];
	
	if ([dict objectForKey:@"name"] == @"Facebook") {
		NSLog(@"Facebook enabled: %@", [NSUserDefaults isFacebookLoggedIn]?@"YES":@"NO");
		return [NSUserDefaults isFacebookLoggedIn];
	} else if ([dict objectForKey:@"name"] == @"Twitter") {
		NSLog(@"Twitter enabled: %@", [NSUserDefaults isTwitterLoggedIn]?@"YES":@"NO");
		return [NSUserDefaults isTwitterLoggedIn];
	} else {
		// ONEsite account
		if ([dict objectForKey:@"nodeId"]) {
			return [NSUserDefaults isOnesiteAccountEnabled:[dict objectForKey:@"nodeId"]];
		}
	}
	
	return NO;
}

- (BOOL)isActive:(NSString*)name
{
	for (NSMutableDictionary *item in self.data) {
		if ([[item objectForKey:@"name"] isEqualToString:name]) {
			return [[item objectForKey:@"active"] boolValue];
		}
	}
	
	return NO;
}

- (void)setValueForAccountByName:(NSString*)account key:(NSString*)key value:(id)value
{
	// loop through and find the account
	for (NSMutableDictionary *item in self.data) {
		if ([[item objectForKey:@"name"] isEqualToString:account]) {
			// Set the value for it
			[item setObject:value forKey:key];	
		}
	}
}

- (void)setValueForAccountByNodeId:(NSNumber*)nodeId key:(NSString*)key value:(id)value
{
	// loop through and find the account
	for (NSMutableDictionary *item in self.data) {
		if ([[item objectForKey:@"nodeId"] isEqualToNumber:nodeId]) {
			// Set the value for it
			[item setObject:value forKey:key];	
		}
	}
}

#pragma mark - NSMutableArray methods

- (NSUInteger)count
{
	return [self.data count];
}

- (id) objectAtIndex:(NSUInteger)index
{
	return [self.data objectAtIndex:index];
}

@end


