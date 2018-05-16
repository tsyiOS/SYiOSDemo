//
//  ViewController.m
//  CameraDemo
//
//  Created by leju_esf on 2017/7/17.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "HWBlueToothCell.h"
#import "HWHardwareCell.h"
#import "HWAlbumCell.h"
#import "HWPhoneRecordCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollsToTop = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"HWBlueToothCell" bundle:nil] forCellReuseIdentifier:@"HWBlueToothCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HWHardwareCell" bundle:nil] forCellReuseIdentifier:@"HWHardwareCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HWAlbumCell" bundle:nil] forCellReuseIdentifier:@"HWAlbumCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HWPhoneRecordCell" bundle:nil] forCellReuseIdentifier:@"HWPhoneRecordCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    self.tableView.contentOffset = CGPointMake(0, 150* 400000);
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1200000;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}
//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section%4) {
        case 0:{
            HWPhoneRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HWPhoneRecordCell"];
            return cell;
        }
            break;
        case 1:{
            HWHardwareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HWHardwareCell"];
            return cell;
        }
            
            break;
        case 2:{
            HWBlueToothCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HWBlueToothCell"];
            return cell;
        }
            
            break;
        case 3:{
            HWAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HWAlbumCell"];
            return cell;
        }
            break;
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
