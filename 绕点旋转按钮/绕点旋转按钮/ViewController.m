//
//  ViewController.m
//  绕点旋转按钮
//
//  Created by leju_esf on 16/7/5.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "ERFloatView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *imageNames = @[
                                 @"打卡",
                                 @"修改",
                                 @"周边",
                                 @"电话",
                                 @"日程",
                                 @"拜访",
                                 @"拜访",
                                 @"拜访"
                                 ];
    ERFloatView *floatView= [[ERFloatView alloc] initWithTitles:imageNames andFrame:CGRectMake(150, 200, 50, 50)];
    [self.view addSubview:floatView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
