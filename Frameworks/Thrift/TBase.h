//
//  TBase.h
//  ios-sdk
//
//  Created by Jake Farrell on 9/21/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TProtocol.h"

@interface TBase : NSObject

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

@end
