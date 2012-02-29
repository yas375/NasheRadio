//
//  NRRootViewController.h
//  Nashe
//
//  Created by Victor Ilyukevich on 21.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NRPlayerView.h"

@interface NRRootViewController : UIViewController <NRPlayerViewDelegate> {
    NSMutableDictionary *nowPlayingInfo;
}

@property (strong, nonatomic) AVPlayer *player; // TODO: move into separate singleton
@property (nonatomic, retain) NRPlayerView *playerView;

@end
