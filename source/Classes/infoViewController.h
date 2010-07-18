//
//  infoViewController.h
//  kokuban
//
//  Created by 溝田 隆明 on 10/05/12.
//  Copyright 2010 conol. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface infoViewController : UIViewController {
	UIButton *conolBtn;
	UIButton *backBtn;
}

-(IBAction) doBack:(id) sender;
-(IBAction) goConol:(id) sender;

@property(nonatomic ,retain) IBOutlet UIButton *conolBtn;
@property(nonatomic ,retain) IBOutlet UIButton *backBtn;

@end
