//
//  ViewController.m
//  SYAnimationDemo
//
//  Created by leju_esf on 16/12/15.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *redview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    // 平移
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    anim.keyPath = @"position";
    
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(arc4random_uniform(200), arc4random_uniform(500))];
    
    // 缩放
    CABasicAnimation *anim1 = [CABasicAnimation animation];
    
    anim1.keyPath = @"transform.scale";
    
    // 0 ~ 1
    static CGFloat scale = 0.1;
    if (scale < 1) {
        scale = 1.5;
    }else{
        scale = 0.2;
    }
    anim1.toValue = @(scale);
    
    // 旋转
    CABasicAnimation *anim2 = [CABasicAnimation animation];
    
    anim2.keyPath = @"transform.rotation";
    
    anim2.toValue = @(arc4random_uniform(360) / 180.0 * M_PI);
    
    group.animations = @[anim,anim1,anim2];
    
    group.duration = 0.5;
    
    // 取消反弹
    // 告诉在动画结束的时候不要移除
    group.removedOnCompletion = NO;
    // 始终保持最新的效果
    group.fillMode = kCAFillModeForwards;
    
    [self.redview.layer addAnimation:group forKey:nil];
}

@end
