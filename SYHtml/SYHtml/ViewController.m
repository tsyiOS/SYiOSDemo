//
//  ViewController.m
//  SYHtml
//
//  Created by leju_esf on 16/11/15.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "ViewController.h"

#import "SYHtmlManager.h"

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webview];
//    [[SYHtmlManager sharedSYHtmlManager] requestData];
    NSURL *url = [NSURL URLWithString:@"http://www.aa924.com/htm/novel1/87029.htm"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"====%@****%@",response,data);
    }];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        NSLog(@"%@----%@",response,data);
//    }];
    
//    [task resume];
    [NSURLConnection connectionWithRequest:request delegate:self];

//    [self.webview loadRequest:request];
}

// 服务器接收到请求时
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"服务器接收到请求时");
}
// 当收到服务器返回的数据时触发, 返回的可能是资源片段
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"资源片段%@",data);
}
// 当服务器返回所有数据时触发, 数据返回完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"完成");
}
// 请求数据失败时触发
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIWebView *)webview {
    if (_webview == nil) {
        _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 200)];
        _webview.backgroundColor = [UIColor redColor];
        _webview.delegate = self;
    }
    return _webview;
}

@end
