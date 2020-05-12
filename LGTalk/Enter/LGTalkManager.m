//
//  LGTalkManager.m
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/6.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTalkManager.h"
#import "LGTBaseNavigationController.h"
#import "LGTMainViewController.h"
#import "LGTNetworking.h"
#import <YJPresentAnimation/YJPresentPushAnimation.h>
#import <YJPresentAnimation/YJPresentPopAnimation.h>

@interface LGTalkManager ()<UIViewControllerTransitioningDelegate>

@end
@implementation LGTalkManager
+ (LGTalkManager *)defaultManager{
    static LGTalkManager * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[LGTalkManager alloc]init];
        [macro initParams];
    });
    return macro;
}
- (void)initParams{
    [LGTNet netMonitoring];
}
- (void)resetParams{
    self.mutiFilterIndexPath = nil;
    self.traditionInfo = nil;
}
- (void)presentKnowledgeControllerBy:(UIViewController *)controller{
    LGTBaseNavigationController *navi;
    if (self.mutiFilterIndexPath) {
        LGTTraditionMainViewController *mainVC = [[LGTTraditionMainViewController alloc] init];
        navi = [[LGTBaseNavigationController alloc] initWithRootViewController:mainVC];
    }else{
        LGTMainViewController *mainVC = [[LGTMainViewController alloc] init];
       navi = [[LGTBaseNavigationController alloc] initWithRootViewController:mainVC];
    }
    navi.transitioningDelegate = self;
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [controller presentViewController:navi animated:YES completion:nil];
}
#pragma mark UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [YJPresentPushAnimation new];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [YJPresentPopAnimation new];
}

@end
