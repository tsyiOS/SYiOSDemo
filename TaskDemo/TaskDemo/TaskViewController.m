//
//  TaskViewController.m
//  TaskDemo
//
//  Created by leju_esf on 2018/4/19.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskCell.h"
#import "TaksHeaderView.h"
#import "SYDatePickerTool.h"
#import "TaskModel.h"
@interface TaskViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SYDatePickerTool *picker;
@property (nonatomic, strong) NSArray *array;
@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TaskModel *model = self.array.firstObject;
    model.open = YES;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TaskCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TaskCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TaksHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TaksHeaderView class])];
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;

}

- (IBAction)datePickerAction {
    [self.picker show];
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TaskModel *model = self.array[section];
    return model.open ? 1:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TaskCell class])];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TaksHeaderView *view  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([TaksHeaderView class])];
    __weak typeof(self) weakSelf = self;
    [view setOpenAction:^{
        [weakSelf reloadAtSection:section];
    }];
    return view;
}

- (void)reloadAtSection:(NSInteger)section {
    TaskModel *model = self.array[section];
    model.open=!model.open;
    [self.tableView reloadData];
}

- (SYDatePickerTool *)picker {
    if (_picker == nil) {
        _picker = [[SYDatePickerTool alloc] initWithDatePickerMode:UIDatePickerModeDate];
        __weak typeof(self) weakSelf = self;
        [_picker setDoneAction:^(NSDate *date) {
            NSDateComponents *components = [[NSCalendar currentCalendar]components:NSCalendarUnitMonth fromDate:date];
            
            NSDateComponents *components2 = [[NSCalendar currentCalendar]components:NSCalendarUnitDay fromDate:date];
            [weakSelf.dateBtn setTitle:[NSString stringWithFormat:@"%zd月%zd日",components.month,components2.day] forState:UIControlStateNormal];
        }];
    }
    return _picker;
}

- (NSArray *)array {
    if (_array == nil) {
        _array = @[[TaskModel new],[TaskModel new],[TaskModel new],[TaskModel new],[TaskModel new]];
    }
    return _array;
}
@end
