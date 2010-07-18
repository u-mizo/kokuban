//
//  CanvasView.h
//  kokuban
//
//  Created by 溝田 隆明 on 10/05/13.
//  Copyright 2010 conol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundObj.h"

@interface CanvasView : UIView {
	int mode;
	int point;
	CGContextRef	canvas;
	CGImageRef		lastImage;
	SoundObj *sounds;
}

@property (nonatomic, retain) SoundObj *sounds;

-(void) paintMode:(int)flg;
-(void) elaseMode;
-(void) painMode;

-(void) clear;
-(void) undo;

-(UIImage*)getImage:(int) flg;
-(UIImage*) makeImage:(int) direction;
-(void)setImage:(UIImage*)inImage;

@end
