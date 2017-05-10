//
//  SYBaseViewController.m
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/5.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYBaseViewController.h"

@interface SYBaseViewController ()

@end

@implementation SYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.navigationController.viewControllers.count > 1) {
        UIImage *navImage = [UIImage imageNamed:@"nav-btn-back"];
        UIColor *color = [UIColor whiteColor];
        
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithImage:navImage style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked)];
        barItem.tintColor = color;
        self.navigationItem.leftBarButtonItem = barItem;
    }
}

- (void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (instancetype)instancetFromNib {
    return [[self alloc] initWithNibName:NSStringFromClass(self) bundle:nil];
}
@end
