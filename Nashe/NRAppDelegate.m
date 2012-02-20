//
//  NRAppDelegate.m
//  Nashe
//
//  Created by Victor Ilyukevich on 18.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NRAppDelegate.h"
#import "NRRootViewController.h"

@implementation NRAppDelegate

@synthesize window = _window;

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application
            didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.rootViewController = [[[NRRootViewController alloc] init] autorelease];
    self.window.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
