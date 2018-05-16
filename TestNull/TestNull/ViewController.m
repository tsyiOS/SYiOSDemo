//
//  ViewController.m
//  TestNull
//
//  Created by leju_esf on 2017/12/4.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "FilterNullValueTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *list = @[@{
                          @"name":@"第一条数据",
                          @"status":@(0)
                          },@{
                          @"name":@"第二条数据",
                          @"status":@(0)
                          },@{
                          @"name":@"第三条数据",
                          @"status":@(0)
                          },@{
                          @"name":@"第四条数据",
                          @"status":@(0)
                          },@{
                          @"name":@"第五条数据",
                          @"status":@(0)
                          }];

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingString:@"/list.plist"];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:@"-----"];
//    [dict setValue:@"value3" forKey:@"key1"];
    dict[@"key1"] = @"value3";
    NSLog(@"-----%@",dict);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
