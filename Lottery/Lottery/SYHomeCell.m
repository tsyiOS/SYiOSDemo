//
//  SYHomeCell.m
//  Lottery
//
//  Created by leju_esf on 17/2/20.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYHomeCell.h"

@implementation SYHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.nameLabel.layer.cornerRadius = 50;
//    self.nameLabel.clipsToBounds = YES;
//    self.nameLabel.layer.borderWidth = 2;
//    self.nameLabel.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)setModel:(SYGameModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
}
@end
