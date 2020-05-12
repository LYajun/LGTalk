//
//  UIView+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, YJShakeDirection) {
    YJShakeDirectionHorizontal = 0,
    YJShakeDirectionVertical
};
@interface UIView (YJ)

#pragma mark - 渐变色
@property(nullable, copy) NSArray *yjColors;
@property(nullable, copy) NSArray<NSNumber *> *yjLocations;
@property CGPoint yjStartPoint;
@property CGPoint yjEndPoint;

+ (UIView *_Nullable)yj_gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors
                                      locations:(NSArray<NSNumber *> *_Nullable)locations
                                     startPoint:(CGPoint)startPoint
                                       endPoint:(CGPoint)endPoint;

- (void)yj_setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors
                                  locations:(NSArray<NSNumber *> *_Nullable)locations
                                 startPoint:(CGPoint)startPoint
                                   endPoint:(CGPoint)endPoint;

#pragma mark - UIView处理
- (void)yj_clipLayerWithRadius:(CGFloat)r
                          width:(CGFloat)w
                          color:(nullable UIColor *)color;

- (void)yj_shadowWithWidth:(CGFloat)width
               borderColor:(UIColor *)borderColor
                   opacity:(CGFloat)opacity
                    radius:(CGFloat)radius
                    offset:(CGSize)offset;

- (void)yj_shadowWithBWidth:(CGFloat)bWidth bColor:(UIColor *)bColor sColor:(UIColor *)sColor cRadius:(CGFloat)cRadius sOpacity:(CGFloat)sOpacity sRadius:(CGFloat)sRadius sOffset:(CGSize)sOffset;

- (void)yj_shadowWithCornerRadius:(CGFloat)cRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor shadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowOffset:(CGSize)shadowOffset roundedRect:(CGRect)roundedRect cornerRadii:(CGSize)cornerRadii rectCorner:(UIRectCorner)rectCorner;
#pragma mark - Shake
- (void)yj_shake;
- (void)yj_shake:(int)times withDelta:(CGFloat)delta;
- (void)yj_shake:(int)times withDelta:(CGFloat)delta completion:(void((^)(void)))handler;
- (void)yj_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval;
- (void)yj_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void((^)(void)))handler;
- (void)yj_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(YJShakeDirection)shakeDirection;
- (void)yj_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(YJShakeDirection)shakeDirection completion:(void(^)(void))completion;

#pragma mark - Frame
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;


@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;

- (BOOL)yj_isIPAD;
- (BOOL)yj_isIPhoneX;
- (CGFloat)yj_stateBarSpace;
- (CGFloat)yj_tabBarSpace;
- (CGFloat)yj_customNavBarHeight;
- (CGFloat)yj_customTabBarHeight;
@end

NS_ASSUME_NONNULL_END
