//
//  NSMutableAttributedString+LGT.h
//
//
//  Created by 刘亚军 on 2018/11/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (LGT)
- (void)lgt_setColor:(UIColor *)color;
- (void)lgt_setColor:(UIColor *)color atRange:(NSRange)range;

- (void)lgt_setFont:(CGFloat)font;
- (void)lgt_setFont:(CGFloat)font atRange:(NSRange)range;

- (void)lgt_setBoldFont:(CGFloat)font;
- (void)lgt_setBoldFont:(CGFloat)font atRange:(NSRange)range;
- (void)lgt_addParagraphLineSpacing:(CGFloat)lineSpacing;
- (void)lgt_setChineseForegroundColor:(UIColor *)color font:(CGFloat)font;
+ (NSMutableAttributedString *)lgt_AttributedStringByHtmls:(NSArray *)htmls colors:(NSArray *)colors fonts:(NSArray *)fonts;
@end
