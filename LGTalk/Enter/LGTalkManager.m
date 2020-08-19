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
#import <LGBundle/LGBundleManager.h>
@interface LGTalkManager ()<UIViewControllerTransitioningDelegate>
@property (nonatomic,strong) NSArray *loadingImgs;
@property (nonatomic,strong) NSBundle *lgBundle;
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
   _lgBundle = [LGBundleManager defaultManager].bundle;
   _loadingImgs = [LGBundleManager defaultManager].loadingImgs;
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
- (BOOL)mutimediaNewApi{
//    if ([self.systemID isEqualToString:@"930"] &&
//        !LGT_IsStrEmpty(self.talkServiceVersion) &&
//        self.talkServiceVersion.integerValue >= 20200511 &&
//        !LGT_IsArrEmpty(self.talkClassIDArr1) &&
//        !LGT_IsArrEmpty(self.talkTchIDArr1) &&
//        !LGT_IsArrEmpty(self.talkClassIDArr2) &&
//        !LGT_IsArrEmpty(self.talkTchIDArr2)) {
//        return YES;
//    }
    if ([self.systemID isEqualToString:@"930"]) {
        return YES;
    }
    return NO;
}
#pragma mark UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [YJPresentPushAnimation new];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [YJPresentPopAnimation new];
}

@end
