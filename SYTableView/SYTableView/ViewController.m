//
//  ViewController.m
//  SYTableView
//
//  Created by leju_esf on 2017/6/15.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "SYTableViewManager.h"
#import "UITableView+SYExtension.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SYTableViewManager *tableViewManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewManager.tableView = self.tableView;
    __weak typeof(self) weakSelf = self;
    
    [self.tableViewManager setRequestNetwork:^(NSInteger page, void (^completion)(NSArray *datas)) {
        if (page == 1) {
            completion(@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10]);
            [weakSelf.tableView sy_endRefresh];
        }else {
            if (page > 5) {
                completion(nil);
            }else {
                NSMutableArray *tempArray = [NSMutableArray array];
                for (int i = 0; i < 10; i++) {
                    [tempArray addObject:@(page*10 + i)];
                }
                completion(tempArray);
            }
        }
    }];
}

- (void)requestData {
    NSLog(@"kkkk");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView sy_endRefresh];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SYTableViewManager *)tableViewManager {
    if (_tableViewManager == nil) {
        _tableViewManager = [[SYTableViewManager alloc] init];
    }
    return _tableViewManager;
}

- (void)dealloc {
    NSLog(@"列表消失");
}

@end
