//
//  Analyzer.m
//  SpectrumAnalizer
//
//  Created by Evgeniy Kirpichenko on 1/8/13.
//  Copyright (c) 2013 Evgeniy Kirpichenko. All rights reserved.
//

#import "Analyzer.h"

#import <AVFoundation/AVFoundation.h>

@implementation Analyzer

- (void) initializeAudioSession
{
    AudioSessionInitialize(NULL, NULL, interruptionListener, NULL);
    
    UInt32 audioCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory);
    
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, routeChangeListener, NULL);
    
//    SetupRemoteIO(rioUnit,inputProc,thruFormat);
}

#pragma mark -
#pragma mark audio session listeners

void interruptionListener (void *inClientData, UInt32 inInterruptionState)
{
    printf("Session interrupted! --- %s ---", inInterruptionState == kAudioSessionBeginInterruption ? "Begin Interruption" : "End Interruption");
}

void routeChangeListener (void *inClientData,
                          AudioSessionPropertyID inID,
                          UInt32 inDataSize,
                          const void *inData)
{
    NSLog(@"route changed");
}


@end
