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

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://pic.d741.com/d5/3293/329366-28.jpg"]];
      [self.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://photo.enterdesk.com/2010-10-24/enterdesk.com-3B11711A460036C51C19F87E7064FE9D.jpg"]];
//
//    NSURLSession *session = [NSURLSession sharedSession];
    
    /**
     *  创建下载任务 （该任务启动后便会自己进行下载，并存储的）
     *
     *  @param NSURL 下载那个url 的任务
     *
     *  @block 中的数据 location下载好的文件放在磁盘的位置(会自己创建一个临时文件夹的临时目录)
     *           临时目录存放文件，会不定时的删除， 所以最后将文件转移到Cache中
     *    响应头
     */
//    NSURL *url = [NSURL URLWithString:@"http://pic.d741.com/d5/3293/329366-28.jpg"];
//    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//        NSFileManager *mgr = [NSFileManager defaultManager];
//        //        [mgr createFileAtPath:[response.suggestedFilename cacheDir] contents:nil attributes:nil];
//        // 将文件原存储的的地址 ，转换成新的存储地址， （将沙盒cache地址 用url 进行转换）。
//        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",response.suggestedFilename]];
//        [mgr moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:nil];
//        NSLog(@"%@",filePath);
//    }];
//    [task resume];
}

- (IBAction)pushToListVC {
    SYListViewController *listVC = [[SYListViewController alloc] initWithNibName:NSStringFromClass([SYListViewController class]) bundle:nil];
    listVC.type = SYHtmlTypeAllList;
    [self.navigationController pushViewController:listVC animated:YES];
}

@end
