//
//  NSURL+Extensions.m
//  onesite-ios-sdk
//
//  Created by Jake Farrell on 1/27/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "NSURL+Extensions.h"
#import "NSString+Extensions.h"

@implementation NSURL (Extensions)

- (NSURL *)appendNSDictionaryToQueryParams:(NSDictionary *)params
{
	NSMutableDictionary *newParamsDict = [[NSMutableDictionary alloc] initWithDictionary:params];
	
	NSMutableArray *parameters = [[NSMutableArray alloc] init];
	NSString *absoluteString = [self absoluteString];
	NSRange parameterRange = [absoluteString rangeOfString:@"?"];
	
	// Add any previous items from the url to the params dictionary
	if ([self query]) {
		if (parameterRange.location != NSNotFound) {
			parameterRange.length = [absoluteString length] - parameterRange.location;
			[parameters addObjectsFromArray:[[self query] componentsSeparatedByString:@"&"]];
			absoluteString = [absoluteString substringToIndex:parameterRange.location];
		}
		
		[parameters enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			NSArray *elements = [obj componentsSeparatedByString:@"="];
			NSString *key = [[elements objectAtIndex:0] urlEncode];
			NSString *val = [[elements objectAtIndex:1] urlEncode];
			
			[newParamsDict setObject:val forKey:key];
		}];
	}
	
	// Add all params to the url
	NSMutableString *newQueryString = [[NSMutableString alloc] initWithString:@""];
    
	[newParamsDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		
		if ([obj isKindOfClass:[NSString class]]) {
			[newQueryString appendFormat:@"&%@=%@", [key urlEncode], [obj urlEncode]];
		} else if ([obj isKindOfClass:[NSNumber class]]) {
			if (strcmp([obj objCType], @encode(BOOL)) == 0) {
				[newQueryString appendFormat:@"&%@=%d", [key urlEncode], (obj) ? 1 : 0];
			} else {
				[newQueryString appendFormat:@"&%@=%@", [key urlEncode], [[obj stringValue] urlEncode]];
			}
		} else {
			[newQueryString appendFormat:@"&%@=%@", [key urlEncode], [[obj stringValue] urlEncode]];
		}
	}];
	
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", absoluteString, newQueryString]];
}

@end
