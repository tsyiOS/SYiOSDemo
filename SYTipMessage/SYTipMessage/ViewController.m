//
//  ViewController.m
//  SYTipMessage
//
//  Created by leju_esf on 16/9/29.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "SYTipMessage.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tipMessage {
    [SYTipMessage showMessage:@"3G/2G状态下不显示图片"];
}

@end
