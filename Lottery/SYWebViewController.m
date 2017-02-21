//
//  SYWebViewController.m
//  Lottery
//
//  Created by leju_esf on 17/2/20.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYWebViewController.h"
#import "UIView+SYExtension.h"
#import "UIColor+SYExtension.h"
#import "SYGameDetailCell.h"

@interface SYWebViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SYWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor sy_colorWithRGB:0xB90E2F];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_white"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.title = self.model.name;
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.webView.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SYGameDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SYGameDetailCell class])];
    
//    BOOL location = NO;
//    if (location) {
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
//        [self.webView loadRequest:request];
//    }else {
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"炸金花" ofType:@"html"];
//        NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//        [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
//    }
}



- (void)backAction {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.title.length == 0) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"加载的url---%@",url);
    return  YES;
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGameDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYGameDetailCell class])];
    if (indexPath.section == 0) {
        cell.nameLabel.text = self.model.name;
        cell.contentLabel.text = self.model.intro;
    }else if (indexPath.section == 1) {
        cell.nameLabel.text = @"规则";
        cell.contentLabel.text = self.model.rule;
    }else {
        cell.nameLabel.text = @"技巧";
        cell.contentLabel.text = self.model.trick;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIImageView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW*64/96)];
        _headerView.image = [UIImage imageNamed:self.model.name];
    }
    return _headerView;
}
@end
