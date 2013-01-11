//
//  AudioFileHelper.c
//  SpectrumAnalizer
//
//  Created by Evgeniy Kirpichenko on 1/11/13.
//  Copyright (c) 2013 Evgeniy Kirpichenko. All rights reserved.
//

#include "AudioFileHelper.h"
#include <stdio.h>

#pragma mark -
#pragma mark open/close

AudioFileID openAudioFile(CFURLRef url)
{
    AudioFileID fileID = 0;
    OSStatus status = AudioFileOpenURL(url, kAudioFileReadPermission, 0, &fileID);
    if (status != noErr) {
        const char *urlString = CFStringGetCStringPtr(CFURLGetString(url),kCFStringEncodingUTF8);
        printf("Can't open file %s. Code %ld", urlString, status);
    }
    return fileID;
}

void closeAudioFile(AudioFileID fileID)
{
    OSStatus status = AudioFileClose(fileID);
    if (status != noErr) {
        printf("Can't close file. Code %ld",status);
    }
}

#pragma mark -
#pragma mark get file properties

AudioStreamBasicDescription audioFileGetDataFormat(AudioFileID fileID)
{
    AudioStreamBasicDescription dataFormat;
    UInt32 size = sizeof(dataFormat);

    OSStatus status = AudioFileGetProperty(fileID, kAudioFilePropertyDataFormat, &size, &dataFormat);
    if (status != noErr) {
        printf("Couldn't get file's data format. Code %ld",status);
    }
    return dataFormat;
}

