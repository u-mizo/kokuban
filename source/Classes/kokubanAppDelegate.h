//
//  kokubanAppDelegate.h
//  kokuban
//
//  Created by 溝田 隆明 on 10/05/12.
//  Copyright conol 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class kokubanViewController;


@interface kokubanAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    kokubanViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet kokubanViewController *viewController;

@end

