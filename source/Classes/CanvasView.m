//
//  CanvasView.m
//  kokuban
//
//  Created by 溝田 隆明 on 10/05/13.
//  Copyright 2010 conol. All rights reserved.
//

#import "CanvasView.h"

@implementation CanvasView

@synthesize sounds;


#define CHOLK_LINE	6.0
#define ELASE_LINE	15.0
#define CROW_LINE	1.0
#define CHOLK_POINT	6.0

#define RED_R 246 / 255.0f
#define RED_G 171 / 255.0f
#define RED_B 171 / 255.0f

#define BLUE_R 171 / 255.0f
#define BLUE_G 177 / 255.0f
#define BLUE_B 244 / 255.0f

#define YELLOW_R 238 / 255.0f
#define YELLOW_G 241 / 255.0f
#define YELLOW_B 174 / 255.0f


#pragma mark -
#pragma mark 描画領域作成
CGContextRef createCanvasContext(int width, int height)
{
	//RGBの描画領域作成。
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(
		NULL,		//初期化用データ。NULLなら初期化はシステムに任せる
		width,		//画像横ピクセル数
		height,		//縦
		8,			//RGB各要素は8ビット
		0,			//横１ラインの画像を定義するのに必要なバイト数。0はシステムに任せる。
		colorSpace, //RGB色空間。
		kCGImageAlphaPremultipliedLast);	//RGBの後ろにアルファ値(RGBはアルファ値が適用済み)

    CGColorSpaceRelease(colorSpace);
	return context;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
		[self setMultipleTouchEnabled:YES];
		mode	= 1;
		canvas	= createCanvasContext(frame.size.width, frame.size.height);

		/*色をつける（デバッグ用）
		CGContextSetRGBFillColor(canvas, 1.0, 0.0, 0.0, 1);
		CGContextFillRect(canvas, CGRectMake(0, 0, frame.size.width, frame.size.height));
		*/
		
    }
    return self;
}

#pragma mark -
#pragma mark タッチイベント
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	point = 0;
	CGImageRelease(lastImage);
	lastImage = CGBitmapContextCreateImage(canvas);
	
	if(mode>=1 && mode < 10){
		[sounds Sound_Start:0];
	} else if(mode==10){
		[sounds Sound_Start:1];
	} else if(mode==11){
		[sounds Sound_Start:2];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
		
	for (UITouch *touch in touches) {
		CGPoint before	= [touch previousLocationInView:self];
		CGPoint after	= [touch locationInView:self];
		
		CGContextSetBlendMode(canvas, kCGBlendModeNormal);
		//CGImageRelease(lastImage);
		//lastImage = CGBitmapContextCreateImage(canvas);
		
		if(mode==1){//paint mode1(white)
			CGContextSetLineWidth(canvas, CHOLK_LINE);
			CGContextSetRGBStrokeColor(canvas, 1.0, 1.0, 1.0, 1.0);
			CGContextSetLineCap(canvas, kCGLineCapRound);
		} else if(mode==2){//paint mode2(red)
			CGContextSetLineWidth(canvas, CHOLK_LINE);
			CGContextSetRGBStrokeColor(canvas, RED_R, RED_G, RED_B, 1.0);
			CGContextSetLineCap(canvas, kCGLineCapRound);
		} else if(mode==3){//paint mode3(blue)
			CGContextSetLineWidth(canvas, CHOLK_LINE);
			CGContextSetRGBStrokeColor(canvas,  BLUE_R, BLUE_G, BLUE_B, 1.0);
			CGContextSetLineCap(canvas, kCGLineCapRound);
		} else if(mode==4){//paint mode4(yellow)
			CGContextSetLineWidth(canvas, CHOLK_LINE);
			CGContextSetRGBStrokeColor(canvas,  YELLOW_R, YELLOW_G, YELLOW_B, 1.0);
			CGContextSetLineCap(canvas, kCGLineCapRound);
		} else if(mode==5){//paint mode5
		} else if(mode==6){//paint mode6
		} else if(mode==7){//paint mode7
		} else if(mode==8){//paint mode8
		} else if(mode==9){//paint mode9
		} else if(mode==10){//elase mode
			CGContextSetBlendMode(canvas, kCGBlendModeSourceIn);
			CGContextSetLineWidth(canvas, ELASE_LINE);
			CGContextSetRGBStrokeColor(canvas, 1.0, 1.0, 1.0, 0.05f);
			CGContextSetLineCap(canvas, kCGLineCapRound);
		} else if(mode==11){//pain mode
			CGContextSetBlendMode(canvas, kCGBlendModeLuminosity);
			CGContextSetLineWidth(canvas, CROW_LINE);
			CGContextSetRGBStrokeColor(canvas, 0, 0, 0, 0.1);
			CGContextSetLineCap(canvas, kCGLineCapSquare);
		}
		
		CGContextMoveToPoint(canvas, before.x, before.y);
		CGContextAddLineToPoint(canvas, after.x, after.y);
		CGContextStrokePath(canvas);
		
		[self setNeedsDisplay];
	}
	
	point = 1;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (mode != 10 && mode!=11 && point != 1) {
		
	for (UITouch *touch in touches) {
		CGPoint before	= [touch previousLocationInView:self];
		CGPoint after	= [touch locationInView:self];
		CGContextSetBlendMode(canvas, kCGBlendModeNormal);
		
		CGImageRelease(lastImage);
		lastImage = CGBitmapContextCreateImage(canvas);
		
		if (floor(fabs(before.x - after.x)) < CHOLK_POINT && floor(fabs(before.y - after.y)) < CHOLK_POINT) {
			CGRect rectEllipse = CGRectMake(before.x - CHOLK_POINT, before.y - CHOLK_POINT, CHOLK_POINT, CHOLK_POINT);
			switch (mode) {
				case 1:
					CGContextSetRGBFillColor(canvas, 1.0, 1.0, 1.0, 1.0);
					break;
				case 2:
					CGContextSetRGBFillColor(canvas, RED_R, RED_G, RED_B, 1.0);
					break;
				case 3:
					CGContextSetRGBFillColor(canvas, BLUE_R, BLUE_G, BLUE_B, 1.0);
					break;
				case 4:
					CGContextSetRGBFillColor(canvas, YELLOW_R, YELLOW_G, YELLOW_B, 1.0);
					break;
				default:
					break;
			}
			CGContextFillEllipseInRect(canvas, rectEllipse);
			[self setNeedsDisplay];
		}
	}
	point = 0;
	
	}
		
	if(mode>=1 && mode < 10){
		[sounds Sound_Stop:0];
	} else if(mode==10){
		[sounds Sound_Stop:1];
	} else if(mode==11){
		[sounds Sound_Stop:2];
	}
}


#pragma mark -
#pragma mark ペイントモード
-(void) paintMode :(int)flg {
	mode = flg;
}

#pragma mark -
#pragma mark 消しゴムモード
-(void) elaseMode {
	mode = 10;
}

#pragma mark -
#pragma mark ペインモード（つめ引っ掻き）
-(void) painMode {
	mode = 11;
}

#pragma mark -
#pragma mark 画面初期化
-(void) clear {
	[sounds Sound_Start:1];
	CGImageRelease(lastImage);
	lastImage = CGBitmapContextCreateImage(canvas);
	
	CGContextSetBlendMode(canvas, kCGBlendModeCopy);
	CGContextSetRGBFillColor(canvas, 0, 0, 0, 0);
	CGContextFillRect(canvas, CGRectMake(0, 0, 1024, 1024));
	[self setNeedsDisplay];
}

#pragma mark -
#pragma mark 画像合成して生成
-(UIImage*) makeImage:(int) direction {
	UIImage *back	= [UIImage imageNamed:@"mat.jpg"];
	UIImage *paint	= [self getImage:direction];
	UIImage *resized;
	
	int width	= 1024;
	int height	= 1024;
	
	if(direction == 1 || direction==2){
		width	= 768;
		height	= 1024;
	} else {
		width	= 1024;
		height	= 768;
	}
	
	UIGraphicsBeginImageContext(CGSizeMake(width, height));
	[paint drawInRect:CGRectMake(0, 0, width, height)];
	resized = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	unsigned char *bitmap = malloc(width * height * sizeof(unsigned char) * 4);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(bitmap,
													   width,
													   height,
													   8,
													   width * 4,
													   colorSpace,
													   kCGImageAlphaPremultipliedFirst);
	
	CGContextDrawImage(bitmapContext, CGRectMake(0, 0, width, height), back.CGImage);
	CGContextDrawImage(bitmapContext, CGRectMake(0, 0, width, height), resized.CGImage);
	CGImageRef imgRef	= CGBitmapContextCreateImage (bitmapContext);
	UIImage* image		= [UIImage imageWithCGImage:imgRef];
	CGImageRelease(imgRef);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	free(bitmap);
	return image;
}


#pragma mark -
#pragma mark 描画
- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGImageRef imgRef = CGBitmapContextCreateImage(canvas);
	CGRect r = self.bounds;
	CGContextDrawImage(context, CGRectMake(0, 0, r.size.width, r.size.height), imgRef); 
	CGImageRelease(imgRef);
}

#pragma mark -
#pragma mark 現在表示されている画像を取得
-(UIImage*)getImage:(int) flg {
	int width	= self.bounds.size.width;
	int height	= self.bounds.size.height;
	int hoseix	= 0;
	int hoseiy	= self.bounds.size.width;//[UIScreen mainScreen]
	
	if(flg==1 || flg==2){//縦向き
		width	= 768;
		height	= 1024;
		hoseix	= (height-width)/2;
		hoseiy	= height;
	} else if (flg==3 || flg==4) {//横向き
		width	= 1024;
		height	= 768;
		hoseix	= 0;
		hoseiy	= height+((width-height)/2);
	}

	CGImageRef imgRef = CGBitmapContextCreateImage(canvas);
	CGContextRef tmpContext = createCanvasContext(width, height);
	CGContextScaleCTM(tmpContext, 1, -1);
	CGContextTranslateCTM(tmpContext, -hoseix, -hoseiy);
	if (flg) {
		CGRect rect;
		rect.origin = CGPointMake(0,0);
		rect.size = CGSizeMake(1024, 1024);
		CGContextDrawImage(tmpContext, rect, imgRef);
	} else {
		CGContextDrawImage(tmpContext, self.bounds, imgRef);
	}
	
	CGImageRelease(imgRef);
	imgRef = CGBitmapContextCreateImage(tmpContext);
	UIImage* image = [UIImage imageWithCGImage:imgRef];
	CGImageRelease(imgRef);
	return image;
}

#pragma mark -
#pragma mark 画像をキャンバスへセットする
-(void)setImage:(UIImage*)inImage {
	CGContextSetBlendMode(canvas, kCGBlendModeCopy);
	CGContextSaveGState(canvas);
	CGContextScaleCTM(canvas, 1, -1);
	CGContextTranslateCTM(canvas, 0, -512);
	CGContextDrawImage(canvas, self.bounds, inImage.CGImage);
	CGContextRestoreGState(canvas);
	[self setNeedsDisplay];
}

#pragma mark -
#pragma mark 一つ前に戻す
-(void)undo {
	CGImageRef image = CGBitmapContextCreateImage(canvas);
	CGContextSetBlendMode(canvas, kCGBlendModeCopy);
	CGContextDrawImage(canvas, self.bounds, lastImage);
	CGImageRelease(lastImage);
	lastImage = image;
	[self setNeedsDisplay];
}

- (void)dealloc {
	CGImageRelease(lastImage);
	CGContextRelease(canvas);
    [super dealloc];
}


@end
