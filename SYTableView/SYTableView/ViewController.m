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
#import "TestCell.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SYTableViewManager *tableViewManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewManager.tableView = self.tableView;
    [self.tableViewManager setRequestNetwork:^(NSInteger page, void (^completion)(NSArray *datas)) {
        if (page == 1) {
        completion(@[@{@"index":@"1"},@{@"index":@"2"},@{@"index":@"3"},@{@"index":@"4"},@{@"index":@"5"},@{@"index":@"6"},@{@"index":@"7"},@{@"index":@"8"},@{@"index":@"9"},@{@"index":@"10"}]);
        }else {
            if (page > 5) {
                completion(nil);
            }else {
                NSMutableArray *tempArray = [NSMutableArray array];
                for (int i = 0; i < 10; i++) {
                    [tempArray addObject:@{@"index":[NSString stringWithFormat:@"%zd",page*10 + i]}];
                }
                completion(tempArray);
            }
        }
    }];
    self.tableViewManager.cellClass = [TestCell class];
    
    [self.tableViewManager setSelectedCellAction:^(NSIndexPath *indexPath,NSDictionary *dict){
        NSLog(@"cell点击---%@---%@",indexPath,dict);
    }];
    
    [self.tableViewManager setCellBlock:^(NSIndexPath *indexPath,NSDictionary *dict){
        NSLog(@"开关---%@---%@",indexPath,dict);
    }];
    
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
