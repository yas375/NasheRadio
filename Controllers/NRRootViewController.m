//
//  NRRootViewController.m
//  Nashe
//
//  Created by Victor Ilyukevich on 21.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NRRootViewController.h"
#import <MediaPlayer/MediaPlayer.h>

static void *MyPlayerTimedMetadataObserverContext = &MyPlayerTimedMetadataObserverContext;

@interface NRRootViewController ()
@end

@implementation NRRootViewController

@synthesize player = _player;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        nowPlayingInfo = [[NSMutableDictionary alloc] init];
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"artwork.jpg"]];
        [nowPlayingInfo setValue:[artwork autorelease]
                          forKey:MPMediaItemPropertyArtwork];

        NSURL *url = [NSURL URLWithString:@"http://94.25.53.133:80/nashe-192"];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
        self.player = [AVPlayer playerWithPlayerItem:playerItem];

        [self.player addObserver:self
                      forKeyPath:@"currentItem.timedMetadata"
                         options:0
                         context:MyPlayerTimedMetadataObserverContext];

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
    [nowPlayingInfo release];
    self.player = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (void)remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
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

#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context == MyPlayerTimedMetadataObserverContext) {
		NSArray *array = [[self.player currentItem] timedMetadata];
		for (AVMetadataItem *metadataItem in array) {
            if ([metadataItem.commonKey isEqualToString:AVMetadataCommonKeyTitle]) {
                const char *cString = [metadataItem.stringValue cStringUsingEncoding:NSISOLatin1StringEncoding];
                NSString *title = [NSString stringWithCString:cString encoding:NSWindowsCP1251StringEncoding];
                [nowPlayingInfo setValue:[NSString stringWithFormat:@"%@ (%d Kbps)", title, 192]
                                  forKey:MPMediaItemPropertyTitle];
            }
		}
        if ([MPNowPlayingInfoCenter class])  {
            /* we're on iOS 5, so set up the now playing center */
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nowPlayingInfo];
        }
	} else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }    
}

@end
