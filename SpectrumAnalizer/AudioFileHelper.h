//
//  AudioFileHelper.h
//  SpectrumAnalizer
//
//  Created by Evgeniy Kirpichenko on 1/11/13.
//  Copyright (c) 2013 Evgeniy Kirpichenko. All rights reserved.
//

#ifndef SpectrumAnalizer_AudioFileHelper_h
#define SpectrumAnalizer_AudioFileHelper_h

#include <AudioToolbox/AudioToolbox.h>

AudioFileID audioFileOpen(CFURLRef);
void audioFileClose(AudioFileID);

AudioStreamBasicDescription audioFileGetDataFormat(AudioFileID);

#endif
