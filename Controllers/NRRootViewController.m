//
//  NRRootViewController.m
//  Nashe
//
//  Created by Victor Ilyukevich on 21.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NRRootViewController.h"
#import "NRPlayer.h"

@interface NRRootViewController ()
@end

@implementation NRRootViewController

@synthesize playerView = _playerView;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.playerView = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    NRPlayerView *player = [[NRPlayerView alloc] initWithFrame:self.view.bounds];
    player.delegate = self;
    self.playerView = [player autorelease];
    [self.view addSubview:player];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.playerView = nil;
}

// TODO: check and maybe move into appelegate
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

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - Hanle events

- (void)remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [[NRPlayer sharedPlayer] togglePlayPause];
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

#pragma mark - NRPlayerViewDelegate

- (void)playButtonTapped {
    [[NRPlayer sharedPlayer] togglePlayPause];
//    if (self.player.rate == 0.0) {
//        [self.player play];
//        self.playerView.playButton.selected = YES;
//    } else {
//        [self.player pause];
//        self.playerView.playButton.selected = NO;
//    }

}

@end
