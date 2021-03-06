//
//  LGTWrittingImageViewer.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/7/3.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTWrittingImageViewer.h"
#import "LGTWrittingImageBrowserScrollView.h"
#import <Masonry/Masonry.h>
#import "LGTConst.h"
#import "LGTExtension.h"

@interface LGTWrittingImageViewer ()<UIScrollViewDelegate>
@property (nonatomic,assign) CGFloat dragOffsetX;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UILabel *pageLab;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) NSInteger imageCount;
@end
@implementation LGTWrittingImageViewer
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images atIndex:(NSInteger)index{
    if (self = [super initWithFrame:frame]) {
        self.imageCount = images.count;
        [self addSubview:self.scrollView];
        for (int i = 0; i < self.imageCount; i++) {
            LGTWrittingImageBrowserScrollView *photoView = [[LGTWrittingImageBrowserScrollView alloc] initWithFrame:CGRectMake(LGT_ScreenWidth*i, 0, LGT_ScreenWidth, LGT_ScreenHeight)];
            if ([images.firstObject isKindOfClass:NSString.class]) {
                photoView.imageUrl = images[i];
            }else{
                photoView.scrollImg = images[i];
            }
            __weak typeof(self) weakSelf = self;
            photoView.ClickBlock = ^{
                [weakSelf hide];
            };
            [self.scrollView addSubview:photoView];
        }
        self.scrollView.contentSize = CGSizeMake(LGT_ScreenWidth*self.imageCount, LGT_ScreenHeight);
        self.scrollView.contentOffset = CGPointMake(LGT_ScreenWidth*index, 0);
        [self addSubview:self.pageLab];
        self.currentIndex = index;
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+ (void)showWithImageUrls:(NSArray *)imageUrls atIndex:(NSInteger)index{
    LGTWrittingImageViewer *imgViewerView = [[LGTWrittingImageViewer alloc] initWithFrame:[UIScreen mainScreen].bounds images:imageUrls atIndex:index];
    [imgViewerView show];
}
+ (void)showWithImages:(NSArray *)images atIndex:(NSInteger)index{
    LGTWrittingImageViewer *imgViewerView = [[LGTWrittingImageViewer alloc] initWithFrame:[UIScreen mainScreen].bounds images:images atIndex:index];
    [imgViewerView show];
}
- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}
- (void)creatShowAnimation{
    self.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}
- (void)hide{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}
- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    self.pageLab.text = [NSString stringWithFormat:@"%li/%li",currentIndex+1,self.imageCount];
}
#pragma mark - UIScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat contenOffset = scrollView.contentOffset.x;
    if (fabs(_dragOffsetX - contenOffset) > LGT_ScreenWidth / 2) {
        //通过滚动算出在哪一页
        int page = contenOffset / LGT_ScreenWidth;
        LGTWrittingImageBrowserScrollView *photo = scrollView.subviews[self.currentIndex];
        if (photo.zoomScale != 1) {
            photo.zoomScale = 1.0;
        }
        self.currentIndex = page;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _dragOffsetX = scrollView.contentOffset.x;
}
#pragma mark - Getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
- (UILabel *)pageLab{
    if (!_pageLab) {
        _pageLab = [[UILabel alloc] initWithFrame:CGRectMake(LGT_ScreenWidth - 35 - 10, 44 + LGT_StateBarSpace(), 35, 20)];
        _pageLab.textAlignment = NSTextAlignmentCenter;
        _pageLab.textColor = [UIColor whiteColor];
        _pageLab.backgroundColor = LGT_ColorWithHexA(0x000000, 0.4);
        _pageLab.font = [UIFont systemFontOfSize:15];
        [_pageLab lgt_clipLayerWithRadius:3 width:1 color:[UIColor lightGrayColor]];
    }
    return _pageLab;
}

@end
