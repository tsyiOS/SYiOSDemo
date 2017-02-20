//
//  SYWebViewController.m
//  SYHtml
//
//  Created by leju_esf on 17/1/20.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYWebViewController.h"

@interface SYWebViewController ()<NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation SYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://leju2017.wx.leju.com/activity/leju2017/index.html?project_id=144743&activity_id=1992&ljmf_ln=ljmf_h5&ljmf_source=ios&ljmf_s=yd_kdlj"]];
//    [self.webView loadRequest:request];
//
//    NSURL *url =[NSURL URLWithString:];
//    NSURLSessionTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"%@--%@",response,error);
//        if (data) {
//            [self handelData:data];
//        }
//    }];
//    [task resume];
    
    
    // 1.将网址初始化成一个OC字符串对象
    NSString *urlStr = @"http://res.leju.com/scripts/libs/zepto/v1/zepto.js";
    // 如果网址中存在中文,进行URLEncode
    NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 2.构建网络URL对象, NSURL
    NSURL *url = [NSURL URLWithString:newUrlStr];
    // 3.创建网络请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    // 创建同步链接
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}

- (void)handelData:(NSData *)data {
    NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",html);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 服务器接收到请求时
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response===%@",response);
}
// 当收到服务器返回的数据时触发, 返回的可能是资源片段
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
     NSLog(@"data===%@",data);
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

- (NSURLSession *)session{
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

@end
