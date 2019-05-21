//
//  LGTPhotoBrowserViewController.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/9/14.
//  Copyright © 2017年 lange. All rights reserved.
//

#import "LGTPhotoBrowserViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LGTConst.h"
#import "LGTExtension.h"

@interface LGTPhotoScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic,strong) NSString *imageName;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,copy) void (^ClickBlock) (void);
@end
@implementation LGTPhotoScrollView

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        self.imageView.frame = self.bounds;
        self.maximumZoomScale = 2;
        self.minimumZoomScale = 0.5;
        self.delegate = self;
        //添加图片点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)click{
    if (self.ClickBlock) {
        self.ClickBlock();
    }
}
- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    [self layoutImageV];
}
- (void)layoutImageV{
    if (!LGT_IsStrEmpty(self.imageName)) {
        self.imageView.image = [UIImage imageNamed:self.imageName];
    }else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage lgt_imageWithColor:LGT_ColorWithHex(0x999999) size:CGSizeMake(LGT_ScreenWidth, LGT_ScreenHeight)]];
    }
}
- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [self layoutImageV];
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
    }
    return _imageView;
}
#pragma mark - 指定缩放视图（必须得是scrollView的子视图）
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = self.imageView.frame;
    CGSize contentSize = scrollView.contentSize;
    CGPoint centerPoint = CGPointMake(contentSize.width / 2, contentSize.height / 2);
    
    // center horizontally如果图片的宽比scrollView的宽小，那么就用scrollView的宽
    if (imgFrame.size.width <= boundsSize.width){
        centerPoint.x = boundsSize.width / 2;
    }
    // center vertically如果图片的宽比scrollView的高小，那么就用scrollView的高
    if (imgFrame.size.height <= boundsSize.height){
        centerPoint.y = boundsSize.height / 2;
    }
    
    self.imageView.center = centerPoint;
    
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    if (scrollView.zoomScale < 1){
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.zoomScale = 1;
        }];
    }
}

@end

@interface LGTPhotoBrowserViewController ()<UIScrollViewDelegate>
{
    CGFloat _dragOffsetX;
}
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *pageControl;
@end

@implementation LGTPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
- (void)initUI{
    NSInteger count = LGT_IsArrEmpty(self.imageNames) ? self.imageUrls.count:self.imageNames.count;
    self.view.backgroundColor = [UIColor whiteColor];
     [self.view addSubview:self.scrollView];
    for (int i = 0; i < count; i++) {
        LGTPhotoScrollView *photoView = [[LGTPhotoScrollView alloc] initWithFrame:CGRectMake(LGT_ScreenWidth*i, 0, LGT_ScreenWidth, LGT_ScreenHeight)];
        if (!LGT_IsArrEmpty(self.imageNames)) {
            photoView.imageName = self.imageNames[i];
        }else{
            photoView.imageUrl = self.imageUrls[i];
        }
        WeakSelf;
        photoView.ClickBlock = ^{
            [selfWeak dismissViewControllerAnimated:YES completion:nil];
        };
        [self.scrollView addSubview:photoView];
    }
    self.scrollView.contentSize = CGSizeMake(LGT_ScreenWidth*count, LGT_ScreenHeight);
    self.scrollView.contentOffset = CGPointMake(LGT_ScreenWidth*self.imageIndex, 0);
    [self.view addSubview:self.pageControl];
    self.pageControl.numberOfPages = count;
    self.pageControl.currentPage = self.imageIndex;
}
#pragma mark - UIScrollView delegate
//collection滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat contenOffset = scrollView.contentOffset.x;
    if (fabs(_dragOffsetX - contenOffset) > LGT_ScreenWidth / 2) {
        //通过滚动算出在哪一页
        int page = contenOffset / LGT_ScreenWidth;
        LGTPhotoScrollView *photo = scrollView.subviews[self.pageControl.currentPage];
        if (photo.zoomScale != 1) {
            photo.zoomScale = 1.0;
        }
        self.pageControl.currentPage = page;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _dragOffsetX = scrollView.contentOffset.x;
}
#pragma mark LGTPhotoBrowserAnimator dismissDelegate
- (NSInteger)currentIndexForDismissView{
    return self.pageControl.currentPage;
}

- (UIImageView *)currentImageViewForDismissView{
    UIImageView *imageView = [[UIImageView alloc] init];
    if (!LGT_IsArrEmpty(self.imageNames)) {
        imageView.image = [UIImage imageNamed:self.imageNames[self.pageControl.currentPage]];
    }else{
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[self.pageControl.currentPage]] placeholderImage:[UIImage lgt_imageWithColor:LGT_ColorWithHex(0x999999) size:CGSizeMake(LGT_ScreenWidth, LGT_ScreenHeight)]];
    }
    UIImage *image = imageView.image;
    CGFloat width = LGT_ScreenWidth;
    CGFloat height = width / image.size.width * image.size.height;
    CGFloat y = 0;
    if(height < LGT_ScreenHeight){
        y = (LGT_ScreenHeight - height) * 0.5;
    }
    imageView.frame = CGRectMake(0, y, width, height);
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    return imageView;
}
#pragma mark Property init
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.height-40, LGT_ScreenWidth, 20)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}
@end
