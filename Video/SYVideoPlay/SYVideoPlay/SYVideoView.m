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
#import "SYVideoToolBar.h"
#import "UIView+SYExtension.h"

@interface SYVideoView ()<SYVideoToolBarDelegate>
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) SYVideoToolBar *toolBar;
@property (nonatomic, assign) CGRect lastFrame;
@end

@implementation SYVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}



- (void)setUpUI {
    [self.layer addSublayer:self.playerLayer];
    [self addSubview:self.toolBar];
    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *constraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolBar]|" options:NSLayoutFormatAlignmentMask metrics:nil views:@{@"toolBar":self.toolBar}];
    NSArray *constraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[toolBar(25)]-10-|" options:NSLayoutFormatAlignmentMask metrics:nil views:@{@"toolBar":self.toolBar}];
    [self addConstraints:constraintV];
    [self addConstraints:constraintH];
}

- (void)orientationChange {
    NSLog(@"=======%ld",[UIDevice currentDevice].orientation);
}

- (void)play {
    [self.player play];
}
- (void)pause {
    [self.player pause];
}

- (void)setVideoUrl:(NSString *)videoUrl {
    _videoUrl = videoUrl;
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:videoUrl] options:nil];
    NSArray *requestKeys = @[@"playable"];
    [asset loadValuesAsynchronouslyForKeys:requestKeys completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self prepareToPlayAsset:asset withKeys:requestKeys];
        });
    }];
}

- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestKeys {
    for (NSString *key in requestKeys) {
        NSError *error = nil;
        AVKeyValueStatus keyValueStatus = [asset statusOfValueForKey:key error:&error];
        if (keyValueStatus == AVKeyValueStatusFailed) {
            NSLog(@"无法播放");
            return;
        }
    }
    NSInteger second = [asset duration].value/[asset duration].timescale;
    self.toolBar.totalTime = second;
    [self.player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:asset.URL]];
    
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CGFloat currentTime = CMTimeGetSeconds(time);
        weakSelf.toolBar.currentTime = (NSInteger)currentTime;
    }];

    [self.player play];
    self.toolBar.type = SYVideoToolBarStatusPlay;
}

#pragma mark - SYVideoToolBarDelegate
- (void)playAction:(BOOL)play {
    if (play) {
        [self.player play];
    }else {
        [self.player pause];
    }
}

//- (void)screenShot {
//    UIImage *image = [self.player re]
//}

- (void)fullScreenAction:(BOOL)fullScreen {
    if (fullScreen) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        NSNumber *orientationUnknown = [NSNumber numberWithInt:UIDeviceOrientationUnknown];
        [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        self.lastFrame = self.frame;
        self.frame = [UIScreen mainScreen].bounds;
        self.playerLayer.frame = self.bounds;
        NSLog(@"%@",NSStringFromCGRect(self.frame));
    }else {
        self.frame = self.lastFrame;
        self.playerLayer.frame = self.bounds;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        NSNumber *orientationUnknown = [NSNumber numberWithInt:UIDeviceOrientationUnknown];
        [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}

#pragma mark - 懒加载
- (SYVideoToolBar *)toolBar {
    if (_toolBar == nil) {
//        CGFloat h = 25;
//        _toolBar = [[SYVideoToolBar alloc] initWithFrame:CGRectMake(0, self.sy_height - h - 5, self.sy_width, h)];
        _toolBar = [[SYVideoToolBar alloc] init];
        _toolBar.delegate = self;
    }
    return _toolBar;
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
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

@end
