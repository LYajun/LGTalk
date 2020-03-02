//
//  YJAnswerAlertCell.m
//  TPFnowledgeFramework
//
//  Created by 刘亚军 on 2018/11/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJAnswerAlertCell.h"
#import <Masonry/Masonry.h>
#import "YJAnswerConst.h"

#import <YJExtensions/YJExtensions.h>

#define kSpace  3

#define kLeftSpace  (IsIPad ? 40 : 10)
#define kCellSpace  (IsIPad ? 24 : 6)
@interface YJAnswerAlertCell ()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UILabel *titleLab;
@end
@implementation YJAnswerAlertCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}
- (CGFloat)alertWidth{
    if (IsIPad) {
        return 400;
    }
    return LG_ScreenWidth*0.72;
}

- (void)layoutUI{
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(kSpace);
        make.width.mas_equalTo(self.contentView.width-10);
    }];
   
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
}
- (void)setIsSingle:(BOOL)isSingle{
    _isSingle = isSingle;
    if (isSingle) {
        if (IsIPad) {
            [self.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(240);
            }];
        }else{
            [self.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(120);
            }];
        }
    }else{
        [self.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.contentView.width-10);
        }];
    }
}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}
- (void)setClickHighlighted:(BOOL)clickHighlighted{
    _clickHighlighted = clickHighlighted;
    CGFloat bgImageWidth = 0;
    CGFloat bgImageHeight = kCellHeight-kSpace*2;
    if (self.isSingle) {
         if (IsIPad) {
             bgImageWidth = 240;
         }else{
             bgImageWidth = 120;
         }
    }else{
        bgImageWidth = (self.alertWidth-kLeftSpace*2-kCellSpace)/2-10;
    }
    
    if (clickHighlighted) {
        self.titleLab.textColor = [UIColor whiteColor];
        self.bgImageView.backgroundColor = LG_ColorWithHex(0x22B0F8);
        [self.bgImageView yj_shadowWithCornerRadius:bgImageHeight/2 borderWidth:0 borderColor:nil shadowColor:LG_ColorWithHex(0x00C3F2) shadowOpacity:0.5 shadowOffset:CGSizeMake(0, 2.5) roundedRect:CGRectMake(3, 2, bgImageWidth-6, bgImageHeight) cornerRadii:CGSizeMake(bgImageHeight/2, bgImageHeight/2) rectCorner:UIRectCornerAllCorners];
    }else{
        self.titleLab.textColor = LG_ColorWithHex(0x22B0F8);
        self.bgImageView.backgroundColor = [UIColor whiteColor];
        [self.bgImageView yj_shadowWithCornerRadius:bgImageHeight/2 borderWidth:1.5 borderColor:LG_ColorWithHex(0x22B0F8) shadowColor:LG_ColorWithHex(0x00C3F2) shadowOpacity:0.5 shadowOffset:CGSizeMake(0, 2.5) roundedRect:CGRectMake(3, 2, bgImageWidth-6, bgImageHeight) cornerRadii:CGSizeMake(bgImageHeight/2, bgImageHeight/2) rectCorner:UIRectCornerAllCorners];
    }
}
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _bgImageView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        if (IsIPad) {
            _titleLab.font = [UIFont systemFontOfSize:17];
        }else{
            if (LG_ScreenWidth <= 320) {
                _titleLab.font = [UIFont systemFontOfSize:12];
            }else if (LG_ScreenWidth <= 375) {
                _titleLab.font = [UIFont systemFontOfSize:14];
            }else{
                _titleLab.font = [UIFont systemFontOfSize:16];
            }
        }
    }
    return _titleLab;
}
@end
