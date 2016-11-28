//
//  SYWaveViewController.m
//  SYCATextLayer
//
//  Created by leju_esf on 16/11/28.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYWaveViewController.h"
#import "SYWaveView.h"

@interface SYWaveViewController ()

@end

@implementation SYWaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SYWaveView *wave = [[SYWaveView alloc] initWithFrame:CGRectMake(60, 100, 200, 200)];
    wave.value = 0.8;
    [self.view addSubview:wave];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)dealloc {
    NSLog(@"消失了");
}

@end
