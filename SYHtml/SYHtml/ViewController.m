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

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
// 播放m3u8格式，不要使用MPMoviePlayerController，否则切换全屏会有问题！
@property (nonatomic, strong) MPMoviePlayerViewController *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://photo.enterdesk.com/2010-10-24/enterdesk.com-3B11711A460036C51C19F87E7064FE9D.jpg"]];
}

- (IBAction)pushToListVC {
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
