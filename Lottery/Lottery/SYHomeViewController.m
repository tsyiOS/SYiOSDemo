//
//  SYHomeViewController.m
//  Lottery
//
//  Created by leju_esf on 17/2/27.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYHomeViewController.h"
#import "SYWebViewController.h"

@interface SYHomeViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation SYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLoadUrl]) {
        NSString *wapUrl = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserInformation] objectForKey:@"wapurl"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:wapUrl]];
        [self.webView loadRequest:request];
    }else {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://j.m.leju.com"]];
        [self.webView loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
