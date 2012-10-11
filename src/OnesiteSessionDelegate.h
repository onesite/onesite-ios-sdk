//
//  OnesiteSessionDelegate.h
//  sso
//
//  Created by Jake Farrell on 1/17/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OnesiteSessionDelegate <NSObject>
- (void)onesiteDidLogin:(NSNumber*)nodeId;
- (void)onesiteDidFailWithNodeID:(NSNumber*)nodeId;
- (void)onesiteDidCancel;
@end
