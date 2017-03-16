//
//  ViewController.m
//  SYRecordVideoDemo
//
//  Created by leju_esf on 17/3/15.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "SYRecordVideoController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SYVideoListController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)recordVideo {
    SYRecordVideoController *recordVc = [[SYRecordVideoController alloc] initWithNibName:NSStringFromClass([SYRecordVideoController class]) bundle:nil];
    [self.navigationController pushViewController:recordVc animated:YES];
}

- (IBAction)videoList {
    SYVideoListController *videoList = [[SYVideoListController alloc] initWithNibName:NSStringFromClass([SYVideoListController class]) bundle:nil];
    [self.navigationController pushViewController:videoList animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
