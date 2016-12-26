//
//  ViewController.m
//  SYHtml
//
//  Created by leju_esf on 16/11/15.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "ViewController.h"

#import "SYHtmlManager.h"
#import "SYListViewController.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SYVerifyViewController.h"

@interface ViewController ()<UIWebViewDelegate>
// 播放m3u8格式，不要使用MPMoviePlayerController，否则切换全屏会有问题！
@property (nonatomic, strong) MPMoviePlayerViewController *player;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.imageView startAnimating];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.imageView stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 1; i < 15; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"DM%03d",i]];
        [tempArray addObject:image];
    }
    self.imageView.animationImages = tempArray;
    self.imageView.animationDuration = 1.0;
    self.imageView.animationRepeatCount = MAXFLOAT;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToListVC)];
    [self.imageView addGestureRecognizer:tap];
    
    //NSDate *currentdate = [NSDate date];
    //NSDate *lastDate = [NSUserDefaults standardUserDefaults] objectForKey:@"become"
    
    SYVerifyViewController *verifyVc = [[SYVerifyViewController alloc] initWithNibName:NSStringFromClass([SYVerifyViewController class]) bundle:nil];
    [self presentViewController:verifyVc animated:YES completion:nil];
}

- (void)pushToListVC {
    SYListViewController *listVC = [[SYListViewController alloc] initWithNibName:NSStringFromClass([SYListViewController class]) bundle:nil];
    listVC.type = SYHtmlTypeAllList;
    [self.navigationController pushViewController:listVC animated:YES];
}
//http://live.3gv.ifeng.com/live/zixun.m3u8?fmt=x264_0k_mpegts&size=320x240

//http://live.3gv.ifeng.com/live/zixun.m3u8
- (IBAction)click {
    NSURL *url = [NSURL URLWithString:@"http://live.3gv.ifeng.com/live/zixun.m3u8?fmt=x264_0k_mpegts&size=320x240"];
    self.player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    
    // modal显示视频播放器
    [self presentViewController:self.player animated:YES completion:nil];
}

@end
