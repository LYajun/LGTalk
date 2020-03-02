//
//  YJCircleProgressView.h
//  YJCircleProgress
//
//  Created by YJniel Amitay on 2/6/12.
//  Copyright (c) 2012 YJniel Amitay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJCircleProgressView : UIView
/** 圆环颜色 */
@property(nonatomic, strong) UIColor *trackTintColor UI_APPEARANCE_SELECTOR;
/** 进度颜色 */
@property(nonatomic, strong) UIColor *progressTintColor UI_APPEARANCE_SELECTOR;
/** 圆环内部颜色 */
@property(nonatomic, strong) UIColor *innerTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic) NSInteger roundedCorners UI_APPEARANCE_SELECTOR; // Can not use BOOL with UI_APPEARANCE_SELECTOR :-(
/** 圆环粗细 0~1 */
@property(nonatomic) CGFloat thicknessRatio UI_APPEARANCE_SELECTOR;
/** 圆环进度值开始时间点 */
@property(nonatomic) NSInteger clockwiseProgress UI_APPEARANCE_SELECTOR; // Can not use BOOL with UI_APPEARANCE_SELECTOR :-(
@property(nonatomic) CGFloat progress;

@property(nonatomic) CGFloat indeterminateDuration UI_APPEARANCE_SELECTOR;
@property(nonatomic) NSInteger indeterminate UI_APPEARANCE_SELECTOR; // Can not use BOOL with UI_APPEARANCE_SELECTOR :-(

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated initialDelay:(CFTimeInterval)initialDelay;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated initialDelay:(CFTimeInterval)initialDelay withDuration:(CFTimeInterval)duration;

@end
