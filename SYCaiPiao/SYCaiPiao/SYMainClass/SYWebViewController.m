//
//  SYWebViewController.m
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/10.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYWebViewController.h"

@interface SYWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (![self.url hasPrefix:@"http"]) {
        self.url = [@"https://caipiao.163.com" stringByAppendingPathComponent:self.url];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.title.length == 0) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

@end
