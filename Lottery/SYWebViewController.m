//
//  SYWebViewController.m
//  Lottery
//
//  Created by leju_esf on 17/2/20.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYWebViewController.h"

@interface SYWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

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
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [self.webView loadRequest:request];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.title.length == 0) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
