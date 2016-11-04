//
//  ViewController.m
//  SYCustomCollectionViewLayout
//
//  Created by leju_esf on 16/11/4.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "ViewController.h"
#import "SYTagsLayout.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SYTagsLayout *layout;
@property (nonatomic, strong) NSArray *datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
//    self.layout.datas = self.datas;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *label = [cell.contentView viewWithTag:10];
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:cell.bounds];
        [cell.contentView addSubview:label];
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 10;
    }
    label.frame = cell.bounds;
    label.text = self.datas[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd",indexPath.row);
    self.datas = [self.datas arrayByAddingObjectsFromArray:self.datas];
    self.layout.datas = self.datas;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
//        _collectionView.contentInset = UIEdgeInsetsMake(10, 15, 10, 15);
    }
    return _collectionView;
}

- (SYTagsLayout *)layout {
    if (_layout == nil) {
        _layout = [[SYTagsLayout alloc] init];
        _layout.minimumLineSpacing = 10;
        _layout.minimumInteritemSpacing = 5;
        _layout.datas = self.datas;
        _layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
//        _layout.itemContentInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    }
    return _layout;
}

- (NSArray *)datas {
    if (_datas == nil) {
        _datas = @[@"朝阳",@"朝阳朝阳",@"朝阳朝阳朝阳",@"朝阳朝阳阳",@"朝朝阳阳",@"朝阳朝",@"朝朝阳朝阳阳",@"朝朝阳朝阳朝阳阳",@"朝朝阳阳",@"朝朝阳",@"朝阳",@"朝阳朝阳",@"朝阳朝朝阳",@"朝阳朝阳",@"朝阳",@"朝阳朝阳",@"朝阳朝阳朝阳",@"朝阳朝阳阳",@"朝朝阳阳",@"朝阳朝",@"朝朝阳朝阳阳",@"朝朝阳朝阳朝阳阳",@"朝朝阳阳",@"朝朝阳",@"朝阳",@"朝阳朝阳",@"朝阳朝朝阳",@"朝阳朝阳",@"朝阳",@"朝阳朝阳",@"朝阳朝阳朝阳",@"朝阳朝阳阳",@"朝朝阳阳",@"朝阳朝",@"朝朝阳朝阳阳",@"朝朝阳朝阳朝阳阳",@"朝朝阳阳",@"朝朝阳",@"朝阳",@"朝阳朝阳",@"朝阳朝朝阳",@"朝阳朝阳",@"朝阳",@"朝阳朝阳",@"朝阳朝阳朝阳",@"朝阳朝阳阳",@"朝朝阳阳",@"朝阳朝",@"朝朝阳朝阳阳朝朝阳朝阳阳朝朝阳朝阳阳朝朝阳朝阳阳朝朝阳朝阳阳",@"朝朝阳朝阳朝阳阳",@"朝朝阳阳",@"朝朝阳",@"朝阳",@"朝阳朝阳",@"朝阳朝朝阳",@"朝阳朝阳",@"朝阳",@"朝阳朝阳",@"朝阳朝阳朝阳",@"朝阳朝阳阳",@"朝朝阳阳",@"朝阳朝",@"朝朝阳朝阳阳",@"朝朝阳朝阳朝阳阳",@"朝朝阳阳",@"朝朝阳",@"朝阳",@"朝阳朝阳",@"朝阳朝朝阳",@"朝阳朝阳",@"朝阳",@"朝阳朝阳",@"朝阳朝阳朝阳",@"朝阳朝阳阳",@"朝朝阳阳",@"朝阳朝",@"朝朝阳朝阳阳",@"朝朝阳朝阳朝阳阳",@"朝朝阳阳",@"朝朝阳",@"朝阳",@"朝阳朝阳",@"朝阳朝朝阳",@"朝阳朝阳"];
    }
    return _datas;
}
@end
