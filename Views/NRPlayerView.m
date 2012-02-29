//
//  NRPlayerView.m
//  Nashe
//
//  Created by Viktar Ilyukevich on 29.02.12.
//  Copyright (c) 2012 EPAM Systems. All rights reserved.
//

#import "NRPlayerView.h"
#import "NRViewDefinitions.h"

#define SPACER 20.0

@interface NRPlayerView (internal)
- (void)playButtonTapped:(id)sender;
@end

@implementation NRPlayerView

@synthesize playButton = _playButton;
@synthesize currentTitleLabel = _currentTitleLabel;
@synthesize volumeView = _volumeView;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"Play" forState:UIControlStateNormal];
        [button setTitle:@"Pause" forState:UIControlStateSelected];
        [button addTarget:self
                   action:@selector(playButtonTapped:)
         forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:button];
        self.playButton = button;

        UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
        titleLabel.numberOfLines = 3;
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:titleLabel];
        self.currentTitleLabel = titleLabel;

        MPVolumeView *volumeView = [[[MPVolumeView alloc] init] autorelease];
        [self addSubview:volumeView];
        self.volumeView = volumeView;
    }
    return self;
}

- (void)dealloc {
    self.playButton = nil;
    self.currentTitleLabel = nil;
    [super dealloc];
}

- (void)layoutSubviews {
    float width = self.bounds.size.width;
//    float height = self.bounds.size.height;
    self.currentTitleLabel.frame = CGRectMake(SPACER,
                                              SPACER,
                                              width - SPACER * 2,
                                              100);
    self.playButton.frame = CGRectMake(SPACER,
                                       Y_AFTER(self.currentTitleLabel),
                                       200,
                                       100);
    CGSize volumeSize = [self.volumeView sizeThatFits:CGSizeMake(width - SPACER * 2, 0)];
    self.volumeView.frame = CGRectMake(SPACER,
                                       Y_AFTER(self.playButton),
                                       volumeSize.width,
                                       volumeSize.height);
}

#pragma mark - Internal

- (void)playButtonTapped:(id)sender {
    if (self.delegate) {
        [self.delegate playButtonTapped];
    }
}

@end
