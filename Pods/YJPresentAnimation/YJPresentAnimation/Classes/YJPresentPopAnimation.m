//
//  YJPresentPopAnimation.m
//  Pods-YJPresentAnimation_Example
//
//  Created by 刘亚军 on 2019/7/9.
//

#import "YJPresentPopAnimation.h"

@implementation YJPresentPopAnimation
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect fromVCRect = fromVC.view.frame;
    fromVCRect.origin.x = 0;
    fromVC.view.frame = fromVCRect;
    
    [container addSubview:toVC.view];
    CGRect toVCRect = toVC.view.frame;
    toVCRect.origin.x = -screenWidth;
    toVC.view.frame = toVCRect;
    
    fromVCRect.origin.x = screenWidth;
    toVCRect.origin.x = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.frame = fromVCRect;
        toVC.view.frame = toVCRect;
    } completion:^(BOOL finished){
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];//动画结束、取消必须调用
    }];
}
@end
