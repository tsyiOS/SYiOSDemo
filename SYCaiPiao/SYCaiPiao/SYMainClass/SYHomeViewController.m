

//
//  SYHomeViewController.m
//  ;
//
//  Created by leju_esf on 17/5/5.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYHomeViewController.h"
#import "SYCityModel.h"
#import "SYAttributedStringModel.h"
#import "SYHomeCell.h"
#import "SYCarouselView.h"

@interface SYHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) SYCarouselView *carouselView;
@end

@implementation SYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SYHomeCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SYHomeCell class])];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(ScreenW * 0.4, 0, 0, 0);
    [self.collectionView addSubview:self.carouselView];
    
    self.flowLayout.itemSize = CGSizeMake(ScreenW*0.5, 80);
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
}

#pragma mark - UICollectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SYHomeCell class]) forIndexPath:indexPath];
    cell.model = self.list[indexPath.item];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor sy_colorWithRGB:0xeeeeee]];
}

- (void)collectionView:(UICollectionView *)collectionView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SYHomeDataModel *model = self.list[indexPath.item];
    [self pushToWebViewWithUrl:model.attribute.jumpUrl];
}

- (void)pushToWebViewWithUrl:(NSString *)url {
    SYWebViewController *web = [SYWebViewController instancetFromNib];
    web.url = url;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark - 懒加载
- (NSArray *)list {
    if (_list == nil) {
        NSArray *array = [SYHomeDataModel models];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (SYHomeDataModel *model in array) {
            if (model.attribute.logo.length != 0 && model.attribute.cardName.length != 0 && model.attribute.jumpUrl.length != 0 && [model.attribute.jumpUrl hasPrefix:@"http"]) {
                [tempArray addObject:model];
            }
        }
        _list = tempArray;
    }
    return _list;
}

- (SYCarouselView *)carouselView {
    if (_carouselView == nil) {
        _carouselView = [[SYCarouselView alloc] initWithFrame:CGRectMake(0, ScreenW*(-0.4), ScreenW, ScreenW*0.4)];
        __weak typeof(self) weakSelf = self;
        [_carouselView setClickAction:^(NSString *url) {
            [weakSelf pushToWebViewWithUrl:url];
        }];
    }
    return _carouselView;
}


@end
