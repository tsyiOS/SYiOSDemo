//
//  SYFindCell.m
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/10.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYFindCell.h"

@interface SYFindCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation SYFindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SYFindModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]];
    self.nameLabel.text = model.title;
    self.desLabel.text = model.descript;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
