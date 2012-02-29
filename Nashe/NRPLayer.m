//
//  NRPLayer.m
//  Nashe
//
//  Created by Viktar Ilyukevich on 29.02.12.
//  Copyright (c) 2012 EPAM Systems. All rights reserved.
//

#import "NRPlayer.h"
#import <MediaPlayer/MediaPlayer.h>

#define DEFAULT_QUALITY NRPlayerQuality192

static void *NRPlayerTimedMetadataObserverContext = &NRPlayerTimedMetadataObserverContext;

static NSString *const kQualityKeyInUserDefaults = @"kQualityKeyInUserDefaults";
static const NSDictionary *allStreams;

@implementation NRPlayer

@synthesize quality = _quality;

- (id)init {
    self = [super init];
    if (self) {
        allStreams = [[NSDictionary alloc] initWithObjectsAndKeys:
                      @"http://94.25.53.133:80/nashe-192", [NSNumber numberWithInt:NRPlayerQuality192],
                      @"http://94.25.53.133:80/nashe-128", [NSNumber numberWithInt:NRPlayerQuality128],
                      @"http://94.25.53.133:80/nashe-96", [NSNumber numberWithInt:NRPlayerQuality96],
                      @"http://94.25.53.133:80/nashe-64", [NSNumber numberWithInt:NRPlayerQuality64],
                      @"http://94.25.53.133:80/nashe-48", [NSNumber numberWithInt:NRPlayerQuality48],
                      @"http://94.25.53.133:80/nashe-32", [NSNumber numberWithInt:NRPlayerQuality32],
                      nil];

        nowPlayingInfo = [[NSMutableDictionary alloc] init];

        // TODO: better to check if instances of MPMediaItemArtwork class responds to initWithImage:
        // ios 4 hasn't this method
        if ([MPNowPlayingInfoCenter class]) {
            UIImage *image = [UIImage imageNamed:@"artwork.jpg"];
            MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
            [nowPlayingInfo setValue:[artwork autorelease]
                              forKey:MPMediaItemPropertyArtwork];
        }
        _internalPlayer = [[AVPlayer alloc] init];

        // read saved quality from user defaults
        NSNumber *qualityNumber = [[NSUserDefaults standardUserDefaults] valueForKey:kQualityKeyInUserDefaults];
        // if there are no value - set default
        if (!qualityNumber) {
            qualityNumber = [NSNumber numberWithInt:DEFAULT_QUALITY];
            [[NSUserDefaults standardUserDefaults] setValue:qualityNumber forKey:kQualityKeyInUserDefaults];
        }
        // set current quality
        self.quality = (NRPlayerQuality)[qualityNumber intValue];

        [_internalPlayer addObserver:self
                          forKeyPath:@"currentItem.timedMetadata"
                             options:0
                             context:NRPlayerTimedMetadataObserverContext];

        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *setCategoryError = nil;
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
        if (setCategoryError) { /* handle the error condition */ } // TODO: handle error

        NSError *activationError = nil;
        [audioSession setActive:YES error:&activationError];
        if (activationError) { /* handle the error condition */ } // TODO: handle error

    }
    return self;
}


#pragma mark - PLayer

- (void)togglePlayPause {
    if (_internalPlayer.rate == 0.0) {
        [_internalPlayer play];
    } else {
        [_internalPlayer pause];
    }
}

- (void)setQuality:(NRPlayerQuality)newQuality {
    if (newQuality != _quality) {
        [self willChangeValueForKey:@"quality"];
        _quality = newQuality;

        NSString *stream = [allStreams objectForKey:[NSNumber numberWithInt:newQuality]];
        NSURL *url = [NSURL URLWithString:stream];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
        [_internalPlayer replaceCurrentItemWithPlayerItem:playerItem];
        [self didChangeValueForKey:@"quality"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context == NRPlayerTimedMetadataObserverContext) {
		NSArray *array = [[_internalPlayer currentItem] timedMetadata];
		for (AVMetadataItem *metadataItem in array) {
            if ([metadataItem.commonKey isEqualToString:AVMetadataCommonKeyTitle]) {
                const char *cString = [metadataItem.stringValue cStringUsingEncoding:NSISOLatin1StringEncoding];
                NSString *title = [NSString stringWithCString:cString encoding:NSWindowsCP1251StringEncoding];
                [nowPlayingInfo setValue:[NSString stringWithFormat:@"%@ (%d Kbps)", title, 192]
                                  forKey:MPMediaItemPropertyTitle];
            }
		}
        if ([MPNowPlayingInfoCenter class]) {
            /* we're on iOS 5, so set up the now playing center */
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nowPlayingInfo];
        }
	} else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - Singleton

static NRPlayer *sharedPlayer;

+ (void)initialize {
    sharedPlayer = [NRPlayer new];
}

+ (NRPlayer *)sharedPlayer {
    return sharedPlayer;
}

+ (id)allocWithZone:(NSZone *)zone {
    if (sharedPlayer) {
        return nil;
    } else {
        return [super allocWithZone:zone];
    }
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (NSUInteger)retainCount {
	return NSUIntegerMax;
}

- (oneway void)release {
}

- (id)autorelease {
	return self;
}

@end
