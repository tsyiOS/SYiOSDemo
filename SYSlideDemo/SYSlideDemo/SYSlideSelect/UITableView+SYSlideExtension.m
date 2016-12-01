//
//  UITableView+SYSlideExtension.m
//  SYSlideDemo
//
//  Created by 唐绍禹 on 16/9/20.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "UITableView+SYSlideExtension.h"
#import <objc/runtime.h>
#import "SYHeaderRefreshView.h"
#import "UIView+SYFrame.h"
#import "SYObserver.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface UITableView ()
@property (nonatomic, strong) SYHeaderRefreshView *refreshView;
@end

@implementation UITableView (SYSlideExtension)

@dynamic sy_headerRefresh;

- (void)sy_observeTableViewContentOffset {
    self.contentInset = UIEdgeInsetsMake(90, 0, 1, 0);
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentOffset"];
    [self.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)  change context:(void *)context {
    
    if ([keyPath isEqualToString:@"state"]) {
        NSInteger state = [change[@"new"] integerValue];
        if (state == 3) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SYSlideSelectedViewFrameChangeEndNotificaiton" object:self];
            [self sy_judgeRefresh];
        }
        
    }else if([keyPath isEqualToString:@"contentOffset"]){
        
        NSValue *pointValue = change[@"new"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SYSlideSelectedViewFrameChangeNotificaiton" object:self userInfo:@{@"offset":pointValue}];
        
        [self sy_changeRefreshTitle];
    }
}

- (void)sy_judgeRefresh {
    if (self.contentOffset.y <= -140) {
        NSLog(@"要刷新");
        [self sy_beginRefresh];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sy_endRefresh];
        });
    }
}

- (void)sy_changeRefreshTitle {
    if (self.contentOffset.y > -140) {
        self.refreshView.status = SYRefreshPullDown;
    }else {
        self.refreshView.status = SYRefreshReady;
    }
}



- (void)sy_beginRefresh {
    self.contentInset = UIEdgeInsetsMake(140, 0, 1, 0);
    self.refreshView.status = SYRefreshing;
    if (self.sy_headerRefresh) {
        self.sy_headerRefresh();
    }
}

- (void)sy_endRefresh {
    self.contentInset = UIEdgeInsetsMake(90, 0, 1, 0);
    NSLog(@"刷新完毕");
    self.refreshView.status = SYRefreshPullDown;

}

static const char SY_RefreshKey = '\1';
static const char SY_RefreshViewKey = '\2';
- (void)setSy_headerRefresh:(void (^)())sy_headerRefresh {
    if (self.refreshView == nil) {
        SYHeaderRefreshView *refreshView = [[SYHeaderRefreshView alloc] initWithFrame:CGRectMake(0, -50, self.sy_width, 50)];
        [self addSubview:refreshView];
        objc_setAssociatedObject(self, &SY_RefreshViewKey, refreshView, OBJC_ASSOCIATION_ASSIGN);
    }
    objc_setAssociatedObject(self, &SY_RefreshKey, sy_headerRefresh, OBJC_ASSOCIATION_ASSIGN);
}

- (void (^)())sy_headerRefresh {
    return objc_getAssociatedObject(self, &SY_RefreshKey);
}

- (SYHeaderRefreshView *)refreshView {
    return objc_getAssociatedObject(self, &SY_RefreshViewKey);
}

@end
