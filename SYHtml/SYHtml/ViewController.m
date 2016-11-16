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
}

- (IBAction)pushToListVC {
    SYListViewController *listVC = [[SYListViewController alloc] initWithNibName:NSStringFromClass([SYListViewController class]) bundle:nil];
    listVC.type = SYHtmlTypeAllList;
    [self.navigationController pushViewController:listVC animated:YES];
}

@end
