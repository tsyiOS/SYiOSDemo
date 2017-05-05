//
//  SYTabBarViewController.m
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/5.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYTabBarViewController.h"
#import "SYNavgationViewController.h"
#import "SYBaseViewController.h"

@interface SYTabBarViewController ()

@end

@implementation SYTabBarViewController

- (instancetype)init {
    if (self = [super init]) {
        for (UIView *sub in self.view.subviews) {
            NSLog(@"====%@",NSStringFromClass([sub class]));
            if ([sub isKindOfClass:[UITabBar class]]) {
                __strong sub = [[UITabBar alloc] init];
            }
        }
        NSArray *vcClasses = @[@"SYHomeViewController",@"SYBuyViewController",@"SYOpenRewardViewController",@"SYTrendViewController",@"SYMineViewController"];
        
        for (NSString *className in vcClasses) {
            SYBaseViewController *baseVc = [(SYBaseViewController *)[NSClassFromString(className) alloc] initWithNibName:className bundle:nil];
            SYNavgationViewController *nvaVc = [[SYNavgationViewController alloc] initWithRootViewController:baseVc];
            baseVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"nav_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"nav_01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            baseVc.tabBarItem.badgeColor = [UIColor redColor];
            [self addChildViewController:nvaVc];
            
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
