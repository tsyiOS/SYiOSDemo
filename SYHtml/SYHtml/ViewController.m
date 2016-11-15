//
//  ViewController.m
//  SYHtml
//
//  Created by leju_esf on 16/11/15.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "ViewController.h"

#import "SYHtmlManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SYHtmlManager sharedSYHtmlManager] requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
