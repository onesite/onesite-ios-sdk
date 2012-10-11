//
//  NSURL+Extensions.h
//  onesite-ios-sdk
//
//  Created by Jake Farrell on 1/27/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Extensions)
// Append values from an NSDictionary to the NSURL query string
- (NSURL *)appendNSDictionaryToQueryParams:(NSDictionary *)params;
@end
