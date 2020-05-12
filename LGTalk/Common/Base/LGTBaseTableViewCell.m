//
//  LGTBaseTableViewCell.m
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGTBaseTableViewCell.h"

@implementation LGTBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self defaultSetup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self defaultSetup];
    }
    return self;
}
- (void)defaultSetup{
    _isShowSeparator = NO;
    _separatorOffset = 0;
    _sepColor = LGT_ColorWithHex(0xE0E0E0);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)drawRect:(CGRect)rect{
    if (!_isShowSeparator) return;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(self.separatorOffset, rect.size.height - 0.8, rect.size.width-self.separatorOffset*2, 0.8)];
    [self.sepColor setFill];
    [bezierPath fillWithBlendMode:kCGBlendModeNormal alpha:1];
    [bezierPath closePath];
}
- (void)setSeparatorOffset:(CGFloat)separatorOffset{
    _separatorOffset = separatorOffset;
    [self setNeedsDisplay];
}
- (void)setSepColor:(UIColor *)sepColor{
    _sepColor = sepColor;
    [self setNeedsDisplay];
}
@end
