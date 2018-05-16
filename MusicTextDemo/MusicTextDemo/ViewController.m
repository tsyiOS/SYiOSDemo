//
//  ViewController.m
//  MusicTextDemo
//
//  Created by leju_esf on 2018/5/11.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "MusicTextCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSMutableArray *pingyins;
@property (nonatomic, strong) NSMutableArray *chineses;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MusicTextCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MusicTextCell class])];
    self.tableView.rowHeight = ItemHeight;
    self.tableView.tableFooterView = self.footerView;
    
    NSString *stringData = @"zuo xiao xue sheng zhen hao ，\r做 小 学 生 真 好 ，\rzuo xiao xue sheng zhen hao ，\r做 小 学 生 真 好 ，\rzuo xiao xue sheng zhen hao ，\r做 小 学 生 真 好 ，\rzuo xiao xue sheng zhen hao ，\r做 小 学 生 真 好 ，\rzuo xiao xue sheng zhen hao ，\r做 小 学 生 真 好 ，\rzuo xiao xue sheng zhen hao ，\r做 小 学 生 真 好 ，\rzuo xiao xue sheng zhen hao ，\r做 小 学 生 真 好 ，\rzuo xiao xue sheng zhen hao ，\r做 小 学 生 真 好 ，\rzuo xiao xue sheng zhen hao ，\r做 小 学 生 真 好 ，\rzuo xiao xue sheng zhen hao ，\r做 小 学 生 真 好 ，";
    
    NSArray *lines = [stringData componentsSeparatedByString:@"\r"];
    for (int i = 0; i < lines.count; i++) {
        NSString *str = lines[i];
        if (i%2==0) {
            [self.pingyins addObject:[str componentsSeparatedByString:@" "]];
        }else {
            [self.chineses addObject:[str componentsSeparatedByString:@" "]];
        }
    }
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chineses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MusicTextCell class])];
    cell.pingyins = self.pingyins[indexPath.row];
    cell.chineses = self.chineses[indexPath.row];
    if (indexPath.row == 0) {
        cell.scale = 1;
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > ItemHeight * (-0.5)) {
        CGFloat num = scrollView.contentOffset.y / ItemHeight;
        NSInteger index = floor(num);
        CGFloat scale = 1-(num - index);
        MusicTextCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.scale = scale;
        if (index < self.chineses.count-1) {
            MusicTextCell *lastCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index+1 inSection:0]];
            lastCell.scale = 1 - scale;
        }
    }
}

- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UIView alloc] init];
        _footerView.frame = CGRectMake(0, 0, 0, self.tableView.frame.size.height - ItemHeight);
        _footerView.backgroundColor = [UIColor clearColor];
    }
    return _footerView;
}

- (NSMutableArray *)pingyins {
    if (_pingyins == nil) {
        _pingyins = [[NSMutableArray alloc] init];
    }
    return _pingyins;
}

- (NSMutableArray *)chineses {
    if (_chineses == nil) {
        _chineses = [[NSMutableArray alloc] init];
    }
    return _chineses;
}
@end
