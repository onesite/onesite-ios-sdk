//
//  AppDelegate.m
//  example
//
//  Created by Jake Farrell on 1/23/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "AppDelegate.h"
#import "FacebookWrapper.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize mainController = _mainController;


- (void)dealloc
{
	[_window release];
	[_navigationController release];
	[_mainController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.mainController = [[MainViewController alloc] init];
	
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.mainController];
	[[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed: @"navbar-notitle"] forBarMetrics:UIBarMetricsDefault];
	self.navigationController.delegate = self;
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self.window addSubview:self.navigationController.view];  
	[self.window makeKeyAndVisible];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

#pragma mark - UINavidationControllerDelegate

- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if ([viewController respondsToSelector:@selector(willAppearIn:)])
		[viewController performSelector:@selector(willAppearIn:) withObject:navController];
}

#pragma mark - URL Schema handler

/**
 * Used to catch schema requests for a given url type. Url types defined in the App-info.plist
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
	if ([url.scheme hasPrefix:@"fb"]) {
		NSLog(@"Facebook URL Request");
		return [[[FacebookWrapper getInstance] facebook] handleOpenURL:url];
    }
	
	return YES;
}

@end
