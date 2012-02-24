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
@synthesize tableView = _tableView;

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

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];

    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                          style:UITableViewStyleGrouped];
    UILabel *header = [[[UILabel alloc] init] autorelease];
    header.text = @"НАШЕ радио";
    header.textAlignment = UITextAlignmentCenter;
    header.font = [UIFont systemFontOfSize:17.0];
    [header sizeToFit];
    tableView.tableHeaderView = header;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = [tableView autorelease];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tableView = nil;
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:cellIdentifier] autorelease];
    }
    if (indexPath.section == 0) {
        int bitrate;
        switch (indexPath.row) {
            case 0:
                bitrate = 192;
                break;
            case 1:
                bitrate = 128;
                break;
            case 2:
                bitrate = 96;
                break;
            case 3:
                bitrate = 64;
                break;
            case 4:
                bitrate = 48;
                break;
            case 5:
                bitrate = 32;
                break;
                
            default:
                break;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%d kbps", bitrate];
        cell.imageView.image = [UIImage imageNamed:@"control-pause.png"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"~%.1f Mb/час", ((bitrate / 8.0) * 3600) / 1024];
    } else {
        cell.textLabel.text = @"Убрать рекламу";
        cell.detailTextLabel.text = @"Поддержи нашего разработчика!";
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Качество";
    } else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
