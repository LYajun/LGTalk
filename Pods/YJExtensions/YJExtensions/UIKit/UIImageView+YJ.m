//
//  UIImageView+YJ.m
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/15.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "UIImageView+YJ.h"
#import <objc/runtime.h>

const char kProcessedImage;

@interface UIImageView ()

@property (assign, nonatomic) CGFloat yjRadius;
@property (assign, nonatomic) UIRectCorner roundingCorners;
@property (assign, nonatomic) CGFloat yjBorderWidth;
@property (strong, nonatomic) UIColor *yjBorderColor;
@property (assign, nonatomic) BOOL yjHadAddObserver;
@property (assign, nonatomic) BOOL yjIsRounding;

@end
@implementation UIImageView (YJ)
#pragma mark - 倒角
- (instancetype)initWithRoundingRectImageView {
    self = [super init];
    if (self) {
        [self yj_cornerRadiusRoundingRect];
    }
    return self;
}

- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    self = [super init];
    if (self) {
        [self yj_cornerRadiusAdvance:cornerRadius rectCornerType:rectCornerType];
    }
    return self;
}

- (void)yj_attachBorderWidth:(CGFloat)width color:(UIColor *)color {
    self.yjBorderWidth = width;
    self.yjBorderColor = color;
}


- (void)yj_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    [self drawBorder:cornerPath];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (processedImage) {
        objc_setAssociatedObject(processedImage, &kProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.image = processedImage;
}


- (void)yj_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType backgroundColor:(UIColor *)backgroundColor {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    UIBezierPath *backgroundRect = [UIBezierPath bezierPathWithRect:self.bounds];
    [backgroundColor setFill];
    [backgroundRect fill];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    [self drawBorder:cornerPath];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (processedImage) {
        objc_setAssociatedObject(processedImage, &kProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.image = processedImage;
}

/**
 * @brief set cornerRadius for UIImageView, no off-screen-rendered
 */
- (void)yj_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    self.yjRadius = cornerRadius;
    self.roundingCorners = rectCornerType;
    self.yjIsRounding = NO;
    if (!self.yjHadAddObserver) {
        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.yjHadAddObserver = YES;
    }
    //Xcode 8 xib 删除了控件的Frame信息，需要主动创造
    [self layoutIfNeeded];
}

/**
 * @brief become Rounding UIImageView, no off-screen-rendered
 */
- (void)yj_cornerRadiusRoundingRect {
    self.yjIsRounding = YES;
    if (!self.yjHadAddObserver) {
        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.yjHadAddObserver = YES;
    }
    //Xcode 8 xib 删除了控件的Frame信息，需要主动创造
    [self layoutIfNeeded];
}

#pragma mark - Private
- (void)drawBorder:(UIBezierPath *)path {
    if (0 != self.yjBorderWidth && nil != self.yjBorderColor) {
        [path setLineWidth:2 * self.yjBorderWidth];
        [self.yjBorderColor setStroke];
        [path stroke];
    }
}

- (void)yj_dealloc {
    if (self.yjHadAddObserver) {
        [self removeObserver:self forKeyPath:@"image"];
    }
    [self yj_dealloc];
}

- (void)validateFrame {
    if (self.frame.size.width == 0) {
        [self.class swizzleLayoutSubviews];
    }
}

+ (void)swizzleMethod:(SEL)oneSel anotherMethod:(SEL)anotherSel {
    Method oneMethod = class_getInstanceMethod(self, oneSel);
    Method anotherMethod = class_getInstanceMethod(self, anotherSel);
    method_exchangeImplementations(oneMethod, anotherMethod);
}

+ (void)swizzleDealloc {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:NSSelectorFromString(@"dealloc") anotherMethod:@selector(yj_dealloc)];
    });
}

+ (void)swizzleLayoutSubviews {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(layoutSubviews) anotherMethod:@selector(yj_LayoutSubviews)];
    });
}

- (void)yj_LayoutSubviews {
    [self yj_LayoutSubviews];
    if (self.yjIsRounding) {
        [self yj_cornerRadiusWithImage:self.image cornerRadius:self.frame.size.width/2 rectCornerType:UIRectCornerAllCorners];
    } else if (0 != self.yjRadius && 0 != self.roundingCorners && nil != self.image) {
        [self yj_cornerRadiusWithImage:self.image cornerRadius:self.yjRadius rectCornerType:self.roundingCorners];
    }
}

#pragma mark - KVO for .image
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *newImage = change[NSKeyValueChangeNewKey];
        if ([newImage isMemberOfClass:[NSNull class]]) {
            return;
        } else if ([objc_getAssociatedObject(newImage, &kProcessedImage) intValue] == 1) {
            return;
        }
        [self validateFrame];
        if (self.yjIsRounding) {
            [self yj_cornerRadiusWithImage:newImage cornerRadius:self.frame.size.width/2 rectCornerType:UIRectCornerAllCorners];
        } else if (0 != self.yjRadius && 0 != self.roundingCorners && nil != self.image) {
            [self yj_cornerRadiusWithImage:newImage cornerRadius:self.yjRadius rectCornerType:self.roundingCorners];
        }
    }
}

#pragma mark property
- (CGFloat)yjBorderWidth {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setYjBorderWidth:(CGFloat)yjBorderWidth {
    objc_setAssociatedObject(self, @selector(yjBorderWidth), @(yjBorderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)yjBorderColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYjBorderColor:(UIColor *)yjBorderColor {
    objc_setAssociatedObject(self, @selector(yjBorderColor), yjBorderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yjHadAddObserver {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setYjHadAddObserver:(BOOL)yjHadAddObserver {
    objc_setAssociatedObject(self, @selector(yjHadAddObserver), @(yjHadAddObserver), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yjIsRounding {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setYjIsRounding:(BOOL)yjIsRounding {
    objc_setAssociatedObject(self, @selector(yjIsRounding), @(yjIsRounding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIRectCorner)roundingCorners {
    return [objc_getAssociatedObject(self, _cmd) unsignedLongValue];
}

- (void)setRoundingCorners:(UIRectCorner)roundingCorners {
    objc_setAssociatedObject(self, @selector(roundingCorners), @(roundingCorners), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)yjRadius {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setYjRadius:(CGFloat)yjRadius {
    objc_setAssociatedObject(self, @selector(yjRadius), @(yjRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
