//
//  ViewController.m
//  VideoCutDemo
//
//  Created by leju_esf on 17/3/2.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "RKVideoCropManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZZCircleProgress.h"

@interface ViewController ()<RKVideoCropManagerDelegate>
@property (nonatomic, strong) RKVideoCropManager *manager;
/** 视频播放器 */
@property (weak, nonatomic) IBOutlet UIImageView *startImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *endImageView;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, strong) ZZCircleProgress *circle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPhotoAssets];
//    self.circle.hidden = YES;
}

- (IBAction)startCut {
    [self.manager startCut];
}

//- (void)completeCropVideoWithOutputPath:(NSString *)outputPath {
//    NSLog(@"裁剪完成:%@",outputPath);
//    MPMoviePlayerViewController  *movie = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:outputPath]];
//    [movie.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
//    [movie.moviePlayer prepareToPlay];
//    [self presentMoviePlayerViewControllerAnimated:movie];
//}

- (void)cropVideoWithProgress:(CGFloat)progress outputPath:(NSString *)outputPath complete:(BOOL)complete error:(NSError *)error {
//    self.circle.hidden = NO;
    self.circle.progress = progress;
    if (!error) {
        NSLog(@"百分比===%f",progress);
    }
    if (complete) {
        NSLog(@"裁剪完成:%@",outputPath);
//        self.circle.hidden = NO;
        self.circle.progress = 1.0;
        MPMoviePlayerViewController  *movie = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:outputPath]];
        [movie.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
        [movie.moviePlayer prepareToPlay];
        [self presentMoviePlayerViewControllerAnimated:movie];
    }
}

- (void)slideViewMoved:(RKVideoCropManager *)manager {
    self.startImageVIew.image = manager.startImage;
    self.endImageView.image = manager.endImage;
    self.startTimeLabel.text = [NSString stringWithFormat:@"%.f秒",manager.start];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%.f秒",manager.end];
}

- (void)playWithURL:(NSURL *)url {
    self.player.contentURL = url;
    // 播放
    [self.player play];
}


/**
 *  获取照片资源
 */
- (void)getPhotoAssets {
    ALAssetsLibrary *assetLibrary = [self defaultAssetsLibrary];
    __block NSMutableArray *groupPhotos = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    __block NSInteger i = 0;
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if(group){
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if(nil == result){
                    return ;
                }
                
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                    i = i + 1;
                    if (i == 10) {
                        weakSelf.manager.asset = result;
                        [weakSelf playWithURL:result.defaultRepresentation.url];
                        *stop = YES;

                    }
                }
                [groupPhotos addObject:result];
            }];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"error --- %@",error);
    }];
    
}
- (IBAction)playAction {
    [self.player play];
}

- (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (RKVideoCropManager *)manager {
    if (_manager == nil) {
        _manager = [[RKVideoCropManager alloc] init];
        _manager.delegate = self;
        _manager.sliderView.frame = CGRectMake(10, 300, 300, 30);
        [self.view addSubview:_manager.sliderView];
    }
    return _manager;
}

- (MPMoviePlayerController *)player {
    if (_player == nil) {
        _player = [[MPMoviePlayerController alloc] init];
        _player.view.frame = CGRectMake(0, 0, 320, 200);
        [self.view addSubview:_player.view];
    }
    return _player;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ZZCircleProgress *)circle {
    if (_circle == nil) {
        _circle = [[ZZCircleProgress alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100)*0.5,(self.view.frame.size.height - 100)*0.5 + 95,100,100) pathBackColor:[UIColor whiteColor] pathFillColor:[UIColor blackColor] startAngle:0 strokeWidth:10];
        _circle.animationModel = CircleIncreaseSameTime;
        _circle.showProgressText = YES;
        [self.view addSubview:_circle];
    }
    return _circle;
}


@end
