//
//  UIImageView+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/15.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (YJ)

#pragma mark - 倒角
- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

- (void)yj_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

- (instancetype)initWithRoundingRectImageView;

- (void)yj_cornerRadiusRoundingRect;

- (void)yj_attachBorderWidth:(CGFloat)width color:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
