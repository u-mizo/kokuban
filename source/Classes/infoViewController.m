    //
//  infoViewController.m
//  kokuban
//
//  Created by 溝田 隆明 on 10/05/12.
//  Copyright 2010 conol. All rights reserved.
//

#import "infoViewController.h"

@implementation infoViewController

@synthesize backBtn;
@synthesize conolBtn;

-(IBAction) doBack:(id) sender {
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

-(IBAction) goConol:(id) sender {
	NSURL *url = [NSURL URLWithString:@"http://conol.jp/"];
	UIApplication *app = [UIApplication sharedApplication];
	if ([app canOpenURL:url]) {
		[app openURL:url];
	} else {
		NSString *string6 = NSLocalizedString(@"error_title1",@"comment8");
		NSString *string7 = NSLocalizedString(@"error_title2",@"comment9");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string6 message:string7 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation) FromInterfaceOrientation {
	//backBtn.autoresizingMask	=  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	//conolBtn.autoresizingMask	=  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

	if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
		[backBtn setFrame:CGRectMake(325, 710, 79, 28)];
	} else {
		[backBtn setFrame:CGRectMake(195, 930, 79, 28)];
	}

	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	conolBtn = nil;
	backBtn = nil;
}


- (void)dealloc {
    [super dealloc];
}





@end
