//
//  NRRootViewController.h
//  Nashe
//
//  Created by Victor Ilyukevich on 21.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NRPlayerView.h"

@interface NRRootViewController : UIViewController <NRPlayerViewDelegate>

@property (nonatomic, retain) NRPlayerView *playerView;

@end
