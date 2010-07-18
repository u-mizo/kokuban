//
//  SoundObj.h
//  tap_pattern
//
//  Created by takaaki mizota on 10/03/22.
//  Copyright 2010 conol.jp. All rights reserved.
//

#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/ExtendedAudioFile.h>

@interface SoundObj : NSObject {
	
	ALuint	_buffers[3];
	ALuint	_sources[3];
	
	ALCcontext* alContext;
	ALCdevice* device;
	
	BOOL isPlaying;
	BOOL wasInterrupted;
	UInt32 iPodIsPlaying;
}

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL wasInterrupted;
@property (nonatomic, assign) UInt32 iPodIsPlaying;

typedef ALvoid AL_APIENTRY	(*alBufferDataStaticProcPtr) (const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq);
ALvoid  alBufferDataStaticProc(const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq);

void* MyGetOpenALAudioData(CFURLRef inFileURL, ALsizei *outDataSize, ALenum *outDataFormat, ALsizei*	outSampleRate);


- (void) Sound_Start :(int) flg;
- (void) Sound_Stop :(int) flg;


@end
