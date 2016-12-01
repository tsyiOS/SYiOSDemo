//
//  ViewController.m
//  waveDemo
//
//  Created by leju_esf on 16/8/31.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "WaveView.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (nonatomic, strong) WaveView *wave;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wave = [[WaveView alloc] initWithFrame:CGRectMake(0, 250, ScreenW, 276*ScreenW/360)];
    [self.view addSubview:self.wave];
    self.wave.percent = 0.6;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//   
//    self.wave.percent += 0.2;
//     NSLog(@"%f",self.wave.percent);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
