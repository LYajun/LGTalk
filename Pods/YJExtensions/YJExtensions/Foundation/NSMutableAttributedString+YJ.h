//
//  NSMutableAttributedString+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (YJ)
- (void)yj_setColor:(UIColor *)color;
- (void)yj_setColor:(UIColor *)color atRange:(NSRange)range;

- (void)yj_setFont:(CGFloat)font;
- (void)yj_setFont:(CGFloat)font atRange:(NSRange)range;

- (void)yj_setBoldFont:(CGFloat)font;
- (void)yj_setBoldFont:(CGFloat)font atRange:(NSRange)range;

- (void)yj_setChineseForegroundColor:(UIColor *)color font:(CGFloat)font;
- (void)yj_setNumberForegroundColor:(UIColor *)color font:(CGFloat)font;
- (void)yj_setSubChar:(NSString *)subStr foregroundColor:(UIColor *)color font:(CGFloat)font;
- (void)yj_addParagraphLineSpacing:(CGFloat) lineSpacing;

+ (NSMutableAttributedString *)yj_AttributedStringByHtmls:(NSArray *)htmls colors:(NSArray *)colors fonts:(NSArray *)fonts;
@end

NS_ASSUME_NONNULL_END
