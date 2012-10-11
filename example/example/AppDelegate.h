//
//  AppDelegate.h
//  example
//
//  Created by Jake Farrell on 1/23/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>
{
	UIWindow *_window;
	UINavigationController *_navigationController;
	
	MainViewController *_mainController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, retain) UINavigationController *navigationController;
@property (strong, retain) MainViewController *mainController;

@end
