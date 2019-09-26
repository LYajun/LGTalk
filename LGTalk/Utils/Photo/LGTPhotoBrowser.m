//
//  LGTPhotoBrowser.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/9/14.
//  Copyright © 2017年 lange. All rights reserved.
//

#import "LGTPhotoBrowser.h"
#import "LGTPhotoBrowserAnimator.h"
#import "LGTPhotoBrowserViewController.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "LGTConst.h"
#import "LGTExtension.h"

@interface LGTPhotoBrowserCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *imageView;
@end
@implementation LGTPhotoBrowserCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            if (LGT_IsIPad()) {
                make.left.equalTo(self.contentView.mas_left).offset(2.5);
                make.top.equalTo(self.contentView.mas_top).offset(2.5);
            }else{
                make.left.equalTo(self.contentView.mas_left).offset(1);
                make.top.equalTo(self.contentView.mas_top).offset(1);
            }
        }];
        self.imageView.clipsToBounds = YES;
    }
    return self;
}

@end

@interface LGTPhotoBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource,LGTPhotoBrowserAnimatorPresentDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic, strong)LGTPhotoBrowserAnimator *animator;
/** 视图宽度 */
@property (nonatomic,assign) CGFloat selfWidth;
@end
@implementation LGTPhotoBrowser
- (instancetype)initWithFrame:(CGRect)frame width:(CGFloat)width{
    if (self = [super initWithFrame:frame]) {
        self.selfWidth = width;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
- (void)setImageUrls:(NSArray<NSString *> *)imageUrls{
    _imageUrls = imageUrls;
    [self.collectionView reloadData];
}
- (void)setImageNames:(NSArray<NSString *> *)imageNames{
    _imageNames = imageNames;
    [self.collectionView reloadData];
}
#pragma mark UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!LGT_IsArrEmpty(self.imageNames)) {
        return self.imageNames.count;
    }
    return self.imageUrls.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LGTPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LGTPhotoBrowserCell class]) forIndexPath:indexPath];
    if (!LGT_IsArrEmpty(self.imageNames)){
        cell.imageView.image = [UIImage imageNamed:self.imageNames[indexPath.row]];
    }else{
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[indexPath.row]] placeholderImage:[UIImage lgt_imageWithColor:LGT_ColorWithHex(0x999999) size:CGSizeMake(LGT_ScreenWidth, LGT_ScreenHeight)]];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LGTPhotoBrowserViewController *photoVC = [[LGTPhotoBrowserViewController alloc] init];
    photoVC.imageNames = self.imageNames;
    photoVC.imageUrls = self.imageUrls;
    photoVC.imageIndex = indexPath.row;
    photoVC.modalPresentationStyle = UIModalPresentationCustom;
    photoVC.transitioningDelegate = self.animator;
    self.animator.animationPresentDelegate = self;
    self.animator.index = indexPath.row;
    self.animator.animationDismissDelegate = photoVC;
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController){
        topRootViewController = topRootViewController.presentedViewController;
    }
    [topRootViewController presentViewController:photoVC animated:YES completion:nil];

}
#pragma mark LGTPhotoBrowserAnimator delegate
- (CGRect)startRect:(NSInteger)index{
    LGTPhotoBrowserCell *cell = (LGTPhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return [self convertRect:cell.frame toView:[UIApplication sharedApplication].keyWindow];
}
- (CGRect)endRect:(NSInteger)index{
   LGTPhotoBrowserCell *cell = (LGTPhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    UIImage *image = cell.imageView.image;
    //计算imageView的frame
    CGFloat x = 0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = width / image.size.width * image.size.height;
    CGFloat y = 0;
    if(height < [UIScreen mainScreen].bounds.size.height){
        y = ([UIScreen mainScreen].bounds.size.height - height) * 0.5;
    }
    return CGRectMake(x, y, width, height);
}
- (UIImageView *)currentBrowseImageView:(NSInteger)index{
    LGTPhotoBrowserCell *cell = (LGTPhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = cell.imageView.image;
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    return imageView;
}
#pragma mark Property init
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(self.selfWidth/3, self.selfWidth/3);
//        layout.headerReferenceSize = CGSizeMake(LGT_ScreenWidth, 1);
        layout.sectionInset = UIEdgeInsetsZero;
        layout.collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[LGTPhotoBrowserCell class] forCellWithReuseIdentifier:NSStringFromClass([LGTPhotoBrowserCell class])];
    }
    return _collectionView;
}
- (LGTPhotoBrowserAnimator *)animator{
    if(!_animator){
        _animator = [[LGTPhotoBrowserAnimator alloc] init];
    }
    return _animator;
}
@end
