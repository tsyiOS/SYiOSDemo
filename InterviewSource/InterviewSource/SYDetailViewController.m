//
//  SYDetailViewController.m
//  InterviewSource
//
//  Created by leju_esf on 16/11/29.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYDetailViewController.h"

@interface SYDetailViewController ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIWebView *textWebView;
@end

@implementation SYDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *name = [self.textModel.name stringByAppendingString:[NSString stringWithFormat:@".%@",self.textModel.type]];
    NSString *textPath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    
    if ([self.textModel.type isEqualToString:@"txt"]) {
        [self.view addSubview:self.textView];
        self.textView.text = [NSString stringWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:nil];
    }else {
        [self.view addSubview:self.textWebView];
        NSURL *url = [[NSURL alloc]initFileURLWithPath:textPath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.textWebView loadRequest:request];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.editable = NO;
    }
    return _textView;
}

- (UIWebView *)textWebView {
    if (_textWebView == nil) {
        _textWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _textWebView.scalesPageToFit = YES;
    }
    return _textWebView;
}

@end
