//
//  TableViewController.m
//  TestNull
//
//  Created by leju_esf on 2017/12/5.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
@interface TableViewController ()
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([TableViewCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([TableViewCell class])];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem = item;
    
    //1>进入列表页的时候,先加载本地缓存的数据
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingString:@"/list.plist"];
    NSArray *list = [NSArray arrayWithContentsOfFile:path];
    self.list = [NSMutableArray arrayWithArray:list];
    
    [self.tableView reloadData];
}

- (void)saveAction {
    //保存,点击保存的时候再把本地数组缓存本地,更新本地缓存
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingString:@"/list.plist"];
    [self.list writeToFile:path atomically:YES];
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class])];
    NSDictionary *dict = self.list[indexPath.row];
    cell.dict = dict;
    __weak typeof(self) weakSelf = self;
    [cell setClickswitch:^(BOOL on) {
        //点击的时候就把数组里面这个字段的值变一下
        [dict setValue:@(on) forKey:@"status"];
        //然后把数组里面对应的数据模型字典替换掉,用最新的,但是此时还没有保存,所以仅在内存里面
        [weakSelf.list replaceObjectAtIndex:indexPath.row withObject:dict];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
