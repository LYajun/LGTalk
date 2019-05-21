//
//  UIView+LGT.h
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LGT)
/** 渐变色 */
@property(nullable, copy) NSArray *colors;
@property(nullable, copy) NSArray<NSNumber *> *locations;
@property CGPoint startPoint;
@property CGPoint endPoint;
+ (UIView *_Nullable)lgt_gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors
                                      locations:(NSArray<NSNumber *> *_Nullable)locations
                                     startPoint:(CGPoint)startPoint
                                       endPoint:(CGPoint)endPoint;

- (void)lgt_setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors
                                  locations:(NSArray<NSNumber *> *_Nullable)locations
                                 startPoint:(CGPoint)startPoint
                                   endPoint:(CGPoint)endPoint;

/** 倒角 */
- (void)lgt_clipLayerWithRadius:(CGFloat)r
                          width:(CGFloat)w
                          color:(UIColor *)color;
- (void)lgt_shadowWithWidth:(CGFloat)width borderColor:(UIColor *)borderColor opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset;
- (void)lgt_makeInsetShadow;
- (void)lgt_makeInsetShadowWithRadius:(float)radius Alpha:(float)alpha;
- (void)lgt_makeInsetShadowWithRadius:(float)radius Color:(UIColor *)color Directions:(NSArray *)directions;
- (UIView *)lgt_createShadowViewWithRadius:(float)radius Color:(UIColor *)color Directions:(NSArray *)directions;

#pragma mark - Frame
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@end
