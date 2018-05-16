//
//  ViewController.m
//  TaskDemo
//
//  Created by leju_esf on 2018/4/19.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "TaskViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)pushToTaskViewController {
    TaskViewController *vc = [[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
