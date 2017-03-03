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
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSUInteger, SYPanType) {
    SYPanTypeNULL = 0,
    SYPanTypeSchedule,//进度
    SYPanTypeLight,
    SYPanTypeVoice
};

@interface SYVideoView ()<SYVideoToolBarDelegate>
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) SYVideoToolBar *toolBar;
@property (nonatomic, assign) CGRect lastFrame;
@property (nonatomic, assign) UIStatusBarStyle barStyle;
@property (nonatomic, assign) BOOL barHidden;
@property (nonatomic, assign) BOOL showToolBar;
@property (nonatomic, assign) BOOL fullScreen;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CMTime seekTime;
@property (nonatomic, assign) NSInteger time;//清屏时间,默认15秒
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, strong) UIView *voiceSlider;
@property (nonatomic, strong) UIView *brightSlider;
@property (nonatomic, assign) SYPanType panType;
@property (nonatomic, assign) CGFloat currentLight;
@property (nonatomic, assign) float currentVoice;
@end

@implementation SYVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.lastFrame = frame;
        [self setUpUI];
        [self addGestureRecognizer:self.tap];
        [self addGestureRecognizer:self.pan];
        self.barStyle = [UIApplication sharedApplication].statusBarStyle;
        self.barHidden = [UIApplication sharedApplication].isStatusBarHidden;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)setUpUI {
    [self.layer addSublayer:self.playerLayer];
    [self addSubview:self.toolBar];
    self.showToolBar = YES;
    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *constraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolBar]|" options:NSLayoutFormatAlignmentMask metrics:nil views:@{@"toolBar":self.toolBar}];
    NSArray *constraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[toolBar(25)]-10-|" options:NSLayoutFormatAlignmentMask metrics:nil views:@{@"toolBar":self.toolBar}];
    [self addConstraints:constraintV];
    [self addConstraints:constraintH];
}

#pragma mark - 处理通知
- (void)orientationChange {
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft||[UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        self.fullScreen = YES;
    }else if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        self.fullScreen = NO;
    }
}

- (void)becomeActive {
    
}

- (void)enterForeground {
    if (self.toolBar.playing) {
        [self.player play];
    }
}

#pragma mark - 对象方法
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
    [self.timer fire];
    self.toolBar.playing = YES;
}

#pragma mark - SYVideoToolBarDelegate
- (void)playAction:(BOOL)play {
    if (play) {
        [self.player play];
    }else {
        [self.player pause];
    }
}

- (void)fullScreenAction:(BOOL)fullScreen {
    self.fullScreen = fullScreen;
    if (fullScreen) {

        NSNumber *orientationUnknown = [NSNumber numberWithInt:UIDeviceOrientationUnknown];
        [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }else {
       
        NSNumber *orientationUnknown = [NSNumber numberWithInt:UIDeviceOrientationUnknown];
        [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];

    }
    
    self.time = 0;
    [self.timer fire];
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    
    self.toolBar.fullScreen = fullScreen;
    if (fullScreen) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:!self.showToolBar];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = [UIScreen mainScreen].bounds;
            self.playerLayer.frame = self.bounds;
        }];
        
    }else {
        
        [[UIApplication sharedApplication] setStatusBarHidden:self.barHidden];
        [[UIApplication sharedApplication] setStatusBarStyle:self.barStyle];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = self.lastFrame;
            self.playerLayer.frame = self.bounds;
        }];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(sy_fullScreen:)]) {
        [self.delegate sy_fullScreen:fullScreen];
    }
}

- (void)slideTaped:(BOOL)taped value:(CGFloat)value{
    if (taped) {
        [self.timer invalidate];
        self.timer = nil;
        self.tap.enabled = NO;
        self.pan.enabled = NO;
    }else {
        [self scrollToTime:self.toolBar.totalTime*value];
        self.tap.enabled = YES;
        self.pan.enabled = YES;
        [self.timer fire];
    }
}

/**
 快进或快退

 @param time 时间
 */
- (void)scrollToTime:(CGFloat)time {
    CMTime curremtTime = CMTimeMakeWithSeconds(time, self.player.currentItem.duration.timescale);
    [self.player seekToTime:curremtTime completionHandler:^(BOOL finished) {
        [self.player play];
    }];
}

#pragma mark - 页面操作
/**
 页面空白点击
 */
- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (!CGRectContainsPoint(self.toolBar.frame, [tap locationInView:self])) {
        self.showToolBar = !self.showToolBar;
    }
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    
    if (CGRectContainsPoint(self.toolBar.frame, [pan locationInView:self])) {
        return;
    }
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.startPoint = [pan locationInView:self];
        self.currentLight = [[UIScreen mainScreen] brightness];
        self.currentVoice =  [MPMusicPlayerController applicationMusicPlayer].volume;
        
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        NSLog(@"%@",NSStringFromCGPoint([pan locationInView:self]));
        CGPoint firstChangePoint = [pan locationInView:self];
        if (self.panType == SYPanTypeNULL) {
            if (fabs(self.startPoint.x - firstChangePoint.x) >= fabs(self.startPoint.y - firstChangePoint.y)) {
                //左右滑动
                self.panType = SYPanTypeSchedule;
            }else {
                //上下滑动
                self.panType =  self.startPoint.x <= self.frame.size.width * 0.5 ? SYPanTypeLight : SYPanTypeVoice;
            }
        }
        [self changeStatusWithPoint:firstChangePoint];
    }else if (pan.state == UIGestureRecognizerStateEnded) {
        [self endVideoScheduleWithPoint:[pan locationInView:self]];
    }
}

- (void)changeStatusWithPoint:(CGPoint)point {
//    NSLog(@"%zd---====%f",self.panType,self.startPoint.y - point.y);
    if (self.panType == SYPanTypeLight) {
        
        CGFloat changeValue = (self.startPoint.y - point.y)/100.0;
        CGFloat lightValue = self.currentLight + changeValue;
        NSLog(@"light--%f",lightValue);
        if (lightValue > 1.0) {
            lightValue = 1.0;
        }else if (lightValue < 0) {
            lightValue = 0;
        }
        [[UIScreen mainScreen] setBrightness: lightValue];
    }else {
        float changeValue = (self.startPoint.y - point.y)/100.0;
        float voiceValue = self.currentVoice + changeValue;
        if (voiceValue > 1.0) {
            voiceValue = 1.0;
        }else if (voiceValue < 0) {
            voiceValue = 0;
        }
    
        [MPMusicPlayerController applicationMusicPlayer].volume = voiceValue;
    }
}

- (void)endVideoScheduleWithPoint:(CGPoint)point {
    NSLog(@"结束%@",NSStringFromCGPoint(point));
    if (self.panType == SYPanTypeSchedule) {
        [self scrollToTime:self.toolBar.currentTime + (point.x - self.startPoint.x)*0.1];
    }
    self.panType = SYPanTypeNULL;
}

- (void)remainTime {
    self.time ++;
    if (self.time == 15) {
        self.showToolBar = NO;
    }
}

- (void)setShowToolBar:(BOOL)showToolBar {
    _showToolBar = showToolBar;
    if (showToolBar) {
        [UIView animateWithDuration:0.25 animations:^{
            self.toolBar.alpha = 1;
        }completion:^(BOOL finished) {
            [self.timer fire];
            if (self.fullScreen) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            }else {
                [[UIApplication sharedApplication] setStatusBarHidden:self.barHidden];
                [[UIApplication sharedApplication] setStatusBarStyle:self.barStyle];
            }
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            self.toolBar.alpha = 0;
        }completion:^(BOOL finished) {
            [self.timer invalidate];
            self.timer = nil;
            self.time = 0;
            if (self.fullScreen) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
            }else {
                [[UIApplication sharedApplication] setStatusBarHidden:self.barHidden];
                [[UIApplication sharedApplication] setStatusBarStyle:self.barStyle];
            }
        }];
    }
}

#pragma mark - 懒加载
- (NSTimer *)timer {
    if (_timer == nil) {
        _timer =[NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(remainTime) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (SYVideoToolBar *)toolBar {
    if (_toolBar == nil) {
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

- (UITapGestureRecognizer *)tap {
    if (_tap == nil) {
       _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    }
    return _tap;
}

- (UIPanGestureRecognizer *)pan {
    if (_pan == nil) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    }
    return _pan;
}


- (void)dealloc {
    NSLog(@"播放器消失");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
