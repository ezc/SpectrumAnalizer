//
//  AudioQueuePlayer.m
//  SpectrumAnalizer
//
//  Created by Evgeniy Kirpichenko on 1/10/13.
//  Copyright (c) 2013 Evgeniy Kirpichenko. All rights reserved.
//

#import "AudioQueuePlayer.h"

static const UInt16 kDefaultBufferSize = 48000;

@interface AudioQueuePlayer ()
@property (nonatomic, strong) NSString *filePath;
@end

@implementation AudioQueuePlayer

- (id) initWithFilePath:(NSString *) filePath
{
    if (self = [super init]) {
        [self setFilePath:filePath];
    }
    return self;
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
    [self checkMagicalCookie];    

}

- (void) checkMagicalCookie
{
    UInt32 size = sizeof(UInt32);
	OSStatus status = AudioFileGetPropertyInfo (audioFile, kAudioFilePropertyMagicCookieData, &size, NULL);
	if (status == noErr && size) {
		char* cookie = malloc(size * sizeof(char));
		
        status = AudioFileGetProperty (audioFile, kAudioFilePropertyMagicCookieData, &size, cookie);
        if (status != noErr) {
            NSLog(@"Can't get cookie from file");
        }
        
		status = AudioQueueSetProperty(audioQueue, kAudioQueueProperty_MagicCookie, cookie, size);
        if (status != noErr) {
            NSLog(@"Can't set cookie on queue");
        }
        
        free(cookie);
	}
}

void renderBufferCallback (void *inUserData,
                           AudioQueueRef inAQ,
                           AudioQueueBufferRef inCompleteAQBuffer)
{
    
}

#pragma mark -
#pragma mark load file properties

- (void) openAudioFile:(NSString *) filePath
{
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    OSStatus status = AudioFileOpenURL((CFURLRef)url, kAudioFileReadPermission, 0, &audioFile);
    if (status != noErr) {
        NSLog(@"Can't open file %@. Code %ld", filePath, status);
    }
    
    UInt32 size = sizeof(dataFormat);
    status = AudioFileGetProperty(audioFile, kAudioFilePropertyDataFormat, &size, &dataFormat);
    if (status != noErr) {
        NSLog(@"Couldn't get file's data format. Code %ld",status);
    }
}

- (void) closeAudioFile
{
    OSStatus status = AudioFileClose(audioFile);
    if (status != noErr) {
        NSLog(@"Can't close file");
    }
    audioFile = 0;
}

@end
