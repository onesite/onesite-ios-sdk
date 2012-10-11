//
//  RestServiceDelegate.h
//  onesite-ios-sdk
//
//  Created by Jake Farrell on 1/24/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RestServiceDelegate <NSObject>
- (void)restRequestDidStart;
- (void)restRequestDidFinisWithResult:(NSData*)result;
- (void)restRequestDidFailWithError:(NSError*)error;
@end