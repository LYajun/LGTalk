//
//  UIButton+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YJImagePosition) {
    YJImagePositionLeft = 0,              //图片在左，文字在右，默认
    YJImagePositionRight = 1,             //图片在右，文字在左
    YJImagePositionTop = 2,               //图片在上，文字在下
    YJImagePositionBottom = 3,            //图片在下，文字在上
};
@interface UIButton (YJ)
/** 设置按钮额外热区 */
@property (nonatomic, assign) UIEdgeInsets yj_touchAreaInsets;

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 */
- (void)yj_setImagePosition:(YJImagePosition)postion spacing:(CGFloat)spacing;

/** 使用颜色设置按钮背景 */
- (void)yj_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

#pragma mark - 提交按钮
/** 按钮是否正在提交中 */
@property(nonatomic, readonly) NSNumber *yj_submitting;
/** 按钮点击后，恢复按钮点击前的状态 */
- (void)yj_endSubmitting;
/** 按钮点击后，禁用按钮并在按钮上显示ActivityIndicator，以及title */
- (void)yj_beginSubmitting:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
