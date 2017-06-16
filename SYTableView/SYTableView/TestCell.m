//
//  TestCell.m
//  SYTableView
//
//  Created by leju_esf on 2017/6/15.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "TestCell.h"

@interface TestCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation TestCell

- (void)setModel:(id)model {
    SYTestModel *newModel = model;
    self.nameLabel.text = [NSString stringWithFormat:@"%zd",newModel.index];
    
}

@end
