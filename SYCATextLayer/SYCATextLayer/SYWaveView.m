//
//  SYWaveView.m
//  SYCATextLayer
//
//  Created by leju_esf on 16/11/25.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYWaveView.h"

@interface SYWaveView ()
@property (nonatomic, strong) CAShapeLayer *waveLayer;
@property (nonatomic, strong) CADisplayLink *waveDisplaylink;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGFloat lastValue;
@property (nonatomic, assign) CGFloat valueMargin;
@end

@implementation SYWaveView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _waveAmplitude = 30.0;
        _waveCycle = 200.0;
        _waveSpeed = 0.2;
        _waveColor = [UIColor redColor];
        _lastValue =  0.5;
        _value = 0.5;
        _valueMargin = 0;
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.clipsToBounds = YES;
       
        [self.layer addSublayer:self.waveLayer];
        _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startWave)];
        [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)setWaveColor:(UIColor *)waveColor {
    _waveColor = waveColor;
    self.waveLayer.fillColor = waveColor.CGColor;
}

- (void)setValue:(CGFloat)value {
    self.lastValue = value>1.0?1.0:value;
    NSLog(@"Value=%f",value);
    self.valueMargin = (self.lastValue - self.value)/100;
    NSLog(@"valueMargin=%f",self.valueMargin);
}

- (void)startWave {
    self.offsetX += self.waveSpeed;
    NSLog(@"%f---%f",self.value,self.lastValue);
    if (self.value != self.lastValue) {
        _value += self.valueMargin;
    }else if (self.value > self.lastValue) {
        _value = self.lastValue;
    }
    UIBezierPath *path = [[UIBezierPath alloc] init];
    for (int x = 0; x <= self.frame.size.width; x++) {
        CGFloat y = self.waveAmplitude*sin(2*M_PI*x/self.waveCycle - self.offsetX) + self.frame.size.height*(1-self.value) - self.waveAmplitude;
        if (x == 0) {
            [path moveToPoint:CGPointMake(x, y)];
        }else {
            [path addLineToPoint:CGPointMake(x, y)];
        }
    }
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path closePath];
    
    self.waveLayer.path = path.CGPath;
}


- (CAShapeLayer *)waveLayer {
    if (_waveLayer == nil) {
        _waveLayer = [CAShapeLayer layer];
        _waveLayer.fillColor = self.waveColor.CGColor;
    }
    return _waveLayer;
}


@end
