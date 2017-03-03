//
//  ViewController.m
//  Lottery
//
//  Created by leju_esf on 17/2/20.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "UIView+SYExtension.h"
#import "SYHomeCell.h"
#import "UIColor+SYExtension.h"
#import "SYWebViewController.h"
#import "SYGameModel.h"
#import "AFNetworking.h"
#import "SYHomeViewController.h"

#define URL @"http://appmgr.jwoquxoc.com/frontApi/getAboutUs"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) UIView *shadowView;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SYHomeCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SYHomeCell class])];
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.itemSize = CGSizeMake(ScreenW/2, 100);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.view addSubview:self.shadowView];
    [self requestData];
}

- (void)requestData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html", @"text/plain"]];
    [manager POST:URL parameters:@{@"appid":@"amdcapp37"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger isshow = [[responseObject objectForKey:@"isshowwap"] integerValue];
        if (isshow == 1) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsLoadUrl];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:kUserInformation];
//            SYWebViewController *webVC = [[SYWebViewController alloc] initWithNibName:NSStringFromClass([SYWebViewController class]) bundle:nil];
//            [self.navigationController pushViewController:webVC animated:NO];
        }else {
            [self.shadowView removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsLoadUrl];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUserInformation];
        }
        SYHomeViewController *webVC = [[SYHomeViewController alloc] initWithNibName:NSStringFromClass([SYHomeViewController class]) bundle:nil];
        [self.navigationController pushViewController:webVC animated:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.shadowView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsLoadUrl];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUserInformation];
        SYHomeViewController *webVC = [[SYHomeViewController alloc] initWithNibName:NSStringFromClass([SYHomeViewController class]) bundle:nil];
        [self.navigationController pushViewController:webVC animated:NO];
    }];
    
    
}

#pragma mark - UICollectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SYHomeCell class]) forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SYWebViewController *webVC = [[SYWebViewController alloc] initWithNibName:NSStringFromClass([SYWebViewController class]) bundle:nil];
    webVC.model = self.models[indexPath.item];
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)models {
    if (_models == nil) {
        _models = [SYGameModel games];
    }
    return _models;
}

- (UIView *)shadowView {
    if (_shadowView == nil) {
        _shadowView = [[UIView alloc] initWithFrame:self.view.bounds];
        _shadowView.backgroundColor = [UIColor whiteColor];
    }
    return _shadowView;
}


@end
