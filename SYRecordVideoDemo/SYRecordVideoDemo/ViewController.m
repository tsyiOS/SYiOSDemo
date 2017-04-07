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
#import "RKCropVideoViewController.h"
#import "SYVideoModel.h"
#import "RKProgressView.h"

@interface ViewController ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) float num;
@property (nonatomic, strong) RKProgressView *progress;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask , YES)objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    
    
    
    NSString *total = [NSString stringWithFormat:@"总空间为:%0.1fG",([totalSpace doubleValue])/1024.0/1024.0/1024.0];
    
    NSString *free = [NSString stringWithFormat:@"剩余:%0.1fG",([freeSpace doubleValue])/1024.0/1024.0/1024.0];
    
    NSString *use = [NSString stringWithFormat:@"已用:%0.1fG",([totalSpace doubleValue]-[freeSpace doubleValue])/1024.0/1024.0/1024.0];
    
    NSLog(@"total : %@, free : %@, use : %@",total,free,use);
    
}
- (IBAction)cropVideo {
    
    RKCropVideoViewController *cropVc = [[RKCropVideoViewController alloc] initWithNibName:NSStringFromClass([RKCropVideoViewController class]) bundle:nil];
    [self.navigationController pushViewController:cropVc animated:YES];

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

- (void)getCurrentTimeWhenPlaying {
    self.num += 0.01;
    self.progress.progress = self.num;
}

- (NSTimer *)timer {
    if (_timer == nil) {
        __weak typeof(self) weakSelf = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:weakSelf selector:@selector(getCurrentTimeWhenPlaying) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (RKProgressView *)progress {
    if (_progress == nil) {
        _progress = [RKProgressView progressView];
    }
    return _progress;
}


@end
