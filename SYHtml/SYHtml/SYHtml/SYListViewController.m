//
//  SYListViewController.m
//  SYHtml
//
//  Created by leju_esf on 16/11/16.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYListViewController.h"
#import "SYArticleModel.h"
#import "SYArticleViewController.h"
#import "SYPictureViewController.h"
#import "SYPhotoBrowser.h"
#import "SVProgressHUD.h"

@interface SYListViewController ()
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSDictionary *listDict;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation SYListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.page = 1;
    if (self.type == SYHtmlTypeAllList) {
        self.title = @"目录";
    }else {
        self.isLoading = YES;
         [[SYHtmlManager sharedSYHtmlManager] requestDataWithUrl:self.urlSring andType:self.type completion:^(id response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isLoading = NO;
                if (self.page == 1) {
                    self.list = response;
                }else {
                    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.list];
                    [tempArray addObjectsFromArray:response];
                }
                [self.tableView reloadData];
            });
         }];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.type == SYHtmlTypeAllList ?self.listDict.allValues.count:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type != SYHtmlTypeAllList) {
        return self.list.count;
    }else {
        NSArray *dicts = self.listDict.allValues[section];
        return dicts.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    if (self.type == SYHtmlTypeAllList) {
        NSArray *dicts = self.listDict.allValues[indexPath.section];
        NSDictionary *dict = dicts[indexPath.row];
        cell.textLabel.text = dict[@"title"];
    }else {
        SYArticleModel *model = self.list[indexPath.row];
        cell.textLabel.text =model.title;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == SYHtmlTypeAllList) {
        if (indexPath.section == 0) {
            SYListViewController *listVC = [[SYListViewController alloc] initWithNibName:NSStringFromClass([SYListViewController class]) bundle:nil];
            listVC.type = SYHtmlTypeArticleList;
            NSArray *dicts = self.listDict.allValues[indexPath.section];
            NSDictionary *dict = dicts[indexPath.row];
            listVC.urlSring = dict[@"url"];
            listVC.title = dict[@"title"];
            [self.navigationController pushViewController:listVC animated:YES];
        }else if(indexPath.section == 1){
            SYListViewController *listVC = [[SYListViewController alloc] initWithNibName:NSStringFromClass([SYListViewController class]) bundle:nil];
            listVC.type = SYHtmlTypePictureList;
            NSArray *dicts = self.listDict.allValues[indexPath.section];
            NSDictionary *dict = dicts[indexPath.row];
            listVC.urlSring = dict[@"url"];
            listVC.title = dict[@"title"];
            [self.navigationController pushViewController:listVC animated:YES];
        }
    }else if (self.type == SYHtmlTypeArticleList) {
        SYArticleViewController *articleVC = [[SYArticleViewController alloc] initWithNibName:NSStringFromClass([SYArticleViewController class]) bundle:nil];
        SYArticleModel *model = self.list[indexPath.row];
        articleVC.urlString = model.url;
        [self.navigationController pushViewController:articleVC animated:YES];
    }else if (self.type == SYHtmlTypePictureList) {
        SYArticleModel *model = self.list[indexPath.row];
        [[SYHtmlManager sharedSYHtmlManager] requestDataWithUrl:model.url andType:SYHtmlTypePicture completion:^(id response) {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentBrowser:response];
                });
            }
        }];
    }
}

- (void)presentBrowser:(NSArray *)urls {
    SYPhotoBrowser *pictureVC = [[SYPhotoBrowser alloc] init];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *url in urls) {
        SYPhoto *photo = [[SYPhoto alloc] init];
        photo.url = url;
        [tempArray addObject:photo];
    }
    pictureVC.images = tempArray;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self presentViewController:pictureVC animated:YES completion:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.type == SYHtmlTypeAllList) {
        return section == 0?@"小说":@"图片";
    }else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.list.count - 1 && self.page < 99 && self.isLoading == NO) {
        self.isLoading = YES;
        self.page ++;
        [[SYHtmlManager sharedSYHtmlManager] requestDataWithUrl:[NSString stringWithFormat:@"%@/%zd.htm",self.urlSring,self.page] andType:self.type completion:^(id response) {
            self.isLoading = NO;
            if (self.page == 1) {
                self.list = response;
            }else {
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.list];
                [tempArray addObjectsFromArray:response];
                self.list = tempArray;
            }
            [self.tableView reloadData];
        }];
    }
}

- (NSArray *)list {
    if (_list == nil) {
        _list = [NSArray array];
    }
    return _list;
}

- (NSDictionary *)listDict {
    if (_listDict == nil) {
        _listDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SourceList.plist" ofType:nil]];
    }
    return _listDict;
}
@end
