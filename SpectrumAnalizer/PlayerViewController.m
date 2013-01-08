//
//  PlayerViewController.m
//  SpectrumAnalizer
//
//  Created by Evgeniy Kirpichenko on 1/8/13.
//  Copyright (c) 2013 Evgeniy Kirpichenko. All rights reserved.
//

#import "PlayerViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerViewController () <AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) MPMoviePlayerController *controller;
@property (nonatomic, strong) AVPlayer *avplayer;
@end

@implementation PlayerViewController

- (IBAction)play
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"01. Stargazers"
                                                         ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath];

    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error) {
        NSLog(@"error playing");
    }
    
    if (self.player) {
//        [self.player setDelegate:self];
//        [player setNumberOfLoops:1];
        [self.player play];
    }
    else {
        NSLog(@"empty player");
    }

}

- (IBAction)movie
{
    NSURL *url = [NSURL URLWithString:@"http://cs4617.userapi.com/u44378645/audios/6059f7891891.mp3"];
    self.controller = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [self.controller play];
}

- (IBAction)playAVPlayer
{
    NSURL *url = [NSURL URLWithString:@"http://cs4617.userapi.com/u44378645/audios/6059f7891891.mp3"];
    self.avplayer = [[AVPlayer alloc] initWithURL:url];
    [self.player play];
}

@end
