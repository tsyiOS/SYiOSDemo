//
//  ViewController.m
//  SYLotteryTest
//
//  Created by leju_esf on 17/1/20.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "SYWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)lotteryAction {
    SYWebViewController *webVc = [[SYWebViewController alloc] initWithNibName:NSStringFromClass([SYWebViewController class]) bundle:nil];
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
