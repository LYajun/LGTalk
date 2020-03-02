//
//  YJSheetCell.m
//  LGAlertHUDDemo
//
//  Created by 刘亚军 on 2019/10/11.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJSheetCell.h"
#import <Masonry/Masonry.h>
#import <YJExtensions/YJExtensions.h>
@interface YJSheetCell ()
@property (nonatomic,strong) UILabel *titleLab;
@end
@implementation YJSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}
- (void)drawRect:(CGRect)rect{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, rect.size.height - 0.8, rect.size.width, 0.8)];
    [[UIColor yj_colorWithHex:0xcccccc] setFill];
    [bezierPath fillWithBlendMode:kCGBlendModeNormal alpha:1];
    [bezierPath closePath];
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = [UIColor yj_colorWithHex:0x444444];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}
@end
