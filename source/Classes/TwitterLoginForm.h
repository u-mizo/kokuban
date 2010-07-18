//
//  TwitterLoginForm.h
//  kokuban
//
//  Created by 溝田 隆明 on 10/05/26.
//  Copyright 2010 conol. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol test

-(void) subWinClose;
-(void) touchNone;
-(void) standFlg;

@end


@interface TwitterLoginForm : UIViewController <UITextFieldDelegate> {
	
	UITextField *userName;
	UITextField *userPass;
	UITextField *message;
	UIButton *sendLogin;
	
	UIImage *setview;
	UIView *loading;
	
	UIImageView *resultImg;
	UIImage *rImage;
	
	id delegate;
	
	int cnt;
}


@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) UIImage *setview;

- (void) asyncUploadPhoto :(id)sender;
- (void) sending;

@end
