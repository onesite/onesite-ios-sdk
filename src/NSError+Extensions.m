//
//  NSError+Extensions.m
//  onesite-ios-sdk
//
//  Created by Janell Pechacek on 10/8/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "NSError+Extensions.h"

@implementation NSError (Extensions)

+ (NSError*)errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)message
{
    return [NSError errorWithDomain:domain
                               code:code
                           userInfo:[NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey]
            ];
}

@end
