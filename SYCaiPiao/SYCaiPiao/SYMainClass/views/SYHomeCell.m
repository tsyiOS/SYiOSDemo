//
//  SYHomeCell.m
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/10.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYHomeCell.h"

@interface SYHomeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation SYHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SYHomeDataModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.attribute.logo]];
    self.nameLabel.text = model.attribute.cardName;
    self.desLabel.text = model.attribute.cardDesc;
}

@end
