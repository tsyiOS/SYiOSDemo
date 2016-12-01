//
//  SYTipMessage.m
//  SYTipMessage
//
//  Created by leju_esf on 16/9/29.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYTipMessage.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@implementation SYTipMessage
+ (void)showMessage:(NSString *)message {
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animation1.values = @[@(0.1),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6)];
    animation1.duration = 2.0f;
    animation1.rotationMode = kCAAnimationRotateAuto;
    
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animation2.values = @[@(0.6)];
    animation2.duration = 1.0f;
    animation2.rotationMode = kCAAnimationRotateAuto;
    
    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animation3.values = @[@(0.6),@(0.5),@(0.4),@(0.3),@(0.2),@(0.1),@(0.01)];
    animation3.duration = 1.0f;
    animation3.rotationMode = kCAAnimationRotateAuto;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animation2.beginTime = 2.0f;
    animation3.beginTime = 3.0f;
    animationGroup.duration = 4.0f;
    animationGroup.animations = @[animation1,animation2,animation3];
    
    UILabel *label = [[UILabel alloc] init];
    label.bounds = CGRectMake(0, 0, 200, 100);
    label.center = CGPointMake(ScreenW*0.5, ScreenH*0.5);
    label.layer.cornerRadius = 15;
    label.clipsToBounds = YES;
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [label.layer addAnimation:animationGroup forKey:@"alph"];
    label.layer.opacity = 0.01;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    });
}
@end
