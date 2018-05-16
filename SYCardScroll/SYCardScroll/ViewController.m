//
//  ViewController.m
//  SYCardScroll
//
//  Created by leju_esf on 2017/7/17.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+SYExtension.h"
#import "SYCollectionViewCell.h"
#import "SYTableViewController.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ItemH (ScreenH - 64)/4

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.decelerationRate = 1.0;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SYCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SYCollectionViewCell"];
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayout.itemSize = CGSizeMake(ScreenW, ItemH);
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.collectionView.contentOffset = CGPointMake(0, self.flowLayout.itemSize.height* 400000);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat centerY = self.collectionView.contentOffset.y +  self.collectionView.frame.size.height * 0.5;
        for (int i = 0; i < self.collectionView.visibleCells.count; i++) {
            SYCollectionViewCell *cell = self.collectionView.visibleCells[i];
            cell.rightMargin.constant = fabs(cell.center.y - centerY) * 0.05 + 5;
            cell.leftMargin.constant = fabs(cell.center.y - centerY) * 0.05 + 5;
            cell.bottomMargin.constant = fabs(cell.center.y - centerY) * 0.02 + 5;
            cell.topMargin.constant = fabs(cell.center.y - centerY) * 0.02 + 5;
        }
    });
}

- (CGPoint)itemCenterOffsetWithOriginalTargetContentOffset:(CGPoint)orifinalTargetContentOffset {
    if (orifinalTargetContentOffset.y > 0) {
        CGFloat countRate = orifinalTargetContentOffset.y/(ItemH);
        NSInteger count = (NSInteger)countRate;
        if (countRate - count > 0.5) {
            count = count + 1;
        }
//        NSLog(@"页数%zd----高度:%f----总高度:%f",count,ItemH,count*ItemH);
        return CGPointMake(0, count*ItemH);
    }else {
        return CGPointZero;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    *targetContentOffset = [self itemCenterOffsetWithOriginalTargetContentOffset:CGPointMake(targetContentOffset->x, targetContentOffset->y)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat centerY = scrollView.contentOffset.y + scrollView.frame.size.height * 0.5;
    for (int i = 0; i < self.collectionView.visibleCells.count; i++) {
        SYCollectionViewCell *cell = self.collectionView.visibleCells[i];
        cell.rightMargin.constant = fabs(cell.center.y - centerY) * 0.05 + 5;
        cell.leftMargin.constant = fabs(cell.center.y - centerY) * 0.05 + 5;
        cell.bottomMargin.constant = fabs(cell.center.y - centerY) * 0.02 + 5;
        cell.topMargin.constant = fabs(cell.center.y - centerY) * 0.02 + 5;
    }
}

#pragma mark - UICollectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1200000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SYCollectionViewCell class]) forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row%4];
    NSLog(@"------%zd",indexPath.row);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    SYTableViewController *tableViewVc = [[SYTableViewController alloc] init];
    [self.navigationController pushViewController:tableViewVc animated:YES];
}

@end
