//
//  RTHVideoInfoVideoView.m
//  儒思HR
//
//  Created by Yala on 15/8/28.
//  Copyright (c) 2015年 Yala. All rights reserved.
//

#import "RTHVideoInfoVideoView.h"


@interface RTHVideoInfoVideoView () <RTHVideoInfoVideoToolBarDelegate>

@end

@implementation RTHVideoInfoVideoView
#pragma mark - LifeCycle
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubviews];
}
- (void)addSubviews {
    self.videoToolBar = [RTHVideoInfoVideoToolBar new];
    self.videoToolBar.delegate = self;
    [self addSubview:self.videoToolBar];
    [self.videoToolBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(50);
    }];
}

- (void)dealloc {
    [self.player removeTimeObserver:self.timeObserver];
    self.timeObserver = nil;
    
    [self.item removeObserver:self forKeyPath:@"status"];
}

#pragma mark - Public Method
- (void)setVideoURL:(NSString *)videoURL {
    if (videoURL == nil) {
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.image = [UIImage imageNamed:@"player.png"];
        [self addSubview:imageview];
        [imageview makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(self.width).multipliedBy(.6);
        }];
    }
    if (_videoURL != videoURL) {
        _videoURL = videoURL;
        if (_videoURL.length == 0) {
            DZDebugLog(@"视频地址为空，无法播放");
            return;
        }
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:videoURL] options:nil];
        NSArray *requestKeys = @[@"playable"];
        [asset loadValuesAsynchronouslyForKeys:requestKeys completionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self prepareToPlayAsset:asset withKeys:requestKeys];
            });
        }];
    }
}

- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestKeys {
    
    for (NSString *key in requestKeys) {
        NSError *error = nil;
        AVKeyValueStatus keyValueStatus = [asset statusOfValueForKey:key error:&error];
        if (keyValueStatus == AVKeyValueStatusFailed) {
            DZDebugLog(@"无法播放");
            return;
        }
    }
    
    if (!asset.playable) {
        DZDebugLog(@"无法播放");
        return;
    }
    
    if (self.item) {
        [self.item removeObserver:self forKeyPath:@"status"];
    }
    
    self.item = [AVPlayerItem playerItemWithAsset:asset];
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    if (!self.player) {
        self.player = [AVPlayer playerWithPlayerItem:self.item];
        self.fillMode = AVLayerVideoGravityResizeAspectFill;
    }
    
    if (self.player.currentItem != self.item) {
        [self.player replaceCurrentItemWithPlayerItem:self.item];
    }
    
    //remove
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
    
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CGFloat currentTime = CMTimeGetSeconds(time);
//        CGFloat totalTime = weakSelf.player.vi
        DZDebugLog(@"当前播放时间%.f", currentTime);
        weakSelf.videoToolBar.currentValue = currentTime;
    }];
    
    [self.player play];
}

#pragma mark - Setter
- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)self.layer setPlayer:player];
}

- (void)setFillMode:(NSString *)fillMode {
    [(AVPlayerLayer *)self.layer setVideoGravity:fillMode];
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    
    self.videoToolBar.zoomBtn.selected = _fullScreen;
}

#pragma mark - Getter
+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)self.layer player];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerStatusReadyToPlay:
            {
                self.videoToolBar.isToolBarEnable = YES;
                self.videoToolBar.playing = YES;
                
                AVPlayerItem *item = object;
                NSTimeInterval duration = CMTimeGetSeconds(item.asset.duration);
                self.videoToolBar.duration = duration;
            }
                break;
            case AVPlayerStatusFailed:
            {
                self.videoToolBar.playing = NO;
            }
                break;
            case AVPlayerStatusUnknown:
            {
                self.videoToolBar.playing = NO;
            }
            default:
                break;
        }
    }
}


#pragma mark - RTHVideoInfoVideoToolBarDelegate
- (void)videoToolBar:(RTHVideoInfoVideoToolBar *)videoToolBar didSelectZoomBtn:(UIButton *)zoomBtn {
    
    if ([self.delegate respondsToSelector:@selector(videoView:didSelectZoom:)]) {
        [self.delegate videoView:self didSelectZoom:zoomBtn];
    }
    
    
}

- (void)videoToolBar:(RTHVideoInfoVideoToolBar *)videoToolBar didSelectPlayPauseBtn:(UIButton *)playPauseBtn {
    
    if (self.player.rate > 0) {
        self.videoToolBar.playing = NO; //暂停
        [self.player pause];
    } else {
        self.videoToolBar.playing = YES;  //播放
        [self.player play];
    }
}

- (void)videoToolBar:(RTHVideoInfoVideoToolBar *)videoToolBar didTouchProgressSlider:(UISlider *)slider targetTime:(CGFloat)targetTime{
    CMTime time = CMTimeMakeWithSeconds(targetTime, self.player.currentItem.duration.timescale);
    
    [self.player seekToTime:time completionHandler:^(BOOL finished) {
        self.videoToolBar.playing = YES;
        [self.player play];
    }];
}

- (void)videoToolBar:(RTHVideoInfoVideoToolBar *)videoToolBar progressSliderValueDidChange:(UISlider *)slider targetTime:(CGFloat)targetTime {
    if (self.player.rate > 0) {
        self.videoToolBar.playing = NO;
        [self.player pause];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.videoToolBar.hidden = !self.videoToolBar.hidden;
}

@end
