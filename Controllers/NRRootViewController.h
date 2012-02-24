//
//  NRRootViewController.h
//  Nashe
//
//  Created by Victor Ilyukevich on 21.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface NRRootViewController : UIViewController {
    NSMutableDictionary *nowPlayingInfo;
}

@property (strong, nonatomic) AVPlayer *player;

@end
