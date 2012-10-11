//
//  DDSSocialAccounts.h
//  example
//
//  Created by Jake Farrell on 1/23/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDSSocialAccounts : NSObject {
	NSMutableArray *_data;
	
	BOOL serviceCalled;
}

@property (nonatomic, retain) NSMutableArray *data;

+ (id) getInstance;

- (void) addAccount:(NSString*)name icon:(NSString*)icon url:(NSString*)url active:(BOOL)active nodeId:(NSNumber*)nodeId;
- (void) setValueForAccountByName:(NSString*)account key:(NSString*)key value:(id)value;
- (void) setValueForAccountByNodeId:(NSNumber*)nodeId key:(NSString*)key value:(id)value;

- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (BOOL) isEnabled:(NSUInteger)index;
- (BOOL)isActive:(NSString*)name;

@end
