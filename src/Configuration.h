//
//  Configuration.h
//  onesite-ios-sdk
//
//  Created by Jake Farrell on 1/19/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject
{
	NSDictionary *_data;
}

@property (nonatomic, retain) NSDictionary *data;

+(id)getInstance;
- (void)printData;
- (id)objectForKey:(id)key;
- (id)valueForKeyPath:(NSString *)key;

@end
