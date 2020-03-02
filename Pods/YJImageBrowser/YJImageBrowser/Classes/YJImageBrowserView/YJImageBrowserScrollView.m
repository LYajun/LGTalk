//
//  YJImageBrowserScrollView.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2019/4/30.
//  Copyright © 2019 lange. All rights reserved.
//

#import "YJImageBrowserScrollView.h"
#import "YJImageBrowserConst.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YJCircleTitleProgressView.h"

@interface YJImageBrowserScrollView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) YJCircleTitleProgressView *progressView;
@end
@implementation YJImageBrowserScrollView
- (instancetype) initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
       

        self.progressView = [[YJCircleTitleProgressView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        self.progressView.center = self.imageView.center;
        self.progressView.roundedCorners = YES;
        self.progressView.titleProgress = 0;
        self.progressView.trackTintColor = LG_ColorWithHex(0xEAF0F0);
        self.progressView.progressTintColor = LG_ColorWithHex(0x17B0F8);
        self.progressView.innerTintColor = [UIColor clearColor];
        self.progressView.thicknessRatio = 0.12;
        self.progressView.progressLabel.textColor = [UIColor whiteColor];
        self.progressView.progressLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.progressView];
        
        self.maximumZoomScale = 2;
        self.minimumZoomScale = 0.5;
        self.delegate = self;
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
- (void)setScrollImg:(UIImage *)scrollImg{
    _scrollImg = scrollImg;
    self.imageView.image = scrollImg;
}

- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage yj_imageNamed:@"yj_img_placeholder" atBundle:YJImageBrowserBundle()]];
    __weak typeof(self) weakSelf = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (expectedSize > 0) {
                    weakSelf.progressView.titleProgress = receivedSize * 1.0 / expectedSize;
                }else{
                    weakSelf.progressView.titleProgress = 0;
                }
            });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
         dispatch_async(dispatch_get_main_queue(), ^{
             weakSelf.progressView.hidden = YES;
             if (error) {
                 weakSelf.imageView.image = [UIImage yj_imageNamed:@"yj_img_bad" atBundle:YJImageBrowserBundle()];
             }
         });
    }];
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
