//
//  NRPlayerView.h
//  Nashe
//
//  Created by Viktar Ilyukevich on 29.02.12.
//  Copyright (c) 2012 EPAM Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol NRPlayerViewDelegate;

@interface NRPlayerView : UIView

@property (nonatomic, retain) UIButton *playButton;
@property (nonatomic, retain) UILabel *currentTitleLabel;
@property (nonatomic, retain) MPVolumeView *volumeView;

@property (nonatomic, assign) id <NRPlayerViewDelegate> delegate;

@end


@protocol NRPlayerViewDelegate
- (void)playButtonTapped; // add completion block
@end