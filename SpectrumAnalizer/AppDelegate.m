//
//  AppDelegate.m
//  SpectrumAnalizer
//
//  Created by Evgeniy Kirpichenko on 1/4/13.
//  Copyright (c) 2013 Evgeniy Kirpichenko. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayerViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    PlayerViewController *playerController = [[PlayerViewController alloc] init];
    [[self window] setRootViewController:playerController];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
