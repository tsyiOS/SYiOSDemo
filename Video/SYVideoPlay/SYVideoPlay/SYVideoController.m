//
//  SYVideoController.m
//  SYVideoPlay
//
//  Created by leju_esf on 16/11/22.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYVideoController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SYVideoToolBar.h"

@interface SYVideoController ()
@property (nonatomic, assign) UIDeviceOrientation lastOrientation;

@end

@implementation SYVideoController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.lastOrientation = [UIDevice currentDevice].orientation;
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIDeviceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIDeviceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInt:self.lastOrientation];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
