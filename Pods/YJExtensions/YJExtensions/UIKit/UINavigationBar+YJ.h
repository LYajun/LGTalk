//
//  UINavigationBar+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/15.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (YJ)
- (void)yj_setBackgroundColor:(UIColor *)backgroundColor;
- (void)yj_setElementsAlpha:(CGFloat)alpha;
- (void)yj_setTranslationY:(CGFloat)translationY;
- (void)yj_reset;
@end

NS_ASSUME_NONNULL_END
