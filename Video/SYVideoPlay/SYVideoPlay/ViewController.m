//
//  ViewController.m
//  SYVideoPlay
//
//  Created by leju_esf on 16/11/21.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "SYVideoController.h"
#import "SYLiveViewController.h"
#import "UIView+SYExtension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
}

- (IBAction)videoAction {
    SYVideoController *videoVc = [[SYVideoController alloc] init];
    [self.navigationController pushViewController:videoVc animated:YES];
}

- (IBAction)liveAction {
    SYLiveViewController *liveVc = [[SYLiveViewController alloc] init];
    [self.navigationController pushViewController:liveVc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
