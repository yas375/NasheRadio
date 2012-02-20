//
//  NRRootViewControllerViewController.m
//  Nashe
//
//  Created by Victor Ilyukevich on 20.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NRRootViewController.h"

@implementation NRRootViewController

@synthesize player = _player;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL URLWithString:@"http://94.25.53.133:80/nashe-192"]];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
        [self.player play];

        AVAudioSession *audioSession = [AVAudioSession sharedInstance];        
        NSError *setCategoryError = nil;
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
        if (setCategoryError) { /* handle the error condition */ }
        
        NSError *activationError = nil;
        [audioSession setActive:YES error:&activationError];
        if (activationError) { /* handle the error condition */ }
    }
    return self;
}

- (void)dealloc {
    self.player = nil;
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - Hanle events

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                NSLog(@"play");
                if (self.player.rate == 0.0) {
                    [self.player play];
                } else {
                    [self.player pause];
                }
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"prev");
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"next");
                break;
                
            default:
                break;
        }
    }
}

@end
