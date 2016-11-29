//
//  ViewController.m
//  InterviewSource
//
//  Created by leju_esf on 16/11/29.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "SYDetailViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *texts;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"知识总结";
    [self.view addSubview:self.tableView];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.texts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *groupArray = self.texts[section];
    return groupArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"text";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    NSArray *sectionArray = self.texts[indexPath.section];
    SYTextModel *text = sectionArray[indexPath.row];
    cell.textLabel.text = text.name;
    
    return cell;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *sectionArray = self.texts[indexPath.section];
    SYTextModel *text = sectionArray[indexPath.row];
    SYDetailViewController *textVc = [[SYDetailViewController alloc] init];
    textVc.textModel = text;
    textVc.title = text.name;
    [self.navigationController pushViewController:textVc animated:YES];
}

- (NSString *)tableView:(nonnull UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"非技术面试";
    } else if (section == 1) {
        return @"技术面试";
    } else if (section == 2){
        return @"项目知识";
    } else if (section == 3){
        return @"笔试题";
    } else {
        return @"笔记";
    }
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSArray *)texts {
    if (_texts == nil) {
        _texts = [SYTextModel texts];
    }
    return _texts;
}
@end
