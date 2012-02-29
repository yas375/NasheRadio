//
//  NRPLayer.h
//  Nashe
//
//  Created by Viktar Ilyukevich on 29.02.12.
//  Copyright (c) 2012 EPAM Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
    NRPlayerQuality192 = 5,
    NRPlayerQuality128,
    NRPlayerQuality96,
    NRPlayerQuality64,
    NRPlayerQuality48,
    NRPlayerQuality32,
} NRPlayerQuality;

@interface NRPlayer : NSObject {
    AVPlayer *_internalPlayer;
    NSMutableDictionary *nowPlayingInfo;
}

+ (NRPlayer *)sharedPlayer;
- (void)togglePlayPause; // TODO: add onCompletion block

@property (nonatomic, assign) NRPlayerQuality quality;

@end
