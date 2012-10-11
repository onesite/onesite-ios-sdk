//
//  NSString+Extensions.m
//  onesite-ios-sdk
//
//  Created by Jake Farrell on 1/26/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

- (NSString *)urlEncode
{
    return (NSString*)CFURLCreateStringByAddingPercentEscapes(
                nil,
                (CFStringRef)self,
                nil,
                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                kCFStringEncodingUTF8
            );
}

- (NSString *)urlDecode
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
