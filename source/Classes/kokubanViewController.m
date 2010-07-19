//
//  kokubanViewController.m
//  kokuban
//
//  Created by 溝田 隆明 on 10/05/12.
//  Copyright conol 2010. All rights reserved.
//

#import "kokubanViewController.h"
#import "infoViewController.h"
#import "TwitterLoginForm.h"
#import "CanvasView.h"

#import "SoundObj.h"


@implementation kokubanViewController

@synthesize SoundSet;
@synthesize twitWindow;

#pragma mark -
#pragma mark 黒板消しモードに変更
-(void) elase :(id) sender {
	
	NSString *title1 = NSLocalizedString(@"elase_title1",@"comment1");
	NSString *title2 = NSLocalizedString(@"elase_title2",@"comment2");
	NSString *title3 = NSLocalizedString(@"elase_title3",@"Undo");
	
	sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:title3,title2,title1,nil];
	sheet.actionSheetStyle = UIBarStyleBlackTranslucent;
	CGRect rect = CGRectMake(90, 965, 1, 1);
	[sheet showFromRect:rect inView:self.view animated:YES];
	[sheet release];
}

#pragma mark -
#pragma mark 白チョークに変更
-(void) chook1 :(id) sender {
	[self Allstand:1];
	[canvasview paintMode:1];
}

#pragma mark -
#pragma mark 赤チョークに変更
-(void) chook2 :(id) sender {
	[self Allstand:2];
	[canvasview paintMode:2];
}

#pragma mark -
#pragma mark 青チョークに変更
-(void) chook3 :(id) sender {
	[self Allstand:3];
	[canvasview paintMode:3];
}

#pragma mark -
#pragma mark 黄色チョークに変更
-(void) chook4 :(id) sender {
	[self Allstand:4];
	[canvasview paintMode:4];
}

#pragma mark -
#pragma mark ペインモードに変更
-(void) crow :(id) sender {
	[self Allstand:5];
	[canvasview painMode];
}

#pragma mark -
#pragma mark チョークを元の位置に戻す
-(void) Allstand : (int) stand {
	switch (select_chook) {
		case 1:
			chook1.transform	= CGAffineTransformMakeRotation(0);
			break;
		case 2:
			chook2.transform	= CGAffineTransformMakeRotation(0);
			break;
		case 3:
			chook3.transform	= CGAffineTransformMakeRotation(0);
			break;
		case 4:
			chook4.transform	= CGAffineTransformMakeRotation(0);
			break;
		case 5:
			crower_on.alpha		= 0;
			crower.enabled		= YES;
			break;
		default:
			break;
	}
	switch (stand) {
		case 1:
			chook1.transform	= CGAffineTransformMakeRotation(10);
			break;
		case 2:
			chook2.transform	= CGAffineTransformMakeRotation(10);
			break;
		case 3:
			chook3.transform	= CGAffineTransformMakeRotation(10);
			break;
		case 4:
			chook4.transform	= CGAffineTransformMakeRotation(10);
			break;
		case 5:
			crower_on.alpha		= 100;
			crower.enabled		= NO;
			break;
		default:
			break;
	}

	select_chook = stand;
	
}

#pragma mark -
#pragma mark ナビゲーションを表示
-(void) showNavi :(id) sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.7f];
	showBtn.frame	= CGRectMake(showBtn.frame.origin.x, showBtn.frame.origin.y+showBtn.frame.size.height, showBtn.frame.size.width, showBtn.frame.size.height);
	bars.frame		= CGRectMake(0, bars.frame.origin.y-(bars.frame.size.height+20), bars.frame.size.width, bars.frame.size.height);
	
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark ナビゲーションを非表示
-(void) closeNavi :(id) sender {
	
	[self subWinClose];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.7f];
	showBtn.frame	= CGRectMake(showBtn.frame.origin.x, showBtn.frame.origin.y-showBtn.frame.size.height, showBtn.frame.size.width, showBtn.frame.size.height);
	bars.frame		= CGRectMake(0, bars.frame.origin.y+(bars.frame.size.height+20), bars.frame.size.width, bars.frame.size.height);
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark 保存アクションを表示
-(void) saveAction :(id) sender {
	NSString *string1 = NSLocalizedString(@"save_title1",@"comment3");
	NSString *string2 = NSLocalizedString(@"save_title2",@"comment4");
	NSString *string3 = NSLocalizedString(@"save_title3",@"comment5");
	
	if (twitWindow) {
		[twitWindow dismissPopoverAnimated:YES];
	}
	
	if(!action) {
		action = [[UIActionSheet alloc] initWithTitle:string1 delegate:self cancelButtonTitle:string2 destructiveButtonTitle:string3 otherButtonTitles:nil];
		action.actionSheetStyle = UIBarStyleBlackTranslucent;	// スタイル設定
		[action showFromBarButtonItem:sender animated:YES];		//　方法選択のアクションシートを開く
		[action release];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(actionSheet == action){
		if (buttonIndex == 1) {
			action = nil;
			return;
		}
		if (buttonIndex == 0) {
			UIImageWriteToSavedPhotosAlbum([canvasview makeImage:orien], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
		}
	}
	
	if(actionSheet == sheet){
		if (buttonIndex == 0) {
			[canvasview undo];
		}
		if (buttonIndex == 1) {
			[self Allstand:10];
			[canvasview elaseMode];
		}
		if (buttonIndex == 2) {
			[canvasview clear];
		}
	}
	
}

-(void) image:(UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo:(void *) contextInfo {
	
	NSString *string4 = NSLocalizedString(@"save_title4",@"comment6");
	NSString *string5 = NSLocalizedString(@"save_title5",@"comment7");
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string4 message:string5 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark twitter画面を表示
-(void) twit :(id) sender {
	
	[self actionWinClose];
	
	if (!twitWindow) {
		TwitterLoginForm *twc = [[TwitterLoginForm alloc] initWithNibName:nil bundle:nil];
		twc.setview		= [canvasview makeImage:orien];
		twc.delegate	= self;
		twitWindow		= [[UIPopoverController alloc] initWithContentViewController:twc];
		twitWindow.delegate = self;
		[twc release];
	}
	[twitWindow setPopoverContentSize:CGSizeMake(220, 190)];
	[twitWindow presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

//閉じる直前
//- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {}
//閉じた直後
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	if (!popWinflg) {
		twitWindow = nil;
	}
}

-(void) standFlg {
	popWinflg = YES;
}


#pragma mark -
#pragma mark サブウィンドウを非表示
-(void) subWinClose {
	if (twitWindow) {
		[twitWindow dismissPopoverAnimated:YES];
		twitWindow = nil;
		popWinflg = NO;
	}
	if (action) {
		[action dismissWithClickedButtonIndex:1 animated:YES];
		action = nil;
	}
}

-(void) actionWinClose {
	if (action) {
		[action dismissWithClickedButtonIndex:1 animated:YES];
		action = nil;
	}
}


#pragma mark -
#pragma mark インフォ画面を表示
-(void) doInfo :(id) sender {
	
	[self subWinClose];
	
	infoViewController *ivc = [[infoViewController alloc] initWithNibName:@"infoViewController" bundle:nil];
	[ivc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[self presentModalViewController:ivc animated:YES];
	[ivc release];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

//回転スタート時の向きに対してのメニュー位置変更
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation) FromInterfaceOrientation duration:(NSTimeInterval) duration {
	bars.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	if(FromInterfaceOrientation == UIInterfaceOrientationPortrait || FromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
		//NSLog(@"yoko1");
	} else {
		//NSLog(@"tate1");
	}
	canvasview.contentMode		= UIViewContentModeCenter;
	canvasview.clipsToBounds	= YES;
	canvasview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	showBtn.autoresizingMask	= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	elaser.autoresizingMask		= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	chook1.autoresizingMask		= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	chook2.autoresizingMask		= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	chook3.autoresizingMask		= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	chook4.autoresizingMask		= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	crower.autoresizingMask		= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	/*
	 1:UIInterfaceOrientationPortrait ホームボタンが下
	 2:UIInterfaceOrientationPortraitUpsideDown　ホームボタンが上
	 3:UIInterfaceOrientationLandscapeRight　ホームボタン右
	 4:UIInterfaceOrientationLandscapeLeft　ホームボタン左
	 */
	orien = FromInterfaceOrientation;
	
}

//回転アニメーション直前に呼び出し
- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
		[canvasview setFrame:CGRectMake(0, -128, 1024, 1024)];
	}
}

//回転スタート終了時の向きに対してのメニュー位置変更
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation) FromInterfaceOrientation {
	bars.autoresizingMask		= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	
	/*縦横調整用（未使用）
	if(FromInterfaceOrientation == UIInterfaceOrientationPortrait || FromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
		NSLog(@"yoko2");
		[canvasview setFrame:CGRectMake(0, -128, 1024, 1024)];
		
	} else {
		NSLog(@"tate2");
		[canvasview setFrame:CGRectMake(-128, 128, 1024, 1024)];
	}*/
	
}
#pragma mark -
#pragma mark 初期化
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	SoundSet	= [SoundObj new];
	orien		= UIInterfaceOrientationPortrait;
	
	popWinflg = NO;
	
	//背景画像
	UIImage *backImage		= [UIImage imageNamed:@"mat.jpg"];
	UIImageView *back		= [[[UIImageView alloc] initWithImage:backImage] autorelease];
	back.autoresizingMask	= UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	
	[[self view] addSubview:back];
	
	//キャンバス
	canvasview	= [[CanvasView alloc] initWithFrame:CGRectMake(0, 0, 512, 512)];
	canvasview.sounds = SoundSet;
	canvasview.transform	= CGAffineTransformMakeScale(2.0,2.0);
	
	CGRect moveFrame		= canvasview.frame;
	moveFrame.origin.x		= -128;
	moveFrame.origin.y		= 0;
	canvasview.frame		= moveFrame;
	[canvasview setOpaque:NO];
	[[self view] addSubview:canvasview];
	
	//チョークなど
	UIImage *elaseImage		= [UIImage imageNamed:@"elase.png"];
	elaser					= [UIButton buttonWithType:UIButtonTypeCustom];
	[elaser setImage:elaseImage forState:UIControlStateNormal];
	[elaser addTarget:self action:@selector(elase:) forControlEvents:UIControlEventTouchUpInside];
	elaser.frame = CGRectMake(10, 965, 160, 40);
	elaser.tag = 4;
	[[self view] addSubview:elaser];
	
	UIImage *chook1Image	= [UIImage imageNamed:@"chook1.png"];
	chook1					= [UIButton buttonWithType:UIButtonTypeCustom];
	[chook1 setImage:chook1Image forState:UIControlStateNormal];
	[chook1 addTarget:self action:@selector(chook1:) forControlEvents:UIControlEventTouchUpInside];
	chook1.frame = CGRectMake(184, 985, 88, 20);
	[[self view] addSubview:chook1];
	chook1.transform = CGAffineTransformMakeRotation(10);
	select_chook			= 1;
	
	UIImage *chook2Image	= [UIImage imageNamed:@"chook2.png"];
	chook2					= [UIButton buttonWithType:UIButtonTypeCustom];
	[chook2 setImage:chook2Image forState:UIControlStateNormal];
	[chook2 addTarget:self action:@selector(chook2:) forControlEvents:UIControlEventTouchUpInside];
	chook2.frame = CGRectMake(282, 985, 88, 20);
	[[self view] addSubview:chook2];
	
	UIImage *chook3Image	= [UIImage imageNamed:@"chook3.png"];
	chook3					= [UIButton buttonWithType:UIButtonTypeCustom];
	[chook3 setImage:chook3Image forState:UIControlStateNormal];
	[chook3 addTarget:self action:@selector(chook3:) forControlEvents:UIControlEventTouchUpInside];
	chook3.frame = CGRectMake(380, 985, 88, 20);
	[[self view] addSubview:chook3];
	
	UIImage *chook4Image	= [UIImage imageNamed:@"chook4.png"];
	chook4					= [UIButton buttonWithType:UIButtonTypeCustom];
	[chook4 setImage:chook4Image forState:UIControlStateNormal];
	[chook4 addTarget:self action:@selector(chook4:) forControlEvents:UIControlEventTouchUpInside];
	chook4.frame = CGRectMake(478, 985, 88, 20);
	[[self view] addSubview:chook4];
	
	UIImage *crowImage		= [UIImage imageNamed:@"crow.png"];
	crower					= [UIButton buttonWithType:UIButtonTypeCustom];
	[crower setImage:crowImage forState:UIControlStateNormal];
	[crower addTarget:self action:@selector(crow:) forControlEvents:UIControlEventTouchUpInside];
	crower.frame = CGRectMake(600, 960, 50, 40);
	[[self view] addSubview:crower];
	
	UIImage *select_Image	= [UIImage imageNamed:@"crow_select.png"];
	crower_on				= [UIButton buttonWithType:UIButtonTypeCustom];
	[crower_on setImage:select_Image forState:UIControlStateNormal];
	crower_on.frame = CGRectMake(600, 960, 50, 40);
	crower_on.alpha	= 0;
	[[self view] addSubview:crower_on];
	
	UIImage *showBtnImage	= [UIImage imageNamed:@"tab.png"];
	showBtn					= [UIButton buttonWithType:UIButtonTypeCustom];
	[showBtn setImage:showBtnImage forState:UIControlStateNormal];
	[showBtn addTarget:self action:@selector(showNavi:) forControlEvents:UIControlEventTouchUpInside];
	showBtn.frame = CGRectMake(680, 980, 60, 25);
	[[self view] addSubview:showBtn];
	
	//[[self view] bringSubviewToFront:bars];
	
	//ツールバー表示
	bars = [UIToolbar new];
	[bars setBarStyle:UIBarStyleBlackTranslucent];
	[bars sizeToFit];
	[bars setFrame:CGRectMake(0, 1024, 768, 50)];
	//UIColor *setColor	= HEXCOLOR(0xDDDDDD);
	//[bars setTintColor:setColor];
	
	UIImage *btnImage1	= [UIImage imageNamed:@"twit.png"];
	/*UIButton *twitBt	= [UIButton buttonWithType:UIButtonTypeCustom];
	[twitBt setImage:btnImage1 forState:UIControlStateNormal];
	[twitBt addTarget:self action:@selector(twit:) forControlEvents:UIControlEventTouchUpInside];
	twitBt.frame = CGRectMake(0, 0, 34, 32);*/
	
	UIImage *btnImage2	= [UIImage imageNamed:@"naviclose.png"];
	UIButton *nvclBt	= [UIButton buttonWithType:UIButtonTypeCustom];
	[nvclBt setImage:btnImage2 forState:UIControlStateNormal];
	[nvclBt addTarget:self action:@selector(closeNavi:) forControlEvents:UIControlEventTouchUpInside];
	nvclBt.frame = CGRectMake(0, 0, 34, 32);
	
	UIButton *infoBt	= [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoBt addTarget:self action:@selector(doInfo:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *nvclBtn	= [[UIBarButtonItem alloc] initWithCustomView:nvclBt];
	UIBarButtonItem *twitBtn	= [[UIBarButtonItem alloc] initWithImage:btnImage1 style:UIBarButtonItemStylePlain target:self action:@selector(twit:)];
	UIBarButtonItem *saveBtn	= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(saveAction:)];
	UIBarButtonItem *infoBtn	= [[UIBarButtonItem alloc] initWithCustomView:infoBt];
	UIBarButtonItem *spacer1	= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	UIBarButtonItem *spacer2	= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	spacer1.width = 50;
	NSArray *arr = [NSArray arrayWithObjects:nvclBtn,spacer1,saveBtn,spacer1,twitBtn,spacer2,infoBtn,nil];
	
	[twitBtn release];
	[saveBtn release];
	[infoBtn release];
	[nvclBtn release];
	[spacer1 release];
	[spacer2 release];
	
	[bars setItems:arr animated:YES];
	[[self view] addSubview:bars];
	[bars release];
	
}


#pragma mark -
#pragma mark 一時保存
-(void)store {
	[self writeImage:[canvasview getImage:0] toFile:@"CurtImage.png"];
}

- (BOOL)writeImage:(UIImage*)inImage toFile:(NSString*)fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) {
		return NO;
	}
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSData* data = UIImagePNGRepresentation(inImage);
    return [data writeToFile:appFile atomically:YES];
}

#pragma mark -
#pragma mark 一時ファイル呼び出し
-(void)restore {
	UIImage* image = [self imageFromFile:@"CurtImage.png"];
	if (image) {
		[canvasview setImage:image];
	}
}

- (UIImage*)imageFromFile:(NSString *)fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
	return [UIImage imageWithContentsOfFile:appFile];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	canvasview = nil;
	bars = nil;
	showBtn = nil;
	elaser = nil;
	chook1 = nil;
	chook2 = nil;
	chook3 = nil;
	chook4 = nil;
	crower = nil;
	crower_on = nil;
	
	sheet = nil;
	action = nil;
	
	SoundSet = nil;
	twitWindow = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
