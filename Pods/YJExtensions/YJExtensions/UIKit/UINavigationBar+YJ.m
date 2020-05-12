//
//  UINavigationBar+YJ.m
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/15.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "UINavigationBar+YJ.h"
#import <objc/runtime.h>

@implementation UINavigationBar (YJ)
static char yj_overlayKey;

- (UIView *)yj_overlay{
    return objc_getAssociatedObject(self, &yj_overlayKey);
}

- (void)setYj_overlay:(UIView *)overlay{
    objc_setAssociatedObject(self, &yj_overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)yj_setBackgroundColor:(UIColor *)backgroundColor{
    if (!self.yj_overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.yj_overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        self.yj_overlay.userInteractionEnabled = NO;
        self.yj_overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.yj_overlay atIndex:0];
    }
    self.yj_overlay.backgroundColor = backgroundColor;
}

- (void)yj_setTranslationY:(CGFloat)translationY{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)yj_setElementsAlpha:(CGFloat)alpha{
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
    //    when viewController first load, the titleView maybe nil
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = alpha;
            *stop = YES;
        }
    }];
}

- (void)yj_reset{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.yj_overlay removeFromSuperview];
    self.yj_overlay = nil;
}

@end
