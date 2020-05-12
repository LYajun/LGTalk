//
//  UIView+YJ.m
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "UIView+YJ.h"
#import <objc/runtime.h>


@implementation UIView (YJ)
#pragma mark - 渐变色
+ (Class)layerClass {
    return [CAGradientLayer class];
}
+ (UIView *)yj_gradientViewWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    UIView *view = [[self alloc] init];
    [view yj_setGradientBackgroundWithColors:colors locations:locations startPoint:startPoint endPoint:endPoint];
    return view;
}
- (void)yj_setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    NSMutableArray *colorsM = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorsM addObject:(__bridge id)color.CGColor];
    }
    self.yjColors = [colorsM copy];
    self.yjLocations = locations;
    self.yjStartPoint = startPoint;
    self.yjEndPoint = endPoint;
}
- (NSArray *)yjColors {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYjColors:(NSArray *)yjColors {
    objc_setAssociatedObject(self, @selector(yjColors), yjColors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setColors:self.yjColors];
    }
}

- (NSArray<NSNumber *> *)yjLocations {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYjLocations:(NSArray<NSNumber *> *)yjLocations {
    objc_setAssociatedObject(self, @selector(yjLocations), yjLocations, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setLocations:self.yjLocations];
    }
}

- (CGPoint)yjStartPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setYjStartPoint:(CGPoint)yjStartPoint {
    objc_setAssociatedObject(self, @selector(yjStartPoint), [NSValue valueWithCGPoint:yjStartPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setStartPoint:self.yjStartPoint];
    }
}

- (CGPoint)yjEndPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setYjEndPoint:(CGPoint)yjEndPoint {
    objc_setAssociatedObject(self, @selector(yjEndPoint), [NSValue valueWithCGPoint:yjEndPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setEndPoint:self.yjEndPoint];
    }
}
#pragma mark - UIView处理
- (void)yj_clipLayerWithRadius:(CGFloat)r width:(CGFloat)w color:(UIColor *)color{
    self.layer.cornerRadius = r;
    self.layer.borderWidth = w;
    self.layer.borderColor = color.CGColor;
    self.layer.masksToBounds = YES;
}

- (void)yj_shadowWithWidth:(CGFloat)width borderColor:(UIColor *)borderColor opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset{
    self.layer.borderWidth = width;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    self.layer.shadowOffset = offset;
}
- (void)yj_shadowWithBWidth:(CGFloat)bWidth bColor:(UIColor *)bColor sColor:(UIColor *)sColor cRadius:(CGFloat)cRadius sOpacity:(CGFloat)sOpacity sRadius:(CGFloat)sRadius sOffset:(CGSize)sOffset{
    self.layer.cornerRadius = cRadius;
    
    self.layer.borderWidth = bWidth;
    self.layer.borderColor = bColor.CGColor;
    
    self.layer.shadowColor = sColor.CGColor;
    self.layer.shadowOpacity = sOpacity;
    self.layer.shadowRadius = sRadius;
    self.layer.shadowOffset = sOffset;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = NO;
}
- (void)yj_shadowWithCornerRadius:(CGFloat)cRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor shadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowOffset:(CGSize)shadowOffset roundedRect:(CGRect)roundedRect cornerRadii:(CGSize)cornerRadii rectCorner:(UIRectCorner)rectCorner{
    self.layer.cornerRadius = cRadius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset =  shadowOffset;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:roundedRect byRoundingCorners:rectCorner cornerRadii:cornerRadii];
    self.layer.shadowPath = bezierPath.CGPath;
}
#pragma mark - Shake
- (void)yj_shake {
    [self _yj_shake:10 direction:1 currentTimes:0 withDelta:5 speed:0.03 shakeDirection:YJShakeDirectionHorizontal completion:nil];
}

- (void)yj_shake:(int)times withDelta:(CGFloat)delta {
    [self _yj_shake:times direction:1 currentTimes:0 withDelta:delta speed:0.03 shakeDirection:YJShakeDirectionHorizontal completion:nil];
}

- (void)yj_shake:(int)times withDelta:(CGFloat)delta completion:(void(^)(void))handler {
    [self _yj_shake:times direction:1 currentTimes:0 withDelta:delta speed:0.03 shakeDirection:YJShakeDirectionHorizontal completion:handler];
}

- (void)yj_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval {
    [self _yj_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:YJShakeDirectionHorizontal completion:nil];
}

- (void)yj_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void(^)(void))handler {
    [self _yj_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:YJShakeDirectionHorizontal completion:handler];
}

- (void)yj_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(YJShakeDirection)shakeDirection {
    [self _yj_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:shakeDirection completion:nil];
}

- (void)yj_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(YJShakeDirection)shakeDirection completion:(void (^)(void))completion {
    [self _yj_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:shakeDirection completion:completion];
}

- (void)_yj_shake:(int)times direction:(int)direction currentTimes:(int)current withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(YJShakeDirection)shakeDirection completion:(void (^)(void))completionHandler {
    [UIView animateWithDuration:interval animations:^{
        self.layer.affineTransform = (shakeDirection == YJShakeDirectionHorizontal) ? CGAffineTransformMakeTranslation(delta * direction, 0) : CGAffineTransformMakeTranslation(0, delta * direction);
    } completion:^(BOOL finished) {
        if(current >= times) {
            [UIView animateWithDuration:interval animations:^{
                self.layer.affineTransform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                if (completionHandler != nil) {
                    completionHandler();
                }
            }];
            return;
        }
        [self _yj_shake:(times - 1)
              direction:direction * -1
           currentTimes:current + 1
              withDelta:delta
                  speed:interval
         shakeDirection:shakeDirection
             completion:completionHandler];
    }];
}
#pragma mark - Frame
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}
- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (void)setTop:(CGFloat)t{
    self.frame = CGRectMake(self.left, t, self.width, self.height);
}

- (CGFloat)top{
    return self.frame.origin.y;
}

- (void)setBottom:(CGFloat)b{
    self.frame = CGRectMake(self.left, b - self.height, self.width, self.height);
}

- (CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLeft:(CGFloat)l{
    self.frame = CGRectMake(l, self.top, self.width, self.height);
}

- (CGFloat)left{
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)r{
    self.frame = CGRectMake(r - self.width, self.top, self.width, self.height);
}

- (CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}

- (BOOL)yj_isIPAD{
    BOOL isIpad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    return isIpad;
}

- (BOOL)yj_isIPhoneX{
    BOOL iPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneX;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    return iPhoneX;
}

- (CGFloat)yj_stateBarSpace{
     return ([self yj_isIPhoneX] ? 24 : 0);
}
- (CGFloat)yj_tabBarSpace{
    return ([self yj_isIPhoneX] ? 34 : 0);
}
- (CGFloat)yj_customNavBarHeight{
    return ([self yj_isIPhoneX] ? 88 : 64);
}
- (CGFloat)yj_customTabBarHeight{
    return ([self yj_isIPhoneX] ? 83 : 49);
}
@end


@implementation UILabel (YJ)

+ (Class)layerClass {
    return [CAGradientLayer class];
}

@end
