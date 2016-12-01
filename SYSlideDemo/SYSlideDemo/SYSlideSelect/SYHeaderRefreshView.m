//
//  SYHeaderRefreshView.m
//  SYSlideDemo
//
//  Created by 唐绍禹 on 16/9/21.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYHeaderRefreshView.h"
#import "UIView+SYFrame.h"

static NSString *const SYRefreshTimeKey = @"SYRefreshTimeKey";

@interface SYHeaderRefreshView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation SYHeaderRefreshView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeLabel];
}

- (void)setStatus:(SYRefreshStatus)status {
    _status = status;
    NSString *title;
    switch (status) {
        case SYRefreshPullDown:
            title = @"下拉可以刷新";
            break;
        case SYRefreshReady:
            title = @"松开立即刷新";
            break;
        case SYRefreshing:
            title = @"正在获取数据...";
            [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:SYRefreshTimeKey];
            break;
    }
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.frame = CGRectMake(0, 0, self.sy_width, self.sy_height * 0.5);
        _titleLabel.text = @"下拉可以刷新";
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont boldSystemFontOfSize:13];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.frame = CGRectMake(0, 25, self.sy_width, self.sy_height * 0.5);
        _timeLabel.text = [NSString stringWithFormat:@"最后更新:%@",[self lastRefreshTime]];
    }
    return _timeLabel;
}

- (NSString *)lastRefreshTime {
    NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:SYRefreshTimeKey];
    lastDate = lastDate?:[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    return [NSString stringWithFormat:@"%@%@",[self dateString:lastDate],[formatter stringFromDate:lastDate]];
}

- (NSString *)dateString:(NSDate *)day {
    
    NSUInteger flags = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
    NSDateComponents *currentComponent = [[NSCalendar currentCalendar]components:flags fromDate:[NSDate date]];
    NSDateComponents *lastComponent = [[NSCalendar currentCalendar]components:flags fromDate:day];
    if (currentComponent.year == lastComponent.year && currentComponent.month == lastComponent.month && currentComponent.day == lastComponent.day) {
        return @"今天";
    }else {
        NSDateComponents *components = [[NSCalendar currentCalendar]components:NSCalendarUnitDay fromDate:day toDate:[NSDate date] options:0];
        if (components.day == 1) {
            return @"昨天";
        }else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"MM/dd";
            return [formatter stringFromDate:day];
        }
    }
    
}

@end
