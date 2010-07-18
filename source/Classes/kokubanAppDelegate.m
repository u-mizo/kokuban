//
//  kokubanAppDelegate.m
//  kokuban
//
//  Created by 溝田 隆明 on 10/05/12.
//  Copyright conol 2010. All rights reserved.
//

#import "kokubanAppDelegate.h"
#import "kokubanViewController.h"


@implementation kokubanAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
	
    [window makeKeyAndVisible];
	[viewController restore];
	
	return YES;
}

//	終了時に画像を保存する。
- (void)applicationWillTerminate:(UIApplication *)application {
	[viewController store];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
