//
//  ViewController.m
//  SYSlideDemo
//
//  Created by leju_esf on 16/9/19.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "RTHExpertViewController.h"
#import "UIColor+SYColor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *color = [UIColor blackColor];
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSLog(@"Red: %f", components[0]);
    NSLog(@"Green: %f", components[1]);
    NSLog(@"Blue: %f", components[2]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pushToExpertVC {
    RTHExpertViewController *expertVC = [[RTHExpertViewController alloc] initWithNibName:@"RTHExpertViewController" bundle:nil];
    [self.navigationController pushViewController:expertVC animated:YES];
}

@end
