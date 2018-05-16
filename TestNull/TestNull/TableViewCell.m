//
//  TableViewCell.m
//  TestNull
//
//  Created by leju_esf on 2017/12/5.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchbtn;

@end

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.nameLabel.text = dict[@"name"];
    self.switchbtn.on = [dict[@"status"] boolValue];
    
}

- (IBAction)switchclick:(UISwitch *)sender {
    if (self.clickswitch) {
        self.clickswitch(sender.on);
    }
}

@end
