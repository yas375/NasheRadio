//
//  NRRootViewControllerViewController.m
//  Nashe
//
//  Created by Victor Ilyukevich on 20.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NRRootViewController.h"

static void *MyPlayerTimedMetadataObserverContext = &MyPlayerTimedMetadataObserverContext;


@implementation NRRootViewController

@synthesize player = _player;
@synthesize titleLabel = _titleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL URLWithString:@"http://94.25.53.133:80/nashe-192"]];
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
    self.player = nil;
    self.titleLabel = nil;
    [super dealloc];
}


- (void)loadView {
    [super loadView];
    self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 200)] autorelease];
    self.titleLabel.numberOfLines = 5;

    [self.view addSubview:self.titleLabel];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.titleLabel = nil;
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

#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    NSLog(@"йухуу!");
    if (context == MyPlayerTimedMetadataObserverContext) {
		NSArray *array = [[self.player currentItem] timedMetadata];
		for (AVMetadataItem *metadataItem in array) {
            NSString *value = (NSString *)metadataItem.value;
            NSString *goodValue = [[NSString alloc] initWithData:[value dataUsingEncoding:NSNonLossyASCIIStringEncoding] encoding:NSUTF8StringEncoding];

            const char *cstr = [goodValue cStringUsingEncoding:NSNonLossyASCIIStringEncoding];
            NSString *asd = [NSString stringWithCString:cstr encoding:NSNonLossyASCIIStringEncoding];
            NSLog(@"asd: %@", asd);

            NSMutableString *myDecoded = [NSMutableString stringWithString:goodValue];

            NSLog(@"VALUE: %@ ||| %@ => %@", value, goodValue, myDecoded);
            self.titleLabel.text = myDecoded;
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSASCIIStringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSNEXTSTEPStringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSJapaneseEUCStringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSUTF8StringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSSymbolStringEncoding] encoding:NSUTF8StringEncoding]);

//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSNonLossyASCIIStringEncoding] encoding:NSUTF8StringEncoding]);

//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSISOLatin2StringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSUnicodeStringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSWindowsCP1251StringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSWindowsCP1252StringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSWindowsCP1253StringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSWindowsCP1254StringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSWindowsCP1250StringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSISO2022JPStringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSMacOSRomanStringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSUTF16StringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSUTF16BigEndianStringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSUTF16LittleEndianStringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSUTF32StringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSUTF32BigEndianStringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSUTF32LittleEndianStringEncoding] encoding:NSUTF8StringEncoding]);
//NSLog(@"%@", [[NSString alloc] initWithData:[value dataUsingEncoding:            NSProprietaryStringEncoding] encoding:NSUTF8StringEncoding]);
//            NSLog(@"%@", data);
//            NSLog(@"%@", [value cStringUsingEncoding:kCFStringEncodingDOSRussian]);
//            NSLog(@"%@ ==> %@", value, [NSString stringWithUTF8String:[value cStringUsingEncoding:NSWindowsCP1251StringEncoding]]);
		}
	} else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }

}

@end
