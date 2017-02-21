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

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *models;
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
}

#pragma mark - UICollectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
//    UILabel *label = [cell.contentView viewWithTag:10];
//    if (label == nil) {
//        label = [[UILabel alloc] initWithFrame:cell.bounds];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.tag = 10;
//        [cell.contentView addSubview:label];
//    }
//    label.text = [NSString stringWithFormat:@"%zd",indexPath.row];
//    return cell;
    SYHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SYHomeCell class]) forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
//    cell.nameLabel.textColor = [UIColor blackColor];
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


@end
