//
//  LGTTalkItemView.m
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/7.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTTalkItemView.h"
#import <Masonry/Masonry.h>
#import "LGTExtension.h"

@interface LGTItemCell : UICollectionViewCell
@property (nonatomic,strong) UILabel *titleL;
@end
@implementation LGTItemCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont systemFontOfSize:16];
        _titleL.textColor = [UIColor whiteColor];
    }
    return _titleL;
}
@end

@interface LGTTalkItemView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) NSArray *itemTitles;

@end
@implementation LGTTalkItemView
- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)itemTitles{
    if (self = [super initWithFrame:frame]) {
        self.itemTitles = itemTitles;
        [self layoutViews];
    }
    return self;
}
- (void)layoutViews{
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self lgt_clipLayerWithRadius:4 width:0 color:nil];
}
+ (LGTTalkItemView *)showOnView:(UIView *)view frame:(CGRect)frame itemTitles:(NSArray *)itemTitles{
    LGTTalkItemView *itemView = [[LGTTalkItemView alloc] initWithFrame:frame itemTitles:itemTitles];
    itemView.maskView = [[UIView alloc] initWithFrame:view.bounds];
    itemView.maskView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:itemView action:@selector(hide)];
    [itemView.maskView addGestureRecognizer:tap];
    [view addSubview:itemView.maskView];
    [view addSubview:itemView];
    return itemView;
}
- (void)hide{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^(void) {
        [weakSelf.maskView removeFromSuperview];
        [weakSelf removeFromSuperview];
    } completion:^(BOOL isFinished) {
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemTitles.count;;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LGTItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LGTItemCell class]) forIndexPath:indexPath];
    cell.titleL.text = self.itemTitles[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LGTTalkItemView:didSelectedItemAtIndex:itemTitle:)]) {
        [self.delegate LGTTalkItemView:self didSelectedItemAtIndex:indexPath.row itemTitle:self.itemTitles[indexPath.row]];
    }
    [self hide];
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //        layout.sectionInset = UIEdgeInsetsMake(3, 0, 3, 0);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 1;
        CGFloat w = (self.width-(self.itemTitles.count - 1)*layout.minimumLineSpacing)/self.itemTitles.count;
        layout.itemSize = CGSizeMake(w, self.height);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[LGTItemCell class] forCellWithReuseIdentifier:NSStringFromClass([LGTItemCell class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}
@end
