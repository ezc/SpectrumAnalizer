//
//  AudioQueuePlayer.h
//  SpectrumAnalizer
//
//  Created by Evgeniy Kirpichenko on 1/10/13.
//  Copyright (c) 2013 Evgeniy Kirpichenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AudioQueuePlayer : NSObject
{
    AudioFileID audioFile;
    AudioStreamBasicDescription dataFormat;
    AudioQueueRef audioQueue;
}

- (id) initWithFilePath:(NSString *) filePath;

- (void) play;
- (void) pause;
- (void) stop;

@end
