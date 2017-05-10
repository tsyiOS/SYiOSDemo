//
//  SYCarouselView.m
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/10.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYCarouselView.h"
#import "SYHomeAdModel.h"

@interface SYCarouselView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *adList;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation SYCarouselView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self.collectionView registerClass:[SYCarouselCell class] forCellWithReuseIdentifier:NSStringFromClass([SYCarouselCell class])];
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.timer fire];
    });
}

#pragma mark - UICollectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.adList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYCarouselCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SYCarouselCell class]) forIndexPath:indexPath];
    SYHomeAdModel *model = self.adList[indexPath.item];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.picture]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SYHomeAdModel *model = self.adList[indexPath.item];
    if (self.clickAction) {
        self.clickAction(model.clickHref);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger count = (NSInteger)(self.collectionView.contentOffset.x/self.collectionView.sy_width);
    CGFloat rate = (self.collectionView.contentOffset.x/self.collectionView.sy_width);
    if (rate - count >= 0.5) {
        count += 1;
    }
    
    if (rate == 0) {
         [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.adList.count - 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }else if (rate == self.adList.count - 1) {
         [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    NSInteger page = 0;
    if (count == 0) {
        page = self.adList.count - 3;
    }else if (count == self.adList.count - 1) {
        page = 0;
    }else {
        page = count - 1;
    }
    self.pageControl.currentPage = page;
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = self.bounds.size;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
    }
    return _flowLayout;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.sy_height - 20, self.sy_width, 20)];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.numberOfPages = self.adList.count - 2;
    }
    return _pageControl;
}

- (NSArray *)adList {
    if (_adList == nil) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[SYHomeAdModel models]];
        [tempArray insertObject:tempArray.lastObject atIndex:0];
        [tempArray addObject:tempArray[1]];
        _adList = tempArray;
    }
    return _adList;
}

- (NSTimer *)timer {
    if (_timer == nil) {
        __weak typeof(self) weakSelf = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:weakSelf.pageControl.currentPage + 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }];
    }
    return _timer;
}

@end

@implementation SYCarouselCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor whiteColor];
    }
    return _imageView;
}
@end
