//
//  Configuration.m
//  onesite-ios-sdk
//
//  Created by Jake Farrell on 1/19/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "Configuration.h"

static Configuration *_instance = nil;

@implementation Configuration

@synthesize data = _data;

+ (id)getInstance {
	
	if (!_instance)
		_instance = [[Configuration alloc] init];
	
	return _instance;
}

- (id)init
{
	self = [super init];
    if (self) {
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSString *configFileName = [path stringByAppendingPathComponent:@"onesite.plist"];
		[self setData:[[NSDictionary dictionaryWithContentsOfFile:configFileName] retain]];
	}
	
	return self;
}

- (void)dealloc
{
	[_data release], self.data = nil;
	[super dealloc];
}

- (void)printData
{
	for (id key in self.data) {			
		DELOG(@"%@ : %@", key, [self.data objectForKey:key]);			
	}
}

- (id)objectForKey:(id)key
{	
	return [self.data objectForKey:key];
}

- (id)valueForKeyPath:(NSString *)key
{
	return [self.data valueForKeyPath:key];
}

@end
