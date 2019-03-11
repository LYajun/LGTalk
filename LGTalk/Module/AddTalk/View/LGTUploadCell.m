//
//  LGTUploadCell.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/8/28.
//  Copyright © 2017年 lange. All rights reserved.
//

#import "LGTUploadCell.h"
#import "LGTBarProgressView.h"
#import <Masonry/Masonry.h>
#import "LGTExtension.h"

#pragma mark -

@interface LGTMoreCell ()
@property (nonatomic,strong)UIImageView *imageView;
@end
@implementation LGTMoreCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configure];
        [self initUI];
    }
    return self;
}
- (void)configure{
    self.backgroundColor = [UIColor whiteColor];
}
- (void)initUI{
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage lgt_imageNamed:@"add_photo" atDir:@"Main"]];
    }
    return _imageView;
}
@end

#pragma mark -

@interface LGTUploadCell ()
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIImageView *successimageView;
@property (nonatomic,strong)LGTBarProgressView *progressView;
@end
@implementation LGTUploadCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configure];
        [self initUI];
    }
    return self;
}
- (void)configure{
    self.backgroundColor = [UIColor whiteColor];
    [self lgt_clipLayerWithRadius:0 width:1 color:[UIColor lightGrayColor]];
}
- (void)initUI{
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
     [self.contentView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.height.mas_equalTo(6);
    }];

}
- (void)setTaskImage:(UIImage *)taskImage{
    self.imageView.image = taskImage;
}
- (void)setUploadProgress:(CGFloat)progress{
    if (progress == 0) {
        self.progressView.hidden = YES;
    }else{
         self.progressView.hidden = NO;
    }
    self.progressView.progress = progress;
}
- (UIImageView *)successimageView{
    if (!_successimageView) {
        _successimageView = [[UIImageView alloc] initWithImage:[UIImage lgt_imageNamed:@"success_green" atDir:@"Main"]];
        _successimageView.hidden = YES;
    }
    return _successimageView;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
- (LGTBarProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[LGTBarProgressView alloc] initWithFrame:CGRectZero];
        _progressView.hidden = YES;
    }
    return _progressView;
}
@end
