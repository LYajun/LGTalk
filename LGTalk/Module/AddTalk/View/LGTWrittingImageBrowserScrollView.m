//
//  LGTWrittingImageBrowserScrollView.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2019/4/30.
//  Copyright © 2019 lange. All rights reserved.
//

#import "LGTWrittingImageBrowserScrollView.h"
#import <Masonry/Masonry.h>
#import "LGTConst.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LGTExtension.h"

@interface LGTWrittingImageBrowserScrollView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;

@end
@implementation LGTWrittingImageBrowserScrollView
- (instancetype) initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
        [self addSubview:self.imageView];
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
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage lgt_imageNamed:@"yj_img_placeholder" atDir:@"Main"]];
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
