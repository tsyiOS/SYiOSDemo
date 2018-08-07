//
//  ViewController.m
//  SYDynamicDemo
//
//  Created by leju_esf on 2018/8/6.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "STBallView.h"

@interface ViewController ()<UIDynamicAnimatorDelegate,UIAccelerometerDelegate>
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) CMMotionManager *manager;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;

@property(strong,nonatomic)STBallView *ballView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.redView];
    [self demo1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.view];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, -1, 50, 50)];
    imageView.image = [UIImage imageNamed:@"ball"];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.layer.cornerRadius = 25;
    imageView.clipsToBounds = YES;
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, 46, 46)];
    [bg addSubview:imageView];
    [self.view addSubview:bg];
    [_gravity addItem:bg];
    [_collision addItem:bg];
    
//    UITouch *touch = touches.anyObject;
//    CGPoint point = [touch locationInView:self.view];
//    CGFloat random = arc4random()%100;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, 50 + random, 50 + random)];
//    view.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:view];
//    [_gravity addItem:view];
//    [_collision addItem:view];
    
}

- (void)demo1 {
    _gravity = [[UIGravityBehavior alloc] init];
    _gravity.magnitude = 0.8;
//    [_gravity addItem:self.redView];
    
    // 重力方向
    //    gravity.gravityDirection = CGVectorMake(100, 100);
    // 重力加速度()
//    gravity.magnitude = 10;
    
    [self.animator addBehavior:_gravity];
    
    _collision = [[UICollisionBehavior alloc] init];
    [_collision addItem:self.redView];
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:_collision];
    
    if (self.manager.gyroAvailable) {
        self.manager.gyroUpdateInterval = 0.1;
        __weak typeof(self) weakSelf = self;
        [self.manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            double rotation = atan2(motion.gravity.x, motion.gravity.y);
            weakSelf.gravity.angle = rotation - M_2_PI * 2;
//            weakSelf.redView.frame = CGRectMake(100, 100, 100, 50);
        }];
    }
    
    UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:self.redView attachedToAnchor:self.redView.center];
    [_animator addBehavior:attachment];
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_redView]];
    itemBehavior.allowsRotation = NO;
    [_animator addBehavior:itemBehavior];
}

- (void)demo2 {
    self.ballView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.ballView];
    
    self.manager.deviceMotionUpdateInterval = 1 /60;
    
    [self.manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        self.ballView.accelleration = motion.gravity;
        //    开启主队列异步线程，更新球的位置。
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.ballView updateLocation];
            
        });
        
        
    }];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    
}

- (UIDynamicAnimator *)animator {
    if (_animator == nil) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

- (UIView *)redView {
    if (_redView == nil) {
        _redView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
        _redView.center = self.view.center;
        _redView.backgroundColor = [UIColor blueColor];
    }
    
    return _redView;
}

- (CMMotionManager *)manager
{
    if (!_manager) {
//        updateInterval = 1.0/15.0;
        _manager = [[CMMotionManager alloc] init];
    }
    return _manager;
}

- (STBallView *)ballView{
    if (!_ballView) {
        _ballView = [[STBallView alloc] initWithFrame:self.view.bounds];
    }
    return _ballView;
}

@end
