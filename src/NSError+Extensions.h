//
//  NSError+Extensions.h
//  onesite-ios-sdk
//
//  Created by Janell Pechacek on 10/8/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Extensions)

+ (NSError*)errorWithDomain:(NSString*)domain code:(NSInteger)code message:(NSString*)message;

@end
