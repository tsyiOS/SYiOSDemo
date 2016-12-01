//
//  WaveView.m
//  waveDemo
//
//  Created by leju_esf on 16/8/31.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "WaveView.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface WaveView ()
@property (nonatomic, strong) UIImageView *waveImageView1;
@property (nonatomic, strong) UIImageView *waveImageView2;
@property (nonatomic, strong) UIImageView *kityImageView;
@end

@implementation WaveView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.waveImageView1];
        [self addSubview:self.waveImageView2];
        [self addSubview:self.kityImageView];
        [self actionWave];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setPercent:(double)percent {
    if (percent > 1.0) {
        percent = 1.0;
    }
    _percent = percent;
    [UIView animateWithDuration:1.5 animations:^{
        self.waveImageView1.frame = CGRectMake(0, self.frame.size.height*0.82 -  self.waveImageView1.frame.size.height*percent, self.waveImageView1.frame.size.width, self.waveImageView1.frame.size.height);
        self.waveImageView2.frame = CGRectMake((-1)*self.frame.size.width, self.frame.size.height*0.82 -  self.waveImageView2.frame.size.height*percent, self.waveImageView2.frame.size.width, self.waveImageView2.frame.size.height);
    }];
}

- (void)actionWave {
    [self addAnimationForView:self.waveImageView1];
    [self addAnimationForView:self.waveImageView2];
}

- (void)addAnimationForView:(UIImageView *)imageView {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:imageView.center];
    [path addLineToPoint:CGPointMake(imageView.center.x + self.frame.size.width,imageView.center.y)];
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    moveAnimation.path = path.CGPath;
    moveAnimation.duration = 2.0f;
    moveAnimation.repeatCount = MAXFLOAT;
    [imageView.layer addAnimation:moveAnimation forKey:@"moveAnimation"];
}

- (UIImageView *)waveImageView1 {
    if (_waveImageView1 == nil) {
        _waveImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height*0.82, self.frame.size.width, self.frame.size.height*0.72)];
        _waveImageView1.image = [UIImage imageNamed:@"fb_wave"];
    }
    return _waveImageView1;
}

- (UIImageView *)waveImageView2 {
    if (_waveImageView2 == nil) {
        _waveImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake((-1)*self.frame.size.width,  self.frame.size.height*0.82, self.frame.size.width,  self.frame.size.height*0.72)];
        _waveImageView2.image = [UIImage imageNamed:@"fb_wave"];
    }
    return _waveImageView2;
}

- (UIImageView *)kityImageView {
    if (_kityImageView == nil) {
        _kityImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 1; i < 4; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%02d",i]];
            [tempArray addObject:image];
        }
        _kityImageView.animationImages = tempArray;
        _kityImageView.animationDuration =0.5;
        _kityImageView.animationRepeatCount = 0;
        [_kityImageView startAnimating];
    }
    return _kityImageView;
}

@end
