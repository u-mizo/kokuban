//
//  kokubanViewController.h
//  kokuban
//
//  Created by 溝田 隆明 on 10/05/12.
//  Copyright conol 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CanvasView.h"
#import "SoundObj.h"


//Color Set
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0];


@interface kokubanViewController : UIViewController<UIActionSheetDelegate,UIPopoverControllerDelegate> {
	CanvasView*	canvasview;
	
	UIView *lockMat;
	
	UIToolbar *bars;
	UIButton *showBtn;
	UIButton *elaser;
	UIButton *chook1;
	UIButton *chook2;
	UIButton *chook3;
	UIButton *chook4;
	UIButton *crower;
	UIButton *crower_on;
	
	UIActionSheet *sheet;
	UIActionSheet *action;
	
	UIPopoverController *twitWindow;
	
	UIInterfaceOrientation orien;
	int num;
	int select_chook;
	BOOL popWinflg;
	
	SoundObj *SoundSet;
}

@property (nonatomic, retain) SoundObj *SoundSet;
@property (nonatomic, retain) UIPopoverController *twitWindow;

-(void) twit :(id) sender;
-(void) doInfo:(id) sender;
-(void) elase :(id) sender;
-(void) Allstand : (int) stand;
-(void) subWinClose;
-(void) actionWinClose;

-(BOOL)writeImage:(UIImage*)inImage toFile:(NSString*)fileName;
-(UIImage*)imageFromFile:(NSString *)fileName;

-(void)store;
-(void)restore;


@end