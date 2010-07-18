//
//  TwitterLoginForm.m
//  kokuban
//
//  Created by 溝田 隆明 on 10/05/26.
//  Copyright 2010 conol. All rights reserved.
//

#import "TwitterLoginForm.h"
//#import "XAuthTwitterEngine.h"
//#import "UIAlertView+Helper.h"
#import "ASIFormDataRequest.h"
#import "XPathQuery.h"

@implementation TwitterLoginForm

//@synthesize twitterEngine;
@synthesize setview;
@synthesize delegate;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/**/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	cnt = 0;
	
	NSString *string1 = NSLocalizedString(@"Twitter_title1",@"userID");
	NSString *string2 = NSLocalizedString(@"Twitter_title2",@"Password");
	NSString *string3 = NSLocalizedString(@"Twitter_title3",@"Message");
	NSString *string4 = NSLocalizedString(@"Twitter_title4",@"send");
	
	UIImage *backImage		= [UIImage imageNamed:@"twitter_back.jpg"];
	UIImageView *back		= [[[UIImageView alloc] initWithImage:backImage] autorelease];
	
	userName				= [[[UITextField alloc] init] autorelease];
	userName.frame			= CGRectMake(10, 20, 200, 30);
	userName.borderStyle	= UITextBorderStyleRoundedRect;
	userName.keyboardType	= UIKeyboardTypeASCIICapable;
	userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
	userName.autocorrectionType = UITextAutocorrectionTypeNo;
	userName.returnKeyType	= UIReturnKeyNext;
	userName.tag			= 1;
	
	NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
	if(userID.length>0){
		[userName setText:userID];
	} else {
		userName.placeholder= string1;
	}
	[userName setDelegate:self];
	
	userPass				= [[[UITextField alloc] init] autorelease];
	userPass.frame			= CGRectMake(10, 60, 200, 30);
	userPass.borderStyle	= UITextBorderStyleRoundedRect;
	userPass.secureTextEntry= YES;
	userPass.returnKeyType	= UIReturnKeyNext;
	userPass.tag			= 2;
	
	NSString *pass = [[NSUserDefaults standardUserDefaults] stringForKey:@"pass"];
	if(pass.length>0){
		[userPass setText:pass];
	} else {
		userPass.placeholder= string2;
	}
	[userPass setDelegate:self];

	message					= [[[UITextField alloc] init] autorelease];
	message.frame			= CGRectMake(10, 100, 200, 30);
	message.borderStyle		= UITextBorderStyleRoundedRect;
	message.keyboardType	= UIKeyboardTypeASCIICapable;
	message.placeholder		= string3;
	message.returnKeyType	= UIReturnKeyNext;
	message.tag				= 3;
	[message setDelegate:self];
	
	sendLogin				= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[sendLogin setTitle:string4 forState:UIControlStateNormal];
	sendLogin.frame			= CGRectMake(10, 140, 200, 40);
	[sendLogin addTarget:self action:@selector(asyncUploadPhoto:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:back];
	[self.view addSubview:userName];
	[self.view addSubview:userPass];
	[self.view addSubview:message];
	[self.view addSubview:sendLogin];
}

#pragma mark -
#pragma mark コメント部分の文字数制限
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	BOOL change = NO;
	
	if (textField == userName || textField == userPass) {
		change = YES;
	}
	
	if(textField == message){
		if(range.location + range.length + [string length] < 130){
			change = YES;
		}
	}
	return change;
}

#pragma mark -
#pragma mark リターンボタンが押されたら
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	BOOL change = NO;
	
	if(textField == message){
		[message resignFirstResponder];
		change = YES;
	}
	
	if (textField == userPass) {
		[message becomeFirstResponder];
		change = YES;
	}
	if (textField == userName) {
		[userPass becomeFirstResponder];
		change = YES;
	}
		
	return change;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
	return YES;
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField {
	return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
}


- (void)asyncUploadPhoto :(id)sender {
	[[self delegate] standFlg];
	[self sending];
}

- (void) sending {
    
	NSString *username	= userName.text;
	NSString *password	= userPass.text;
	NSString *messages	= message.text;
	NSString *mes		= [NSString stringWithFormat:@"%@ #chalkboard",messages];
	
	if (username.length<3 && password.length<3) {
		return;
	}
	
	//非同期通信用
	//NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"http://twitpic.com/api/uploadAndPost"];//http://conol.jp/test/test.php
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    NSData* twitpicImage	= UIImagePNGRepresentation(setview);
	
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:password forKey:@"password"];
    [request setData:twitpicImage forKey:@"media"];
	[request setPostValue:mes forKey:@"message"];
	
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    
    // 非同期の画像アップロード開始
	//[queue addOperation:request];
	
	if (cnt==0) {
		loading = [[UIView alloc] initWithFrame:CGRectMake(0, 190, 220, 190)];
		loading.backgroundColor = [UIColor blackColor];
		loading.alpha = 0.0f;
	
		UIActivityIndicatorView *atv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
		[atv setCenter:CGPointMake(110.0f, 95.0f)];
		atv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		atv.tag = 100;
	
		[[self view] addSubview:loading];
		[loading addSubview:atv];
		[atv startAnimating];
		[loading release];
		[atv release];
	
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0f];
		CGPoint pos = [loading center];
		pos = CGPointMake(pos.x, pos.y-190.0f);
		[loading setCenter:pos];
		[loading setAlpha:0.7f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView commitAnimations];
	}
	
	[request start];
	
}
- (void)requestDone:(ASIFormDataRequest *)request {
	
	[[NSUserDefaults standardUserDefaults] setObject:userName.text forKey:@"userID"];
	[[NSUserDefaults standardUserDefaults] setObject:userPass.text forKey:@"pass"];
	
	NSData *response = [request responseData];
    //NSLog(@"response is %@", [request responseString]);
	NSArray *results = PerformXMLXPathQuery(response, @"/rsp/@status");
    if ([results count] != 0) {
		
		[message resignFirstResponder];
		
		UIImage *btnImage	= [UIImage imageNamed:@"closeBtn.png"];
		UIButton *closeBtn	= [UIButton buttonWithType:UIButtonTypeCustom];
		[closeBtn setImage:btnImage forState:UIControlStateNormal];
		closeBtn.frame = CGRectMake(90, 150, 41, 41);
		
        NSString *stat = [[results objectAtIndex:0] objectForKey:@"nodeContent"];
        if ([stat isEqualToString:@"ok"]) {
			[closeBtn addTarget:self action:@selector(closeWin:) forControlEvents:UIControlEventTouchUpInside];
			rImage	= [UIImage imageNamed:@"sendok.png"];
			
			resultImg	= [[[UIImageView alloc] initWithImage:rImage] autorelease];
			resultImg.frame = CGRectMake(40, 5, 140, 140);
			
			UIActivityIndicatorView *atv = (UIActivityIndicatorView *)[[loading superview] viewWithTag:100];
			[atv stopAnimating];
			
			[loading addSubview:resultImg];
			[loading addSubview:closeBtn];
			
			[request release];
		} else {
			cnt++;
			[self sending];
        }
	}
}

- (void)requestWentWrong:(ASIFormDataRequest *)request {
	
	if (cnt<5) {
		cnt++;
		[self sending];
	} else {
		NSError *error = [request error];
		NSLog(@"error is %@", [error localizedDescription]);
	
		UIActivityIndicatorView *atv = (UIActivityIndicatorView *)[[loading superview] viewWithTag:100];
		[atv stopAnimating];
	
		UIImage *btnImage	= [UIImage imageNamed:@"closeBtn.png"];
		UIButton *closeBtn	= [UIButton buttonWithType:UIButtonTypeCustom];
		[closeBtn setImage:btnImage forState:UIControlStateNormal];
		closeBtn.frame = CGRectMake(90, 150, 41, 41);
	
		[closeBtn addTarget:self action:@selector(closeMat:) forControlEvents:UIControlEventTouchUpInside];
		rImage			= [UIImage imageNamed:@"sendng.png"];
		resultImg		= [[[UIImageView alloc] initWithImage:rImage] autorelease];
		resultImg.frame = CGRectMake(40, 5, 140, 140);
	
		[loading addSubview:resultImg];
		[loading addSubview:closeBtn];
	
		[request release];
	}
}


-(void) closeWin :(id) sender {
	[[self delegate] subWinClose];
	[loading setAlpha:0.0f];
	
}

-(void) closeMat :(id) sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0f];
	CGPoint pos = [loading center];
	pos = CGPointMake(pos.x, pos.y+190.0f);
	[loading setCenter:pos];
	[loading setAlpha:0.0f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView commitAnimations];
}


-(id) delegate {
	return delegate;
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	userName = nil;
	userPass = nil;
	message	= nil;
	sendLogin = nil;
	setview	= nil;
	loading = nil;
	resultImg = nil;
	rImage = nil;
	
}


- (void)dealloc {
    [super dealloc];
}


@end
