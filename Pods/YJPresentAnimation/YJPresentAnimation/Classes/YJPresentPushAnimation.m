//
//  YJPresentPushAnimation.m
//
//  Created by 刘亚军 on 2018/12/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJPresentPushAnimation.h"

@implementation YJPresentPushAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.4f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect fromVCRect = fromVC.view.frame;
    fromVCRect.origin.x = 0;
    fromVC.view.frame = fromVCRect;
    [container addSubview:toVC.view];
    
    CGRect toVCRect = toVC.view.frame;
    toVCRect.origin.x = screenWidth;
    toVC.view.frame = toVCRect;
    
    fromVCRect.origin.x = -screenWidth;
    toVCRect.origin.x = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.frame = fromVCRect;
        toVC.view.frame = toVCRect;
    } completion:^(BOOL finished){
        [fromVC.view removeFromSuperview];
        [transitionContext completeTransition:finished];//动画结束、取消必须调用
    }];
    
}

@end
