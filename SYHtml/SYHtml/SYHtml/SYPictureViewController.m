//
//  SYPictureViewController.m
//  SYHtml
//
//  Created by leju_esf on 16/11/16.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYPictureViewController.h"
#import "SYHtmlManager.h"
//#import "MJPhotoBrowser.h"
//#import "MJPhoto.h"
#import "UIImageView+WebCache.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface SYPictureViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *list;
@end

@implementation SYPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.itemSize = CGSizeMake(ScreenW, ScreenH - 64);
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    // Do any additional setup after loading the view from its nib.
    [[SYHtmlManager sharedSYHtmlManager] requestDataWithUrl:self.urlString andType:SYHtmlTypePicture completion:^(id response) {
        if (response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.list = (NSArray *)response;
                [self.collectionView reloadData];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
   
    UIImageView *imageView = [cell.contentView viewWithTag:10];
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        imageView.tag = 10;
        [cell.contentView addSubview:imageView];
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.list[indexPath.item]]];
    
    UILabel *label = [cell.contentView viewWithTag:11];
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, 50)];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 11;
        label.numberOfLines = 0;
        [cell.contentView addSubview:label];
    }
    label.text = self.list[indexPath.item];
    
    return cell;
}

- (NSArray *)list {
    if (_list == nil) {
        _list = [NSArray array];
    }
    return _list;
}

@end
