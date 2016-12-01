//
//  SYSlideBaseTableViewController.m
//  SYSlideDemo
//
//  Created by leju_esf on 16/9/20.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYSlideBaseTableViewController.h"

@interface SYSlideBaseTableViewController ()

@end

@implementation SYSlideBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.contentInset = UIEdgeInsetsMake(90, 0, 1, 0);
//    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}

//- (void)dealloc {
//    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)  change context:(void *)context {
//    NSValue *pointValue = change[@"new"];
////    CGPoint point = pointValue.CGPointValue;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"SYSlideSelectedViewFrameChangeNotificaiton" object:self userInfo:@{@"offset":pointValue}];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
