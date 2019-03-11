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
#import "LGTPresentPushAnimation.h"

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
- (void)presentKnowledgeControllerBy:(UIViewController *)controller{
    LGTMainViewController *mainVC = [[LGTMainViewController alloc] init];
    LGTBaseNavigationController *navi = [[LGTBaseNavigationController alloc] initWithRootViewController:mainVC];
    navi.transitioningDelegate = self;
    [controller presentViewController:navi animated:YES completion:nil];
}
#pragma mark UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    LGTPresentPushAnimation* leftPresentAnimation = [[LGTPresentPushAnimation alloc] init];
    leftPresentAnimation.isPresent = YES;
    return leftPresentAnimation;
}

@end
