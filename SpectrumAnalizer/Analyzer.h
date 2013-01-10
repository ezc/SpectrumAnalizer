//
//  Analyzer.h
//  SpectrumAnalizer
//
//  Created by Evgeniy Kirpichenko on 1/8/13.
//  Copyright (c) 2013 Evgeniy Kirpichenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>

//#import <CoreAudio/CoreAudioTypes.h>

#import "CAStreamBasicDescription.h"
//#import "aurio_helper.h"

@interface Analyzer : NSObject
{
    AudioUnit rioUnit;
    AURenderCallbackStruct inputProc;
    CAStreamBasicDescription thruFormat;

    AudioComponentInstance toneUnit;
}

@end
