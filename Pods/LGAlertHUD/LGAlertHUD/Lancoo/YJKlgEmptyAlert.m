//
//  YJKlgEmptyAlert.m
//  LGAlertHUDDemo
//
//  Created by 刘亚军 on 2019/9/2.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJKlgEmptyAlert.h"
#import <Masonry/Masonry.h>
#import <YJExtensions/YJExtensions.h>
#import "LGAlertHUD.h"

@interface YJKlgEmptyAlert ()
@property (nonatomic,strong) UIImageView *bgImgView;
@property (nonatomic,strong) UILabel *contentLab;
@property(nonatomic,strong) UIView *maskView;
@end
@implementation YJKlgEmptyAlert

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgImgView];
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-20);
        }];
        
        [self addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgImgView);
            make.centerY.equalTo(self.bgImgView).offset(self.bgImgView.image.size.height*0.5*0.35);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


+ (YJKlgEmptyAlert *)klgEmptyAlertWithText:(NSString *)text{
    YJKlgEmptyAlert *klgAlert = [[YJKlgEmptyAlert alloc] initWithFrame:[UIScreen mainScreen].bounds];
    klgAlert.contentLab.text = text;
     klgAlert.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    klgAlert.maskView.backgroundColor = [UIColor yj_colorWithHex:0x000000 alpha:0.6];
    
    return klgAlert;
}

- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].delegate.window;
    for (UIView *view in rootWindow.subviews) {
        if ([view isKindOfClass:[YJKlgEmptyAlert class]]) {
            [(YJKlgEmptyAlert *)view hide];
        }
    }
    [rootWindow addSubview:self.maskView];
    [rootWindow addSubview:self];

    self.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                             CGAffineTransformMakeScale(0.7f, 0.7f));
    self.alpha = 0.0f;
     self.maskView.alpha = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        self.maskView.alpha = 0.6f;
        self.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                     CGAffineTransformMakeScale(1.0f, 1.0f));
        self.alpha = 1.0f;
    }];
}
- (void)hide{
    [UIView animateWithDuration:0.2 animations:^(void) {
        self.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                     CGAffineTransformMakeScale(0.1f, 0.1f));
        self.maskView.alpha = 0.0f;
        self.alpha = 0.0f;
    } completion:^(BOOL isFinished) {
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"lgklg_icon_klg_empty" atBundle:LGAlert.alertBundle]];
    }
    return _bgImgView;
}
- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:16];
        _contentLab.textColor = [UIColor yj_colorWithHex:0x989898];
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}
@end
