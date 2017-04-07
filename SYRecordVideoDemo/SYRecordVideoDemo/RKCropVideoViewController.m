//
//  RKCropVideoViewController.m
//  SYRecordVideoDemo
//
//  Created by leju_esf on 17/3/23.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "RKCropVideoViewController.h"
#import "SYVideoModel.h"
#import <AVFoundation/AVFoundation.h>
#import "RKProgressView.h"

#define ItemW 60
//一屏显示的帧数
#define MaxCount 20

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface RKCropVideoViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startLabelLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endLabelRightMargin;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (nonatomic, assign) double totalTime;
@property (nonatomic, assign) double startTime;
@property (nonatomic, assign) double endTime;
@property (nonatomic, assign) CMTime duration;
@property (nonatomic, strong) RKProgressView *progressView;
//裁剪
@property (strong, nonatomic) AVAssetExportSession *exportSession;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *cropTimer;
//播放器
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@end

@implementation RKCropVideoViewController

-(void)viewDidAppear:(BOOL)animated{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"裁剪视频";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"裁剪" style:UIBarButtonItemStylePlain target:self action:@selector(cropAction)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.minTime = 0;
    self.maxTime = 60;
    
    NSArray *list = [SYVideoModel videoList];
    SYVideoModel *model = list.firstObject;
    self.path = model.path;
}
#pragma mark - 裁剪
- (void)cropAction {
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.path]) {
        return;
    }
    
    if (self.totalTime == 0) {
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask , YES)objectAtIndex:0];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    
    if([freeSpace doubleValue] < [[NSFileManager defaultManager] attributesOfItemAtPath:self.path error:nil].fileSize) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法裁剪" message:@"存储空间不足,请清理后重新剪切!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    AVAsset *mediaAsset = self.player.currentItem.asset;
    self.exportSession = [[AVAssetExportSession alloc] initWithAsset:mediaAsset presetName:AVAssetExportPresetPassthrough];
    NSString *outPath = [[self.path substringToIndex:self.path.length - 4] stringByAppendingString:@"new.mp4"];
    [fileManager removeItemAtPath:outPath error:NULL];
    
    //格式的转换
    self.exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    self.exportSession.outputURL = [[NSURL alloc] initFileURLWithPath:outPath];
    self.exportSession.shouldOptimizeForNetworkUse=NO;
    CMTime start = CMTimeMakeWithSeconds(self.startTime, self.duration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(self.endTime - self.startTime, self.duration.timescale);
    CMTimeRange range = CMTimeRangeMake(start, duration);
    self.exportSession.timeRange = range;
    //音频的时间范围
    self.exportSession.timeRange = range;
  
    [self.cropTimer fire];
    [self.progressView show];
    
    __weak typeof(self) weakSelf = self;
    [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        if(weakSelf.exportSession.status == AVAssetExportSessionStatusCompleted ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [fileManager removeItemAtPath:self.path error:NULL];
                self.progressView.progress = 1.0;
                [self.progressView dismiss];
            });
            NSLog(@"裁剪完成");
            SYVideoModel *model = [[SYVideoModel alloc] init];
            model.path = outPath;
            model.totalTime = self.endTime - self.startTime;
            [SYVideoModel saveVideo:model];
            
        }else {
            NSLog(@"裁剪失败");
            [fileManager removeItemAtPath:outPath error:NULL];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressView dismiss];
            });
        }
    }];
}

#pragma mark - 定时器方法
- (void)updateExportDisplay {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = self.exportSession.progress;
    });
    if (self.exportSession.progress >= 0.99) {
        [self.cropTimer invalidate];
        
    }
}

- (void)getCurrentTimeWhenPlaying {
    double currentTime = CMTimeGetSeconds(self.player.currentTime);
    if (currentTime >= self.endTime) {
        [self.player pause];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - set方法
- (void)setPath:(NSString *)path {
    _path = path;
    self.totalTime = [self videoTotalTimeWithPath:path];
    self.startTime = 0.0;
    self.endTime = MIN(self.totalTime, self.maxTime);
    if (_totalTime > 0) {
        if (_totalTime > self.maxTime) {
            NSInteger marginTime = self.maxTime/MaxCount;
            NSInteger count = MaxCount +floor((_totalTime - self.maxTime)/marginTime);
            for (int i = 0; i < count; i++) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(ScreenW/MaxCount), 0, ItemW, 95)];
                [self.scrollView addSubview:imageView];
                [self creatImageForImageView:imageView atTime:marginTime * i];
            }
            self.scrollView.contentSize = CGSizeMake((count-1) *(ScreenW/MaxCount) +ItemW, 95);
            self.scrollView.bounces = NO;
        }else {
            double marginTime = _totalTime/MaxCount;
            for (int i = 0; i < MaxCount; i++) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(ScreenW/MaxCount), 0, ItemW, 95)];
                [self.scrollView addSubview:imageView];
                [self creatImageForImageView:imageView atTime:marginTime * i];
            }
        }
    
        NSURL *sourceMovieUrl = [NSURL fileURLWithPath:path];
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieUrl options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];

        self.player = [AVPlayer playerWithPlayerItem:playerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
        NSArray *tracks = [movieAsset tracksWithMediaType:AVMediaTypeVideo];
        if(tracks.count> 0) {
            AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
            CGFloat height = ScreenW *videoTrack.naturalSize.height/videoTrack.naturalSize.width;
            self.playerLayer.frame =CGRectMake(0, (ScreenH - height)*0.5, ScreenW, height);
        }

        self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        self.playerLayer.videoGravity =AVLayerVideoGravityResizeAspect;
        [self.view.layer addSublayer:self.playerLayer];
        [self.view.layer insertSublayer:self.playerLayer atIndex:0];
    }
}

- (void)setTotalTime:(double)totalTime {
    _totalTime  = totalTime;
    self.totalTimeLabel.text = [self timeStringWithTime:totalTime];
    self.startLabel.text = @"00:00";
    self.endLabel.text = self.totalTimeLabel.text;
}

- (void)setStartTime:(double)startTime {
    _startTime = startTime;
     self.startLabel.text = [self timeStringWithTime:startTime];
    CMTime time = CMTimeMakeWithSeconds(startTime, self.duration.timescale);
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)setEndTime:(double)endTime {
    _endTime = endTime;
    self.endLabel.text = [self timeStringWithTime:endTime];
}

- (NSString *)timeStringWithTime:(double)time {
    NSInteger timeInt = (NSInteger)time;
    if (timeInt < 60) {
        return  [NSString stringWithFormat:@"00:%02zd",timeInt];
    }else {
        return [NSString stringWithFormat:@"%02zd:%02zd",timeInt/60,timeInt%60];
    }
}

- (void)creatImageForImageView:(UIImageView *)imageView atTime:(double)time {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [self thumbnailImageAtTime:time];
        NSLog(@"创建图片%@",image == nil?@"失败":@"成功");
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
            });
        }
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.startTime = (scrollView.contentOffset.x + self.startLabelLeftMargin.constant)/scrollView.contentSize.width * self.totalTime;
    self.endTime = self.startTime + (ScreenW - self.startLabelLeftMargin.constant - self.endLabelRightMargin.constant)/ScreenW *self.maxTime;
}

- (IBAction)playAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player play];
        [self.timer fire];
    }else{
        [self.player pause];
        [self.timer invalidate];
    }
}

- (IBAction)panLeftBtnAction:(UIPanGestureRecognizer *)sender {
    if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        [self playAction:self.playBtn];
    }
  
    CGPoint point = [sender locationInView:sender.view.superview];
    NSLog(@"左边%f---%d",point.x,self.endTime - self.startTime == self.minTime);
    if ((self.endTime - self.startTime == self.minTime && point.x < self.startLabelLeftMargin.constant)||self.endTime - self.startTime > self.minTime) {
        if (point.x >= 0 && self.totalTime > 0) {
            self.startLabelLeftMargin.constant = point.x < 3 ? 0:point.x;
            if (self.totalTime > self.maxTime) {
                self.startTime = (self.scrollView.contentOffset.x + self.startLabelLeftMargin.constant)/self.scrollView.contentSize.width  * self.totalTime;
            }else {
                self.startTime = self.startLabelLeftMargin.constant/ScreenW*self.totalTime;
            }
        }
    }else {
        self.startTime = self.endTime - self.minTime;
    }
}
- (IBAction)panRigthBtnAction:(UIPanGestureRecognizer *)sender {
    if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        [self playAction:self.playBtn];
    }
   
    CGPoint point = [sender locationInView:sender.view.superview];
    NSLog(@"右边%f---%d",point.x,self.endTime - self.startTime == self.minTime);
    if ((self.endTime - self.startTime == self.minTime && point.x > ScreenW - self.startLabelLeftMargin.constant)||self.endTime - self.startTime > self.minTime) {
        if (point.x <= ScreenW && self.totalTime > 0) {
            self.endLabelRightMargin.constant = [UIScreen mainScreen].bounds.size.width -  point.x < 3 ? 0 :  [UIScreen mainScreen].bounds.size.width -  point.x;
            if (self.totalTime > self.maxTime) {
                self.endTime = self.startTime + (ScreenW - self.startLabelLeftMargin.constant - self.endLabelRightMargin.constant )/ScreenW *self.maxTime;
            }else {
                self.endTime = (1 - self.endLabelRightMargin.constant /ScreenW) *self.totalTime;
            }
        }
     }else {
         self.endTime = self.startTime + self.minTime;
    }
}



- (UIImage*) thumbnailImageAtTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:self.path] options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 50) actualTime:NULL error:&thumbnailImageGenerationError];
    
 //   int32_t preferredTimeScale = 600;
    CMTime inTime = CMTimeMakeWithSeconds(time, self.duration.timescale);
    
    CGImageRef image = [assetImageGenerator copyCGImageAtTime:inTime actualTime:&inTime error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:image] : nil;
    
    return thumbnailImage;
}

- (double)videoTotalTimeWithPath:(NSString *)path {
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    self.duration = [asset duration];
    return CMTimeGetSeconds(self.duration);
}

- (NSTimer *)timer {
    if (_timer == nil) {
        __weak typeof(self) weakSelf = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:weakSelf selector:@selector(getCurrentTimeWhenPlaying) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (NSTimer *)cropTimer {
    if (_cropTimer == nil) {
        __weak typeof(self) weakSelf = self;
        _cropTimer =  [NSTimer scheduledTimerWithTimeInterval:0.5 target:weakSelf selector:@selector(updateExportDisplay) userInfo:nil repeats:YES];
    }
    return _cropTimer;
}

- (RKProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [RKProgressView progressView];
    }
    return _progressView;
}

- (void)dealloc {
    NSLog(@"裁剪视频消失");
}
@end
