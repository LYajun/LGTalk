//
//  YJSheetHeaderView.m
//  LGAlertHUDDemo
//
//  Created by 刘亚军 on 2019/10/11.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJSheetHeaderView.h"
#import <Masonry/Masonry.h>
#import <YJExtensions/YJExtensions.h>

@interface YJSheetHeaderView ()
@property (nonatomic,strong) UILabel *titleLab;
@end
@implementation YJSheetHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor yj_colorWithHex:0xcccccc];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.left.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.8);
        }];
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _titleLab.textColor = [UIColor yj_colorWithHex:0x222222];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}
@end
