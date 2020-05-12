//
//  UIColor+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/18.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (YJ)

+ (UIColor *)yj_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

+ (UIColor *)yj_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)yj_colorwithHexString:(NSString *)color;

+ (UIColor*)yj_colorWithHex:(NSInteger)hexValue;

+ (UIColor*)yj_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
@end

NS_ASSUME_NONNULL_END
