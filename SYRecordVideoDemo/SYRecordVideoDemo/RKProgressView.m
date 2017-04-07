//
//  RKProgressView.m
//  SYRecordVideoDemo
//
//  Created by leju_esf on 17/3/27.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "RKProgressView.h"
#import "ZZCircleProgress.h"
@interface RKProgressView ()
@property (nonatomic, strong) ZZCircleProgress *circle;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation RKProgressView

+ (instancetype)progressView {
    RKProgressView *progress = [[RKProgressView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [progress addSubview:progress.imageView];
    [progress addSubview:progress.circle];
    return progress;
 }

- (void)setProgress:(CGFloat)progress {
    self.circle.progress = progress;
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
}

- (void)dismiss {
    self.circle.progress = 0;
    [self removeFromSuperview];
}

- (ZZCircleProgress *)circle {
    if (_circle == nil) {
        _circle = [[ZZCircleProgress alloc] initWithFrame:CGRectMake((self.frame.size.width - 100)*0.5,(self.frame.size.height - 100)*0.5,100,100) pathBackColor:[UIColor lightGrayColor] pathFillColor:[UIColor whiteColor] startAngle:0 strokeWidth:10];
        _circle.animationModel = CircleIncreaseSameTime;
        _circle.showProgressText = YES;
    }
    return _circle;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image= [UIImage imageNamed:@"progressBg"];
    }
    return _imageView;
}
@end
