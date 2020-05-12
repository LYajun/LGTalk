//
//  UIButton+YJ.m
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "UIButton+YJ.h"
#import <objc/runtime.h>


@interface UIButton ()

@property(nonatomic, strong) UIView *yj_modalView;
@property(nonatomic, strong) UIActivityIndicatorView *yj_spinnerView;
@property(nonatomic, strong) UILabel *yj_spinnerTitleLabel;

@end
@implementation UIButton (YJ)
- (UIEdgeInsets)yj_touchAreaInsets{
    return [objc_getAssociatedObject(self, @selector(yj_touchAreaInsets)) UIEdgeInsetsValue];
}

- (void)setYj_touchAreaInsets:(UIEdgeInsets)touchAreaInsets{
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(yj_touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    UIEdgeInsets touchAreaInsets = self.yj_touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}

- (void)yj_setImagePosition:(YJImagePosition)postion spacing:(CGFloat)spacing{
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWith + labelWidth) / 2 - imageWith / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWith + labelWidth / 2) - (imageWith + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    switch (postion) {
        case YJImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
            
        case YJImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
            break;
            
        case YJImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            break;
            
        case YJImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            break;
            
        default:
            break;
    }
}

- (void)yj_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state{
    [self setBackgroundImage:[UIButton yj_b_imageWithColor:backgroundColor] forState:state];
}
+ (UIImage *)yj_b_imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 提交按钮
- (void)yj_beginSubmitting:(NSString *)title{
    [self yj_endSubmitting];
    
    self.yj_submitting = @YES;
    self.hidden = YES;
    
    self.yj_modalView = [[UIView alloc] initWithFrame:self.frame];
    self.yj_modalView.backgroundColor =
    [self.backgroundColor colorWithAlphaComponent:0.6];
    self.yj_modalView.layer.cornerRadius = self.layer.cornerRadius;
    self.yj_modalView.layer.borderWidth = self.layer.borderWidth;
    self.yj_modalView.layer.borderColor = self.layer.borderColor;
    
    CGRect viewBounds = self.yj_modalView.bounds;
    self.yj_spinnerView = [[UIActivityIndicatorView alloc]
                           initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.yj_spinnerView.tintColor = self.titleLabel.textColor;
    
    CGRect spinnerViewBounds = self.yj_spinnerView.bounds;
    self.yj_spinnerView.frame = CGRectMake(
                                           15, viewBounds.size.height / 2 - spinnerViewBounds.size.height / 2,
                                           spinnerViewBounds.size.width, spinnerViewBounds.size.height);
    self.yj_spinnerTitleLabel = [[UILabel alloc] initWithFrame:viewBounds];
    self.yj_spinnerTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.yj_spinnerTitleLabel.text = title;
    self.yj_spinnerTitleLabel.font = self.titleLabel.font;
    self.yj_spinnerTitleLabel.textColor = self.titleLabel.textColor;
    [self.yj_modalView addSubview:self.yj_spinnerView];
    [self.yj_modalView addSubview:self.yj_spinnerTitleLabel];
    [self.superview addSubview:self.yj_modalView];
    [self.yj_spinnerView startAnimating];
}
- (void)yj_endSubmitting{
    if (!self.yj_submitting.boolValue) {
        return;
    }
    
    self.yj_submitting = @NO;
    self.hidden = NO;
    
    [self.yj_modalView removeFromSuperview];
    self.yj_modalView = nil;
    self.yj_spinnerView = nil;
    self.yj_spinnerTitleLabel = nil;
}

- (void)setYj_submitting:(NSNumber * _Nonnull)submitting{
     objc_setAssociatedObject(self, @selector(setYj_submitting:), submitting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)yj_submitting{
      return objc_getAssociatedObject(self, @selector(setYj_submitting:));
}

- (UIActivityIndicatorView *)yj_spinnerView{
    return objc_getAssociatedObject(self, @selector(setYj_spinnerView:));
}

- (void)setYj_spinnerView:(UIActivityIndicatorView *)spinnerView{
     objc_setAssociatedObject(self, @selector(setYj_spinnerView:), spinnerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)yj_modalView{
    return objc_getAssociatedObject(self, @selector(setYj_modalView:));
}

- (void)setYj_modalView:(UIView *)modalView{
    objc_setAssociatedObject(self, @selector(setYj_modalView:), modalView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)yj_spinnerTitleLabel{
    return objc_getAssociatedObject(self, @selector(setYj_spinnerTitleLabel:));
}

- (void)setYj_spinnerTitleLabel:(UILabel *)spinnerTitleLabel{
    objc_setAssociatedObject(self, @selector(setYj_spinnerTitleLabel:), spinnerTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
