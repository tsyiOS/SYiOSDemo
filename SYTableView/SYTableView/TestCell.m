//
//  TestCell.m
//  SYTableView
//
//  Created by leju_esf on 2017/6/15.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "TestCell.h"
#import "SYTestModel.h"
#import <objc/runtime.h>

@interface TestCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchbtn;
@property (nonatomic, strong) SYTestModel *model;
@end

@implementation TestCell

- (void)setSy_JsonDict:(NSDictionary *)sy_JsonDict {
    [self cacheJsonDict:sy_JsonDict];
    self.model = [[SYTestModel alloc] init];
    self.model.index = [sy_JsonDict objectForKey:@"index"];
    self.nameLabel.text = self.model.index;
    self.switchbtn.on = [[sy_JsonDict objectForKey:@"selectedkey"] integerValue] == 1;
}

- (IBAction)switchAction:(UISwitch *)sender {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:self.sy_JsonDict];
    [mutableDict setObject:[NSString stringWithFormat:@"%zd",sender.on] forKey:@"selectedkey"];
    self.sy_JsonDict = mutableDict;
    if (self.sy_cellBlock) {
        self.sy_cellBlock(self.sy_JsonDict);
    }
}

@end
