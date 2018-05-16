//
//  ERFloatView.m
//  ERPackage
//
//  Created by leju_esf on 16/5/23.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "ERFloatView.h"

static CGFloat const radius = 100;
static CGFloat const addBtnR = 50;//大按钮的直径
static CGFloat const titleBtnR = 50;//小按钮的直径

CGFloat ERDistanceBetweenPoints(CGPoint p1, CGPoint p2){
    return sqrtf(powf(p1.x - p2.x, 2) + powf(p1.y - p2.y, 2));
}

@interface ERFloatView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation ERFloatView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (CGRectContainsPoint(self.bounds, point)) {
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if (CGRectContainsPoint(subView.frame, point)) {
            return YES;
        }
    }
    return NO;
}

- (instancetype)initWithTitles:(NSArray *)titles andFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        for (int i = 0; i<titles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.tag = i+1000;
//            [btn setTitle:titles[i] forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            btn.backgroundColor = [UIColor colorWithRGB:0x424141];
            [btn setBackgroundImage:[self backgroundImageWithTitle:titles[i]] forState:UIControlStateNormal];
            btn.bounds = CGRectZero;
            btn.layer.cornerRadius = titleBtnR*0.5;
            btn.clipsToBounds = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.center = self.addButton.center;
            [btn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerMove:)];
            [btn addGestureRecognizer:pan];
            [self addSubview:btn];
        }
        [self addSubview:self.addButton];
    }
    return self;
}

- (void)panGestureRecognizerMove:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self];
    
    CGFloat distance = ERDistanceBetweenPoints(point, self.addButton.center);
    CGFloat offsetX = (point.x - self.addButton.center.x)*radius/distance;
    CGFloat offsetY = (point.y - self.addButton.center.y)*radius/distance;
    
    CGFloat marginAngle = 360.0/_titles.count;
    
    CGFloat newStartAnagle= 0;
    if (offsetY >= 0) {
        newStartAnagle = (-1)*acos(offsetX/radius)*180.0/M_PI;
    }else {
        newStartAnagle = acos(offsetX/radius)*180.0/M_PI;
    }
    
    for (UIView *sub in self.subviews) {
        CGFloat startAngle = (newStartAnagle + marginAngle*(sub.tag - pan.view.tag))/180.0 * M_PI ;
        if (sub.tag >= 1000 ) {
            CGFloat marginX = radius* cos(startAngle);
            CGFloat marginY = radius* sin(startAngle) * (-1);
            sub.center = CGPointMake(self.addButton.center.x + marginX, self.addButton.center.y + marginY);
        }
    }
}

- (UIImage *)backgroundImageWithTitle:(NSString *)title {
    NSDictionary *imageNames = @{
                                 @"打卡":@"floatView_card",
                                 @"修改":@"floatView_edit",
                                 @"周边":@"floatView_map",
                                 @"电话":@"floatView_phone",
                                 @"日程":@"floatView_schedule",
                                 @"拜访":@"floatView_visit"
                                 };
    if ([imageNames.allKeys containsObject:title]) {
        NSString *imageName = imageNames[title];
        UIImage *image = [UIImage imageNamed:imageName];
        return image;
    }else {
        return nil;
    }
}

- (void)addButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [UIView animateWithDuration:0.25 animations:^{
           sender.transform = CGAffineTransformMakeRotation(M_PI_4);
        }];
        
        [self open];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            sender.transform = CGAffineTransformIdentity;
        }];
        
        [self dismiss];
    }
}

- (void)titleBtnClick:(UIButton *)sender {
    if (self.action) {
        self.action(sender.tag - 1000);
    }
    [self addButtonClick:self.addButton];
}

- (void)backgroundViewCilck {
    [self addButtonClick:self.addButton];
}

- (void)open {
    CGFloat marginAngle = 360.0/_titles.count;
    for (UIView *sub in self.subviews) {
        CGFloat startAngle = (marginAngle*(sub.tag - 1000))/180.0 * M_PI ;
        if (sub.tag >= 1000) {
            CGFloat marginX = (radius*self.titles.count/self.titles.count) * cos(startAngle);
            CGFloat marginY = (radius*self.titles.count/self.titles.count) * sin(startAngle) * (-1);
            [UIView animateWithDuration:0.25 animations:^{
                sub.center = CGPointMake(self.addButton.center.x + marginX, self.addButton.center.y + marginY);
                sub.bounds = CGRectMake(0, 0, titleBtnR, titleBtnR);
            }];
        }
    }
    [self.superview addSubview:self.backgroundView];
    [self.superview bringSubviewToFront:self];
}

- (void)dismissBtn {
    [UIView animateWithDuration:0.25 animations:^{
        self.addButton.transform = CGAffineTransformIdentity;
    }];
    
    [self dismiss];
}

- (void)dismiss {
    for (UIView *sub in self.subviews) {
        if (sub.tag >= 1000) {
            [UIView animateWithDuration:0.25 animations:^{
                sub.center = self.addButton.center;
            }];
        }
    }
    [self.backgroundView removeFromSuperview];
}

- (UIButton *)addButton {
    if (_addButton == nil) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(self.bounds.size.width - addBtnR, (self.bounds.size.height - addBtnR)*0.5, addBtnR, addBtnR);
        _addButton.backgroundColor = [UIColor redColor];
        [_addButton setTitle:@"+" forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont boldSystemFontOfSize:45];
        _addButton.layer.cornerRadius = addBtnR*0.5;
        _addButton.clipsToBounds = YES;
        _addButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
        [_addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewCilck)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}


- (NSArray *)titles {
    if (_titles == nil) {
        _titles = [[NSArray alloc] init];
    }
    return _titles;
}



@end
