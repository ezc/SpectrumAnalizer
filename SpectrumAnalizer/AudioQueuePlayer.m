//
//  AudioQueuePlayer.m
//  SpectrumAnalizer
//
//  Created by Evgeniy Kirpichenko on 1/10/13.
//  Copyright (c) 2013 Evgeniy Kirpichenko. All rights reserved.
//

#import "AudioQueuePlayer.h"
#import "AudioFileHelper.h"

static const UInt16 kDefaultBufferSize = 48000;
static const UInt16 kNumberOfBuffers = 3;

#define ThrowIfFails(status, message) if(status != noErr) {[NSException raise:(message) format:@"Error code %ld",status];}

@interface AudioQueuePlayer ()
@end

@implementation AudioQueuePlayer

- (id) initWithFilePath:(NSString *) filePath
{
    if (self = [super init]) {
        [self prepareAudioFileData:filePath];
        
        mBuffers = malloc(sizeof(AudioQueueBufferRef) * kNumberOfBuffers);
    }
    return self;
}

- (void) dealloc
{
    free(mBuffers);
    
    [super dealloc];
}

#pragma mark -
#pragma mark manage playing

- (void) play
{
    
}

- (void) pause
{
    
}

- (void) stop
{
    audioFileClose(audioFile);
    audioFile = 0;
}

#pragma mark -
#pragma mark manage queue

- (void) setupQueue
{
    OSStatus status =  AudioQueueNewOutput(&dataFormat,
                                           renderBufferCallback,
                                           self,
                                           CFRunLoopGetCurrent(),
                                           kCFRunLoopCommonModes,
                                           0,
                                           &audioQueue);
    if (status != noErr) {
        NSLog(@"AudioQueueNewOutput failed");
    }
    [self setupMagicalCookie];
    [self setupChannelsLayout];
    
    status = AudioQueueAddPropertyListener(audioQueue, kAudioQueueProperty_IsRunning, isRunningListener, self);
    ThrowIfFails(status, "Can't add property listener");

	bool isFormatVBR = (dataFormat.mBytesPerPacket == 0 || dataFormat.mFramesPerPacket == 0);
	for (int i = 0; i < kNumberOfBuffers; ++i) {
        status = AudioQueueAllocateBufferWithPacketDescriptions(audioQueue, <#UInt32 inBufferByteSize#>, <#UInt32 inNumberPacketDescriptions#>, <#AudioQueueBufferRef *outBuffer#>)
		XThrowIfError(AudioQueueAllocateBufferWithPacketDescriptions(mQueue, bufferByteSize, (isFormatVBR ? mNumPacketsToRead : 0), &mBuffers[i]), "AudioQueueAllocateBuffer failed");
	}
    
	// set the volume of the queue
	XThrowIfError (AudioQueueSetParameter(mQueue, kAudioQueueParam_Volume, 1.0), "set queue volume");
	
	mIsInitialized = true;


}

- (void) setupMagicalCookie
{
    UInt32 size = 0;
	OSStatus status = AudioFileGetPropertyInfo (audioFile, kAudioFilePropertyMagicCookieData, &size, NULL);
	if (status == noErr && size > 0) {
		char* cookie = malloc(size * sizeof(char));
		
        status = AudioFileGetProperty (audioFile, kAudioFilePropertyMagicCookieData, &size, cookie);
        if (status != noErr) {
            free(cookie);
            ThrowIfFails(status, @"Can't get cookie from file");
        }
        
		status = AudioQueueSetProperty(audioQueue, kAudioQueueProperty_MagicCookie, cookie, size);
        if (status != noErr) {
            free(cookie);
            ThrowIfFails(status, @"Can't set cookie on queue");
        }        
        
        free(cookie);
	}
}

- (void) setupChannelsLayout
{
    UInt32 size = 0;
    OSStatus status = AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyChannelLayout, &size, NULL);
	if (status == noErr && size > 0) {
		AudioChannelLayout layout;
        
        status = AudioFileGetProperty(audioFile, kAudioFilePropertyChannelLayout, &size, &layout);
        ThrowIfFails(status, @"Can't read channel layout property");
        
        status = AudioQueueSetProperty(audioQueue, kAudioQueueProperty_ChannelLayout, &layout, size);
        ThrowIfFails(status, @"Can't set channel layout property");
    }
}

void renderBufferCallback (void *inUserData,
                           AudioQueueRef inAQ,
                           AudioQueueBufferRef inCompleteAQBuffer)
{
    
}


- (void) prepareAudioFileData:(NSString *) filePath
{
    NSURL *url = [NSURL fileURLWithPath:filePath];
    OSStatus status = AudioFileOpenURL((CFURLRef)url, kAudioFileReadPermission, 0, &audioFile);
    ThrowIfFails(status, @"Can't open audio file");
    
    UInt32 size = sizeof(dataFormat);
    status = AudioFileGetProperty(audioFile, kAudioFilePropertyDataFormat, &size, &dataFormat);
    ThrowIfFails(status, @"Couldn't get file's data format.");
}

#pragma mark -
#pragma mark notifications

void isRunningListener (void *inUserData, AudioQueueRef inAQ, AudioQueuePropertyID inID)
{
    NSLog(@"running notification");
}

@end
