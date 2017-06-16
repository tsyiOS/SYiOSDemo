//
//  SYTableViewManager.m
//  SYTableView
//
//  Created by leju_esf on 2017/6/15.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYTableViewManager.h"
#import "UITableView+SYExtension.h"
#import "UITableViewCell+SYExtension.h"

@interface SYTableViewManager ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL noMoreData;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, copy) void (^requestData) (NSInteger page,void (^completion)(NSArray *datas));
@end

@implementation SYTableViewManager
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
}

- (void)setCellClass:(Class)cellClass {
    _cellClass = cellClass;
    [self.tableView sy_registerNibWithClass:cellClass];
}

- (void)setRequestNetwork:(void (^)(NSInteger page,void (^completion)(NSArray *datas)))requestData {
    if (self.tableView) {
        _requestData = requestData;
        __weak typeof(self) weakSelf = self;
        [self.tableView setSy_headerRefresh:^{
            weakSelf.page = 1;
            weakSelf.noMoreData = NO;
            weakSelf.isLoading = YES;
            weakSelf.requestData(weakSelf.page, ^(NSArray *datas) {
                [weakSelf.tableView sy_endRefresh];
                weakSelf.isLoading = NO;
                if (datas.count > 0) {
                    [weakSelf.datas removeAllObjects];
                    [weakSelf.datas addObjectsFromArray:datas];
                    [weakSelf.tableView reloadData];
                }else {
                    weakSelf.noMoreData = YES;
                }
            });
        }];
    }
}

#pragma mark - tableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.cellClass)];
    cell.sy_JsonDict = self.datas[indexPath.row];
    if (self.cellBlock) {
        __weak typeof(self) weakSelf = self;
        [cell setSy_cellBlock:^(NSDictionary *jsonDict){
            weakSelf.cellBlock(indexPath, jsonDict);
            [weakSelf.datas replaceObjectAtIndex:indexPath.row withObject:jsonDict];
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.selectedCellAction) {
        self.selectedCellAction(indexPath, cell.sy_JsonDict);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.datas.count - 2 && self.isLoading == NO && self.noMoreData == NO) {
        self.page ++ ;
        __weak typeof(self) weakSelf = self;
        self.isLoading = YES;
        self.requestData(weakSelf.page, ^(NSArray *datas) {
            [weakSelf.tableView sy_endRefresh];
            weakSelf.isLoading = NO;
            if (datas.count > 0) {
                [weakSelf.datas addObjectsFromArray:datas];
                [weakSelf.tableView reloadData];
            }else {
                weakSelf.noMoreData = YES;
            }
        });
    }
}

- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (void)dealloc {
    NSLog(@"管理者消失");
}
@end
