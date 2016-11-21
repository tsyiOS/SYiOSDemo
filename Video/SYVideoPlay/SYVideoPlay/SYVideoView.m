//
//  SYVideoView.m
//  SYVideoPlay
//
//  Created by leju_esf on 16/11/21.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYVideoView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#define video1 @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"
//#define video1 @"http://www.aa337.com/video3-mp4_water_m3u8/36298/36298.m3u8"
#define video2 @"http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA"

@interface SYVideoView ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@end

@implementation SYVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.layer addSublayer:self.playerLayer];
    }
    return self;
}

- (void)play {
    [self.player play];
}
- (void)pause {
    [self.player pause];
}

- (void)setVideoUrl:(NSString *)videoUrl {
    _videoUrl = videoUrl;
    [self.player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL URLWithString:videoUrl]]];
    [self.player play];
}

- (AVPlayerLayer *)playerLayer {
    if (_playerLayer == nil) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = self.bounds;
        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _playerLayer;
}

- (AVPlayer *)player {
    if (_player == nil) {
        _player = [AVPlayer playerWithURL:[NSURL URLWithString:video2]];
    }
    return _player;
}

@end
