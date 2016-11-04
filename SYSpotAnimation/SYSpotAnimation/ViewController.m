//
//  ViewController.m
//  SYSpotAnimation
//
//  Created by leju_esf on 16/11/4.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "SYSpotAnimation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)action1:(UIButton *)sender {
    [SYSpotAnimation sy_animationWithOffset:15.0 onView:sender];
}
- (IBAction)action2:(UIButton *)sender {
    [SYSpotAnimation sy_animationWithOffset:-30.0 onView:sender];
}
- (IBAction)action3:(UIButton *)sender {
    [SYSpotAnimation sy_animationWithOffset:20 onView:sender];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
