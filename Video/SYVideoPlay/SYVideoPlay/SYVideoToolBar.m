//
//  SYVideoToolBar.m
//  SYVideoPlay
//
//  Created by leju_esf on 16/11/22.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYVideoToolBar.h"
#import "UIView+SYExtension.h"

@interface SYVideoToolBar ()
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic, assign,readonly) BOOL operationing;
@end

@implementation SYVideoToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self addSubview:self.playBtn];
    [self addSubview:self.currentTimeLabel];
    [self addSubview:self.slider];
    [self addSubview:self.totalTimeLabel];
    [self addSubview:self.fullScreenBtn];
    
    self.playBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.currentTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.slider.translatesAutoresizingMaskIntoConstraints = NO;
    self.totalTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fullScreenBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{@"playBtn":self.playBtn,@"currentTime":self.currentTimeLabel,@"slider":self.slider,@"totalTime":self.totalTimeLabel,@"fullScreenBtn":self.fullScreenBtn};
    
    NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[playBtn(25)]-10-[currentTime]-5-[slider]-5-[totalTime]-10-[fullScreenBtn(==playBtn)]-15-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views];
    NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[playBtn]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
    [self addConstraints:constraintsH];
    [self addConstraints:constraintsV];
}

- (void)setPlaying:(BOOL)playing {
    _playing = playing;
    self.playBtn.selected = playing;
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    self.fullScreenBtn.selected = fullScreen;
}

- (void)setTotalTime:(NSInteger)totalTime {
    _totalTime = totalTime;
    self.totalTimeLabel.text = [self handelTime:totalTime];
}

- (void)setCurrentTime:(NSInteger)currentTime {
    _currentTime = currentTime;
    self.currentTimeLabel.text = [self handelTime:currentTime];
    if (!self.operationing) {
        self.slider.value = _currentTime*1.0/self.totalTime;
    }
}

- (void)palyAction {
    self.playBtn.selected = !self.playBtn.selected;
    self.playing = self.playBtn.selected;
    if ([self.delegate respondsToSelector:@selector(playAction:)]) {
        [self.delegate playAction:self.playBtn.selected];
    }
}

- (void)fullScreenAction {
    self.fullScreenBtn.selected = !self.fullScreenBtn.selected;
    self.fullScreen = self.fullScreenBtn.selected;
    if ([self.delegate respondsToSelector:@selector(fullScreenAction:)]) {
        [self.delegate fullScreenAction:self.fullScreenBtn.selected];
    }
}

- (NSString *)handelTime:(NSInteger)time {
    if (time >= 0 && time< 60) {
        return [NSString stringWithFormat:@"00:%02zd",time];
    }else if (time >= 60 && time < 3600) {
        NSInteger minutes = time/60;
        NSInteger second = time%60;
        return [NSString stringWithFormat:@"%02zd:%02zd",minutes,second];
    }else {
        NSInteger hours = time/3600;
        NSInteger minutes = (time%3600)/60;
        NSInteger second = (time%3600)%60;
       return [NSString stringWithFormat:@"%02zd:%02zd:%02zd",hours,minutes,second];
    }
}

- (void)tapDown {
    _operationing = YES;
    if ([self.delegate respondsToSelector:@selector(slideTaped:value:)]) {
        [self.delegate slideTaped:_operationing value:self.slider.value];
    }
    NSLog(@"按下");
}

- (void)tapCancel {
    _operationing = NO;
    if ([self.delegate respondsToSelector:@selector(slideTaped:value:)]) {
        [self.delegate slideTaped:_operationing value:self.slider.value];
    }
    NSLog(@"抬起");
}

#pragma mark - 懒加载

- (UISlider *)slider {
    if (_slider == nil) {
        _slider = [[UISlider alloc] init];
        [_slider setThumbImage:[UIImage imageNamed:@"video_toolbar_thumb"] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(tapDown) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(tapCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slider;
}

- (UILabel *)currentTimeLabel {
    if (_currentTimeLabel == nil) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.text = @"00:00";
        _currentTimeLabel.font = [UIFont systemFontOfSize:10];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (UILabel *)totalTimeLabel {
    if (_totalTimeLabel == nil) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.text = @"00:00";
        _totalTimeLabel.font = [UIFont systemFontOfSize:10];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)playBtn {
    if (_playBtn == nil) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"video_toolbar_play"] forState:UIControlStateNormal];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"video_toolbar_pause"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(palyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)fullScreenBtn {
    if (_fullScreenBtn == nil) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"video_toolbar_zoomOut"] forState:UIControlStateNormal];
        [_fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"video_toolbar_zoomIn"] forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

@end
