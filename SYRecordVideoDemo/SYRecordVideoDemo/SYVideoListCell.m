//
//  SYVideoListCell.m
//  SYRecordVideoDemo
//
//  Created by leju_esf on 17/3/16.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYVideoListCell.h"

@interface SYVideoListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end

@implementation SYVideoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SYVideoModel *)model {
    _model = model;
    [model sy_setImage:^(UIImage *image) {
        self.videoImageView.image = image;
    }];
    self.timeLabel.text = [self dutationStr];
    self.nameLabel.text = [@"拍摄时间" stringByAppendingString:[model takeDate]];
    self.sizeLabel.text = model.sizeStr;
}

- (NSString *)dutationStr {
    if(self.model.totalTime > 3600) {
        NSInteger hour = self.model.totalTime /3600;
        NSInteger mon = ((NSInteger)self.model.totalTime % 3600) / 60;
        NSInteger second = (NSInteger)self.model.totalTime%60;
        return [NSString stringWithFormat:@"%02zd:%02zd:%02zd",hour,mon,second];
    } else {
        NSInteger mon = self.model.totalTime / 60;
        NSInteger second = (NSInteger)self.model.totalTime%60;
        return [NSString stringWithFormat:@"%02zd:%02zd",mon,second];
    }
}

@end
