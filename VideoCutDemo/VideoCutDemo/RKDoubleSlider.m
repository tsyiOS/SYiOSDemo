//
//  RKDoubleSlider.m
//  VideoCutterDemo
//
//  Created by leju_esf on 17/3/1.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "RKDoubleSlider.h"

@interface RKDoubleSlider ()
@property (nonatomic,strong) UIImageView *first;
@property (nonatomic,strong) UIImageView *second;
@end

@implementation RKDoubleSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 30)])
    {
        self.backgroundColor = [UIColor clearColor];
        [self first];
        [self second];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    
    self.first.center = CGPointMake( ((self.firstValue - self.minmumValue)/(self.maxmumValue - self.minmumValue)) *self.frame.size.width, 15);
    self.second.center = CGPointMake( ((self.secondValue - self.minmumValue)/(self.maxmumValue - self.minmumValue)) *self.frame.size.width, 15);
    
    CGFloat value1 = self.firstValue > self.secondValue ? self.secondValue:self.firstValue;
    CGFloat value2 = self.firstValue > self.secondValue ? self.firstValue : self.secondValue;
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    CGFloat minumTrackWidth = ((value1 - self.minmumValue)/(self.maxmumValue - self.minmumValue))  * self.frame.size.width;
    CGRect minumTrackRect = CGRectMake(0, 14, minumTrackWidth, 2);
    CGContextSetFillColorWithColor(ref, self.minimumTrackTintColor.CGColor);
    CGContextFillRect(ref, minumTrackRect);
    
    
    CGFloat thumbWidth = ((value2 - value1)/(self.maxmumValue - self.minmumValue)) * self.frame.size.width;
    CGContextSetFillColorWithColor(ref, self.thumbTintColor.CGColor);
    CGRect thumbRect = CGRectMake(minumTrackWidth, 14, thumbWidth, 2);
    CGContextFillRect(ref, thumbRect);
    
    
    CGRect maxumTrackRect = CGRectMake(minumTrackWidth + thumbWidth, 14, self.frame.size.width - minumTrackWidth - thumbWidth, 2);
    CGContextSetFillColorWithColor(ref, self.maximumTrackTintColor.CGColor);
    CGContextFillRect(ref, maxumTrackRect);
    
    CGPDFContextClose(ref);
}
#pragma mark - Target
- (void)panHappen:(UIPanGestureRecognizer *)pan
{
    
    CGPoint point = [pan translationInView:self];
    
    CGPoint center = pan.view.center;
    
    center.x += point.x;
    if (center.x > 0 && center.x < self.frame.size.width)
    {
        pan.view.center = center;
        if (self.first.center.x >= self.second.center.x) {
            self.first.center = center;
            self.second.center = center;
        }
    }
    [pan setTranslation:CGPointMake(0, 0) inView:self];
    
    self.firstValue = (_first.center.x/self.frame.size.width) * (self.maxmumValue - self.minmumValue) + self.minmumValue;
    self.secondValue = (_second.center.x/ self.frame.size.width) *(self.maxmumValue - self.minmumValue) + self.minmumValue;
    
    [self setNeedsDisplay];
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        if ([self.delegate respondsToSelector:@selector(sliderMoveActionFirstValue:andSecondValue:)]) {
            [self.delegate sliderMoveActionFirstValue:self.firstValue andSecondValue:self.secondValue];
        }
    }else if (pan.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(sliderEndActionFirstValue:andSecondValue:)]) {
            [self.delegate sliderEndActionFirstValue:self.firstValue andSecondValue:self.secondValue];
        }
    }
}
#pragma mark - getter
- (UIColor *)thumbTintColor
{
    if (!_thumbTintColor)
    {
        _thumbTintColor = [self colorWithHexInteger:0x1996fc alpha:1];
    }
    return _thumbTintColor;
}
- (UIColor *)minimumTrackTintColor
{
    if (!_minimumTrackTintColor) {
        _minimumTrackTintColor = [self colorWithHexInteger:0xe9e9e9 alpha:1];
    }
    return _minimumTrackTintColor;
}
- (UIColor *)maximumTrackTintColor
{
    if (!_maximumTrackTintColor)
    {
        _maximumTrackTintColor = [self colorWithHexInteger:0xe9e9e9 alpha:1];
    }
    return _maximumTrackTintColor;
}
- (UIImageView *)first
{
    if (!_first)
    {
        _first = [[UIImageView alloc] init];
        _first.userInteractionEnabled = YES;
        _first.bounds = CGRectMake(0, 0, 25, 25);
        _first.center = CGPointMake(0, 15);
        _first.layer.cornerRadius = 25.f/2.f;
        _first.backgroundColor = [UIColor whiteColor];
        [self addSubview:_first];
        [_first addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHappen:)]];
        [self setFirstSliderImg:nil];
    }
    return _first;
}
- (UIImageView *)second
{
    if (!_second)
    {
        _second = [[UIImageView alloc] init];
        _second.userInteractionEnabled = YES;
        _second.frame = CGRectMake(0, 0, 25, 25);
        _second.layer.cornerRadius = 25.f/2.f;
        _second.backgroundColor = [UIColor whiteColor];
        _second.center = CGPointMake(self.frame.size.width, 15);
        [_second addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHappen:)]];
        [self addSubview:_second];
        
        [self setSecondSliderImg:nil];
    }
    return _second;
}
#pragma mark - setter
- (void)setFirstSliderImg:(UIImage *)firstSliderImg
{
    if (firstSliderImg != _firstSliderImg)
    {
        _firstSliderImg = firstSliderImg;
    }
    if (_firstSliderImg == nil)
    {
        self.first.layer.shadowColor =  [UIColor colorWithWhite:0.3 alpha:1].CGColor;
        self.first.layer.shadowRadius = 3;
        self.first.layer.shadowOffset = CGSizeMake(0, 2);
        self.first.layer.shadowOpacity = 0.6;
    }
    else
    {
        self.first.image = firstSliderImg;
    }
}
- (void)setSecondSliderImg:(UIImage *)secondSliderImg
{
    if (_secondSliderImg != secondSliderImg)
    {
        _secondSliderImg = secondSliderImg;
    }
    if (_secondSliderImg == nil)
    {
        self.second.layer.shadowColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
        self.second.layer.shadowRadius = 3;
        self.second.layer.shadowOffset = CGSizeMake(0, 2);
        self.second.layer.shadowOpacity = 0.6;
    }
    else
    {
        self.second.image = _secondSliderImg;
    }
}
- (void)setFirstValue:(float)firstValue
{
    _firstValue = firstValue;
    [self setNeedsDisplay];
}
- (void)setSecondValue:(float)secondValue
{
    _secondValue = secondValue;
    [self setNeedsDisplay];
}
- (void)setMinmumValue:(float)minmumValue
{
    _minmumValue = minmumValue;
    [self setNeedsDisplay];
}
- (void)setMaxmumValue:(float)maxmumValue
{
    _maxmumValue = maxmumValue;
    [self setNeedsDisplay];
}
#pragma mark - Method
- (UIColor *)colorWithHexInteger:(NSInteger)hexInteger alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((hexInteger >> 16) & 0xFF)/255.0 green:((hexInteger >> 8) & 0xFF)/255.0 blue:((hexInteger) & 0xFF)/255.0 alpha:alpha];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (CGRectContainsPoint(self.bounds, point)) {
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if (CGRectContainsPoint(subView.frame, point)) {
            return YES;
        }
    }
    return NO;
}

@end
