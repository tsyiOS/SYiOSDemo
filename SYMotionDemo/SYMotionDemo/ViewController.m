//
//  ViewController.m
//  SYMotionDemo
//
//  Created by leju_esf on 17/2/6.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *jsdLabel;
@property (weak, nonatomic) IBOutlet UILabel *lxyLabel;
@property (weak, nonatomic) IBOutlet UILabel *ccLabel;
@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) CAEmitterLayer *emitterLayer;
@property (nonatomic ,weak)UIView *backView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGRectGetHeight(self.view.frame))];
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    self.backView = backView;
    
    [self.backView.layer addSublayer:self.emitterLayer];
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (CAEmitterLayer *)emitterLayer{
    if (!_emitterLayer) {
        _emitterLayer = [CAEmitterLayer layer];
        //发射器在xy平面的中心位置
        _emitterLayer.emitterPosition = CGPointMake(CGRectGetWidth(self.backView.frame)/2, CGRectGetHeight(self.backView.frame) - 50);
        //发射器的尺寸大小
        _emitterLayer.emitterSize = CGSizeMake(20, 20);
        //渲染模式
        _emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
        NSMutableArray *array = [NSMutableArray array];
        // 创建粒子
        for (int i = 1; i < 5; i++) {
            // 发射单元
            CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
            // 粒子的创建速率，默认为1/s
            stepCell.birthRate = 1;
            // 粒子存活时间
            stepCell.lifetime = arc4random_uniform(4) + 4;
            // 粒子的生存时间容差
            stepCell.lifetimeRange = 1.5;
            UIImage *image = [UIImage imageNamed:@"good"];
            // 粒子显示的内容
            stepCell.contents = (id)[image CGImage];
            // 粒子的运动速度
            stepCell.velocity = arc4random_uniform(100) + 100;
            // 粒子速度的容差
            stepCell.velocityRange = 80;
            // 粒子在xy平面的发射角度
            stepCell.emissionLongitude = M_PI + M_PI_2;
            // 粒子发射角度的容差
            stepCell.emissionRange = M_PI_2 / 6;
            // 缩放比例
            stepCell.scale = 0.3;
            stepCell.scaleSpeed = 0.3;
            [array addObject:stepCell];
        }
        _emitterLayer.emitterCells = array;
        _emitterLayer.backgroundColor = [UIColor yellowColor].CGColor;
    }
    return _emitterLayer;
}


- (void)motionDemo {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    if (self.motionManager.accelerometerAvailable) {
        self.motionManager.accelerometerUpdateInterval = 0.1;
        [self.motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            if (error) {
                [self.motionManager stopAccelerometerUpdates];
                NSLog(@"获取加速度出现错误  %@",error);
            }else {
                //                [NSLog(@"加速度为\n------\nX轴：%+.2f\nY轴：%+.2f\nZ 轴：%+.2f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z);
                [self.jsdLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"加速度为\n------\nX轴：%+.2f\nY轴:%+.2f\nZ 轴:%+.2f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z] waitUntilDone:NO];
            }
        }];
    }else {
        NSLog(@"不支持");
    }
    
    //如果CMMotionManager的支持获取陀螺仪数据
    if (self.motionManager.gyroAvailable) {
        //设置CMMOtionManager的陀螺仪数据更新频率为0.1；
        self.motionManager.gyroUpdateInterval = 0.1;
        //使用代码块开始获取陀螺仪数据
        [self.motionManager startGyroUpdatesToQueue:queue withHandler:^(CMGyroData *gyroData, NSError *error) {
            NSString *labelText;
            // 如果发生了错误，error不为空
            if (error){
                // 停止获取陀螺仪数据
                [self.motionManager stopGyroUpdates];
                labelText = [NSString stringWithFormat:@"获取陀螺仪数据出现错误: %@", error];
            }else{
                // 分别获取设备绕X轴、Y轴、Z轴上的转速
                labelText = [NSString stringWithFormat: @"绕各轴的转速为\n--------\nX轴: %+.2f\nY轴: %+.2f\nZ轴:%+.2f",gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z];
            }
            // 在主线程中更新gyroLabel的文本，显示绕各轴的转速
            [self.lxyLabel performSelectorOnMainThread:@selector(setText:)withObject:labelText waitUntilDone:NO];
        }];
    }else{
        [self.lxyLabel performSelectorOnMainThread:@selector(setText:) withObject:@"该设备不支持获取陀螺仪数据！" waitUntilDone:NO];
    }
    
    
    //如果CMMotionManager的支持获取磁场数据
    if (self.motionManager.magnetometerAvailable) {
        //设置CMMotionManager的磁场数据更新频率为0.1秒
        self.motionManager.magnetometerUpdateInterval = 0.1;
        [self.motionManager startMagnetometerUpdatesToQueue:queue withHandler:^(CMMagnetometerData *magnetometerData, NSError *error) {
            NSString* labelText;
            //如果发生了错误 error不为空
            if (error) {
                //停止获取磁场数据
                [self.motionManager stopMagnetometerUpdates];
                labelText = [NSString stringWithFormat:@"获取磁场数据出现错误:%@",error];
            }else{
                labelText = [NSString stringWithFormat:@"磁场数据为\n--------\nX轴: %+.2f\nY轴: %+.2f\nZ轴:%+.2f",magnetometerData.magneticField.x,magnetometerData.magneticField.y,magnetometerData.magneticField.z];
            }
            //在主线程中更新magnetometerLabel的文本，显示磁场数据
            [self.ccLabel performSelectorOnMainThread:@selector(setText:) withObject:labelText waitUntilDone:NO];
        }];
    }else{
        [self.ccLabel performSelectorOnMainThread:@selector(setText:) withObject:@"该设备不支持获取磁场数据！" waitUntilDone:NO];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CMMotionManager *)motionManager {
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return _motionManager;
}
@end
