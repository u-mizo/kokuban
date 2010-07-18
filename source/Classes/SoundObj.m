//
//  SoundObj.m
//  黒板
//
//  Created by takaaki mizota on 10/03/22.
//  Copyright 2010 conol.jp. All rights reserved.
//  OpenAL用ライブラリ

#import "SoundObj.h"


#pragma mark -
#pragma mark openAL基本処理
ALvoid  alBufferDataStaticProc(const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq)
{
	static	alBufferDataStaticProcPtr	proc = NULL;
    
    if (proc == NULL) {
        proc = (alBufferDataStaticProcPtr) alcGetProcAddress(NULL, (const ALCchar*) "alBufferDataStatic");
    }
    
    if (proc)
        proc(bid, format, data, size, freq);
	
    return;
}


void* MyGetOpenALAudioData(CFURLRef inFileURL, ALsizei *outDataSize, ALenum *outDataFormat, ALsizei *outSampleRate)
{
	OSStatus							err = noErr;	
	SInt64								theFileLengthInFrames = 0;
	AudioStreamBasicDescription		theFileFormat;
	UInt32								thePropertySize = sizeof(theFileFormat);
	ExtAudioFileRef					extRef = NULL;
	void*								theData = NULL;
	AudioStreamBasicDescription		theOutputFormat;
	
	// Open a file with ExtAudioFileOpen()
	err = ExtAudioFileOpenURL(inFileURL, &extRef);
	if(err) { printf("MyGetOpenALAudioData: ExtAudioFileOpenURL FAILED, Error = %ld\n", err); goto Exit; }
	
	// Get the audio data format
	err = ExtAudioFileGetProperty(extRef, kExtAudioFileProperty_FileDataFormat, &thePropertySize, &theFileFormat);
	if(err) { printf("MyGetOpenALAudioData: ExtAudioFileGetProperty(kExtAudioFileProperty_FileDataFormat) FAILED, Error = %ld\n", err); goto Exit; }
	if (theFileFormat.mChannelsPerFrame > 2)  { printf("MyGetOpenALAudioData - Unsupported Format, channel count is greater than stereo\n"); goto Exit;}
	
	// Set the client format to 16 bit signed integer (native-endian) data
	// Maintain the channel count and sample rate of the original source format
	theOutputFormat.mSampleRate = theFileFormat.mSampleRate;
	theOutputFormat.mChannelsPerFrame = theFileFormat.mChannelsPerFrame;
	
	theOutputFormat.mFormatID = kAudioFormatLinearPCM;
	theOutputFormat.mBytesPerPacket = 2 * theOutputFormat.mChannelsPerFrame;
	theOutputFormat.mFramesPerPacket = 1;
	theOutputFormat.mBytesPerFrame = 2 * theOutputFormat.mChannelsPerFrame;
	theOutputFormat.mBitsPerChannel = 16;
	theOutputFormat.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
	
	// Set the desired client (output) data format
	err = ExtAudioFileSetProperty(extRef, kExtAudioFileProperty_ClientDataFormat, sizeof(theOutputFormat), &theOutputFormat);
	if(err) { printf("MyGetOpenALAudioData: ExtAudioFileSetProperty(kExtAudioFileProperty_ClientDataFormat) FAILED, Error = %ld\n", err); goto Exit; }
	
	// Get the total frame count
	thePropertySize = sizeof(theFileLengthInFrames);
	err = ExtAudioFileGetProperty(extRef, kExtAudioFileProperty_FileLengthFrames, &thePropertySize, &theFileLengthInFrames);
	if(err) { printf("MyGetOpenALAudioData: ExtAudioFileGetProperty(kExtAudioFileProperty_FileLengthFrames) FAILED, Error = %ld\n", err); goto Exit; }
	
	// Read all the data into memory
	UInt32		dataSize = theFileLengthInFrames * theOutputFormat.mBytesPerFrame;;
	theData = malloc(dataSize);
	if (theData)
	{
		AudioBufferList		theDataBuffer;
		theDataBuffer.mNumberBuffers = 1;
		theDataBuffer.mBuffers[0].mDataByteSize = dataSize;
		theDataBuffer.mBuffers[0].mNumberChannels = theOutputFormat.mChannelsPerFrame;
		theDataBuffer.mBuffers[0].mData = theData;
		
		// Read the data into an AudioBufferList
		err = ExtAudioFileRead(extRef, (UInt32*)&theFileLengthInFrames, &theDataBuffer);
		if(err == noErr)
		{
			// success
			*outDataSize = (ALsizei)dataSize;
			*outDataFormat = (theOutputFormat.mChannelsPerFrame > 1) ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
			*outSampleRate = (ALsizei)theOutputFormat.mSampleRate;
		}
		else 
		{ 
			// failure
			free (theData);
			theData = NULL; // make sure to return NULL
			printf("MyGetOpenALAudioData: ExtAudioFileRead FAILED, Error = %ld\n", err); goto Exit;
		}	
	}
	
Exit:
	// Dispose the ExtAudioFileRef, it is no longer needed
	if (extRef) ExtAudioFileDispose(extRef);
	return theData;
}




@implementation SoundObj

@synthesize isPlaying;
@synthesize wasInterrupted;
@synthesize iPodIsPlaying;


#pragma mark -
#pragma mark サウンドスタート
- (void) Sound_Start :(int) flg {
	alSourcePlay(_sources[flg]);
}

#pragma mark -
#pragma mark サウンドストップ
- (void) Sound_Stop :(int) flg {
	alSourceStop(_sources[flg]);
}


#pragma mark -
#pragma mark 初期化
- (id) init {
	if (self = [super init]) {
		
		AudioSessionInitialize(NULL, NULL, NULL, self);
		UInt32 category = kAudioSessionCategory_SoloAmbientSound;
		AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
		AudioSessionSetActive(true);
		
		device	= alcOpenDevice(NULL);
		alContext = alcCreateContext(device, 0);
		alcMakeContextCurrent(alContext);
		
		alGenBuffers(3, _buffers);
		alGenSources(3, _sources);
		
		int i;
		for(i=0;i<3;i++){
			NSString *fileName = nil;
			
			switch (i) {
				case 0: fileName = @"chook"; break;
				case 1: fileName = @"elase"; break;
				case 2: fileName = @"crow"; break;
			}
			
			NSString *path	= [[NSBundle mainBundle] pathForResource:fileName ofType:@"caf"];
			NSURL *url		= [NSURL fileURLWithPath:path];
			
			void*   audioData;
			ALsizei dataSize;
			ALenum  dataFormat;
			ALsizei sampleRate;
			audioData = MyGetOpenALAudioData((CFURLRef)url, &dataSize, &dataFormat, &sampleRate);
			
			// データをバッファに設定する
			alBufferDataStaticProc(_buffers[i], dataFormat, audioData, dataSize, sampleRate);
			
			// バッファをソースに設定する
			alSourcei(_sources[i], AL_BUFFER, _buffers[i]);
		}

    }
    return self;
	
}



#pragma mark -
#pragma mark メモリ解放
- (void)dealloc {
	
	[super dealloc];
}

@end
