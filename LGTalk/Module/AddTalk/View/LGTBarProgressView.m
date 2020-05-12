//
//  BarProgressView.m
//  LGTWritting
//
//  Created by 刘亚军 on 16/7/25.
//  Copyright © 2016年 刘亚军. All rights reserved.
//

#import "LGTBarProgressView.h"
#import "LGTConst.h"

@implementation LGTBarProgressView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
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
    self.backgroundColor = [UIColor clearColor];
    _tintColor = [UIColor whiteColor];
    _bgColor = [UIColor orangeColor];
    _progress = 0;
}
- (void)drawRect:(CGRect)rect {
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;

    /* 进度 */
    UIBezierPath* bg_aPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, height) cornerRadius:height/2];
    if (self.progress > 0) {
        // 设置颜色
        [self.bgColor set];
    }else{
        [LGT_ColorWithHex(0xD9D9D9) set];
    }
    // 填充
    [bg_aPath fill];
    
    
    /* 进度 */
    UIBezierPath* aPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2, 1, (width-4)*self.progress, height-2) cornerRadius:height/2];
    // 设置颜色
    [self.tintColor set];
   
    // 填充
    [aPath fill];

}
- (void)setTintColor:(UIColor *)tintColor{
    _tintColor = tintColor;
    // 重绘
    [self setNeedsDisplay];
}
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    // 重绘
    [self setNeedsDisplay];
}
- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    [self setNeedsDisplay];
}
@end
