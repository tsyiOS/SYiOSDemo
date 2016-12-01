//
//  RTHViewController.m
//  SYSlideDemo
//
//  Created by sy_esf on 16/9/19.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "RTHExpertViewController.h"
#import "SYSlideSelectedView.h"
#import "RTHIntroductViewController.h"
#import "RTHCoursesViewController.h"
#import "RTHQuestionAnswerViewController.h"
#import "RTHEvaluateViewController.h"
#import "UIView+SYFrame.h"

#define MiddleViewTopMargin  (ScreenW/375) * 290

@interface RTHExpertViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, strong) SYSlideSelectedView *slideView;
@property (nonatomic, assign) BOOL isAnimation;
@end

@implementation RTHExpertViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (IBAction)backAciton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.middleView addSubview:self.slideView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.topImageViewHeight.constant = MiddleViewTopMargin;
    self.middleViewTopMargin.constant = MiddleViewTopMargin;
    
    NSArray *controllers = @[[RTHIntroductViewController class],[RTHCoursesViewController class],[RTHQuestionAnswerViewController class],[RTHEvaluateViewController class]];
    
    for (int i = 0; i < controllers.count; i++) {
        Class vcClass = controllers[i];
        UITableViewController *vc = [[vcClass alloc] init];
        [self addChildViewController:vc];
        
        vc.view.tag = i+1000;
        CGFloat x = i*ScreenW;
        vc.view.frame = CGRectMake(x, 0, ScreenW,ScreenH-MiddleViewTopMargin-45);
        [self.scrollView addSubview:vc.view];
    }
    
    self.scrollView.contentSize = CGSizeMake(ScreenW * controllers.count, self.scrollView.sy_height);
    
    [self addNotification];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changTopMargin:) name:@"SYSlideSelectedViewFrameChangeNotificaiton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endChangeTopMargin) name:@"SYSlideSelectedViewFrameChangeEndNotificaiton" object:nil];
}

- (void)changTopMargin:(NSNotification *)noti {
    NSValue *value = noti.userInfo[@"offset"];
    CGPoint offset = [value CGPointValue];
    if (offset.y > -90 && offset.y < 0) {
        self.middleViewTopMargin.constant = MiddleViewTopMargin - 90 - offset.y;
    }else if (offset.y >= 0) {
        self.middleViewTopMargin.constant = MiddleViewTopMargin - 90;
    }else if (offset.y <= -90) {
        self.middleViewTopMargin.constant = MiddleViewTopMargin;
    }
}

- (void)endChangeTopMargin {
    [self layoutSubTableViewContentOffset];
}

- (void)layoutSubTableViewContentOffset {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (int i = 0 ; i < self.childViewControllers.count ;i++) {
        
        if (self.slideView.selectedIndex == i) {
            continue;
        }
        
        UITableViewController *tableVC = self.childViewControllers[i];
        
        if (self.middleViewTopMargin.constant == MiddleViewTopMargin - 90) {
            if (tableVC.tableView.contentOffset.y >= -90 && tableVC.tableView.contentOffset.y < 0) {
                tableVC.tableView.contentOffset = CGPointMake(0, 0);
            }
        }else {
            tableVC.tableView.contentOffset = CGPointMake(0,MiddleViewTopMargin - 90-self.middleViewTopMargin.constant);
        }
    }
    
    [self addNotification];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.slideView slideLineOffset:scrollView.contentOffset.x/self.slideView.titles.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SYSlideSelectedView *)slideView {
    if (_slideView == nil) {
        _slideView = [[SYSlideSelectedView alloc] initWithTitles:@[@"专家简介",@"专家课程",@"专家问答",@"学员评价"] frame:CGRectMake(0,89.5, ScreenW, 46) normalColor:[UIColor sy_colorWithRGB:0x000000] andSelectedColor:[UIColor sy_colorWithRGB:0xde2418]];
        __weak typeof(self) weakSelf = self;
        [_slideView setButtonAciton:^(NSInteger index) {
            [weakSelf.scrollView setContentOffset:CGPointMake(index*weakSelf.scrollView.sy_width, 0)animated:YES];
            [weakSelf layoutSubTableViewContentOffset];
        }];
    }
    return _slideView;
}

-(void)dealloc {
    NSLog(@"控制器消失");
}

@end
