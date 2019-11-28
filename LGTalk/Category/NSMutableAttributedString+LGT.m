//
//  NSMutableAttributedString+LGT.m
//
//
//  Created by 刘亚军 on 2018/11/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "NSMutableAttributedString+LGT.h"

@implementation NSMutableAttributedString (LGT)
- (void)lgt_setColor:(UIColor *)color{
    [self lgt_setColor:color atRange:NSMakeRange(0, self.length)];
}
- (void)lgt_setColor:(UIColor *)color atRange:(NSRange)range{
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}
- (void)lgt_setFont:(CGFloat)font{
    [self lgt_setFont:font atRange:NSMakeRange(0, self.length)];
}
- (void)lgt_setBoldFont:(CGFloat)font{
    [self lgt_setBoldFont:font atRange:NSMakeRange(0, self.length)];
}
- (void)lgt_addParagraphLineSpacing:(CGFloat)lineSpacing{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
}
- (void)lgt_setBoldFont:(CGFloat)font atRange:(NSRange)range{
    [self addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font] range:range];
}
- (void)lgt_setFont:(CGFloat)font atRange:(NSRange)range{
    [self addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
}
- (void)lgt_setChineseForegroundColor:(UIColor *)color font:(CGFloat)font{
    for (int i=0; i<self.string.length; i++) {
        unichar ch = [self.string characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(i, 1)];
            [self addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(i, 1)];
        }
    }
}
+ (NSMutableAttributedString *)lgt_AttributedStringByHtmls:(NSArray *)htmls colors:(NSArray *)colors fonts:(NSArray *)fonts{
    NSMutableArray *atts = [NSMutableArray array];
    for (int i = 0; i < htmls.count; i++) {
        NSString *html = htmls[i];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:html];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[fonts[i] integerValue]]range:NSMakeRange(0,attrStr.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:colors[i] range:NSMakeRange(0,attrStr.length)];
        [atts addObject:attrStr];
    }
    NSMutableAttributedString *att = [atts firstObject];
    for (int i = 1; i < atts.count; i++) {
        NSMutableAttributedString *att1 = atts[i];
        [att appendAttributedString:att1];
    }
    return att;
}
@end
