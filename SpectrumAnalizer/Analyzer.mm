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
    
    
//    UInt32 maxFPS;
//    UInt32 size = sizeof(maxFPS);
//(AudioUnitGetProperty(rioUnit, kAudioUnitProperty_MaximumFramesPerSlice, kAudioUnitScope_Global, 0, &maxFPS, &size), "couldn't get the remote I/O unit's max frames per slice");
    
    
    AudioComponentDescription defaultOutputDescription;
	defaultOutputDescription.componentType = kAudioUnitType_Output;
	defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	defaultOutputDescription.componentFlags = 0;
	defaultOutputDescription.componentFlagsMask = 0;
	
	// Get the default playback output unit
	AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);

    OSErr err = AudioComponentInstanceNew(defaultOutput, &toneUnit);
    
    AURenderCallbackStruct input;
	input.inputProc = rendered;
	input.inputProcRefCon = self;

    
    AudioUnitSetProperty(toneUnit,
                         kAudioUnitProperty_SetRenderCallback,
                         kAudioUnitScope_Input,
                         0, 
                         &input,
                         sizeof(input));
}

OSStatus rendered(  void *inRefCon,
                    AudioUnitRenderActionFlags 	*ioActionFlags,
                    const AudioTimeStamp 		*inTimeStamp,
                    UInt32 						inBusNumber,
                    UInt32 						inNumberFrames, 
                    AudioBufferList 			*ioData)
{
    
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
