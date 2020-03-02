//
//  YJAnswerAlertChoiceCell.m
//  YJAnswernowledgeFramework
//
//  Created by 刘亚军 on 2018/11/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJAnswerAlertChoiceCell.h"
#import <YJExtensions/YJExtensions.h>
#import <Masonry/Masonry.h>
#import "YJAnswerConst.h"

@interface YJAnswerAlertChoiceCell ()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UILabel *titleLab;
@end
@implementation YJAnswerAlertChoiceCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerY.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView).offset(10);
    }];
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        if (LG_ScreenWidth < 375) {
            make.width.height.mas_equalTo(14);
        }else{
            make.width.height.mas_equalTo(15);
        }
        make.right.equalTo(self.titleLab.mas_left).offset(-3);
    }];
}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}
- (void)setClickHighlighted:(BOOL)clickHighlighted{
    _clickHighlighted = clickHighlighted;
    self.bgImageView.highlighted = clickHighlighted;
}
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"hud_choice_nor" atDir:LGAlertBundle_Answer atBundle:LGAlertBundle()] highlightedImage:[UIImage yj_imageNamed:@"hud_choice_sel" atDir:LGAlertBundle_Answer atBundle:LGAlertBundle()]];
    }
    return _bgImageView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = LG_ColorWithHex(0x999999);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        if (LG_ScreenWidth < 375) {
            _titleLab.font = [UIFont systemFontOfSize:12];
        }else{
            _titleLab.font = [UIFont systemFontOfSize:14];
        }
        _titleLab.text = @"不再提示";
    }
    return _titleLab;
}
@end
