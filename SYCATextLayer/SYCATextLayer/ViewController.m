//
//  ViewController.m
//  SYCATextLayer
//
//  Created by leju_esf on 16/11/25.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+SYExtension.h"
#import "SYLabel.h"
#import "SYWaveView.h"
#import "SYWaveViewController.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) CATextLayer *textLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)demo2 {
    SYLabel *label = [[SYLabel alloc] initWithFrame:CGRectMake(10, 20, 100, 100)];
    label.text = @"描述如何将字符串截断以适应图层大小，设置缩短的部位，可选择没有，开始，中间，和结束";
    [self.view addSubview:label];
}

- (void)demo1 {
    [self.view addSubview:self.startBtn];
    self.view.backgroundColor = [UIColor brownColor];
    [self.view.layer addSublayer:self.textLayer];
    [self.view.layer addSublayer:self.gradientLayer];
}

- (void)clickBtn {
    //动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint fromPoint = self.textLayer.position;
    CGPoint toPoint = CGPointMake(210, fromPoint.y);
    animation.duration = 1;
    animation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    animation.autoreverses = YES;
    animation.repeatCount = MAXFLOAT;
    [self.textLayer addAnimation:animation forKey:nil];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint fromPoint2 = self.gradientLayer.position;
    CGPoint toPoint2 = CGPointMake(110, fromPoint2.y);
    animation2.duration = 1;
    animation2.fromValue = [NSValue valueWithCGPoint:fromPoint2];
    animation2.toValue = [NSValue valueWithCGPoint:toPoint2];
    animation2.autoreverses = YES;
    animation2.repeatCount = MAXFLOAT;
    [self.gradientLayer addAnimation:animation2 forKey:nil];

}
- (IBAction)waveAction {
    SYWaveViewController *waveVc = [[SYWaveViewController alloc] init];
    [self.navigationController pushViewController:waveVc animated:YES];
}

- (CATextLayer *)textLayer {
    if (_textLayer == nil) {
        _textLayer = [CATextLayer layer];
        _textLayer.frame = CGRectMake(50, 20, self.view.frame.size.width-100, 50);
        _textLayer.foregroundColor = [UIColor blackColor].CGColor;
        _textLayer.alignmentMode = kCAAlignmentJustified;
        _textLayer.wrapped = YES;
        _textLayer.truncationMode = kCATruncationEnd;
        UIFont *font = [UIFont systemFontOfSize:30];
        _textLayer.font = CGFontCreateWithFontName( (__bridge CFStringRef)font.fontName);
        _textLayer.fontSize = font.pointSize;
        _textLayer.string = @"习惯不曾习惯的习惯会习惯 舍得不曾舍得的舍得会舍得";
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _textLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (_gradientLayer == nil) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = [NSArray arrayWithObjects:
                                 (id)[[UIColor sy_colorWithRGB:0x000000] CGColor],
                                 (id)[[UIColor sy_colorWithRGB:0xFFD700] CGColor],
                                 (id)[[UIColor sy_colorWithRGB:0x000000] CGColor],
                                 (id)[[UIColor sy_colorWithRGB:0xFFD700] CGColor],
                                 (id)[[UIColor sy_colorWithRGB:0x000000] CGColor],
                                 (id)[[UIColor sy_colorWithRGB:0xFFD700] CGColor],
                                 (id)[[UIColor sy_colorWithRGB:0x000000] CGColor],
                                 (id)[[UIColor sy_colorWithRGB:0xFFD700] CGColor],
                                 (id)[[UIColor sy_colorWithRGB:0x000000] CGColor],
                                 (id)[[UIColor sy_colorWithRGB:0xFFD700] CGColor],
                                 (id)[[UIColor sy_colorWithRGB:0x000000] CGColor],
                                 (id)[[UIColor clearColor] CGColor],
                                 nil];
        _gradientLayer.locations = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0],
                                    [NSNumber numberWithFloat:0.1],
                                    [NSNumber numberWithFloat:0.2],
                                    [NSNumber numberWithFloat:0.3],
                                    [NSNumber numberWithFloat:0.4],
                                    [NSNumber numberWithFloat:0.5],
                                    [NSNumber numberWithFloat:0.6],
                                    [NSNumber numberWithFloat:0.7],
                                    [NSNumber numberWithFloat:0.8],
                                    [NSNumber numberWithFloat:0.9],
                                    [NSNumber numberWithFloat:1.0],
                                    nil];
        _gradientLayer.frame = self.view.bounds;

    }
    [_gradientLayer setStartPoint:CGPointMake(0, 0)];
    [_gradientLayer setEndPoint:CGPointMake(1, 1)];
    [_gradientLayer setMask:self.textLayer]; //用progressLayer来截取渐变层
    return _gradientLayer;
}


- (UIButton *)startBtn {
    if (_startBtn == nil) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40);
        [_startBtn setTitle:@"开始动画" forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        [_startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _startBtn;
}
@end
