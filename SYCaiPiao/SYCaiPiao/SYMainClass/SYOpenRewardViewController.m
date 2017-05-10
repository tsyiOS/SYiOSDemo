//
//  SYOpenRewardViewController.m
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/5.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYOpenRewardViewController.h"
#import "SYFindCell.h"

@interface SYOpenRewardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *list;
@end

@implementation SYOpenRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SYFindCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SYFindCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushToWebViewWithUrl:(NSString *)url {
    SYWebViewController *web = [SYWebViewController instancetFromNib];
    web.url = url;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYFindCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYFindCell class])];
    cell.model = self.list[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SYFindModel *model = self.list[indexPath.row];
    [self pushToWebViewWithUrl:model.jumpUrl];
}

- (NSArray *)list {
    if (_list == nil) {
        _list = [SYFindModel models];
    }
    return _list;
}

@end
