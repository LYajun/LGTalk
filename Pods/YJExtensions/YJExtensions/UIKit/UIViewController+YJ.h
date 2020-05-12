//
//  UIViewController+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^YJBackButtonHandler)(UIViewController *vc);
@interface UIViewController (YJ)
-(void)yj_backButtonTouched:(YJBackButtonHandler)backButtonHandler;

+ (UIViewController *)yj_topControllerForController:(UIViewController *)controller;
- (void)yj_popViewControllerByName:(NSString *)viewControllerName;
- (void)yj_dismissToRootController;
@end

NS_ASSUME_NONNULL_END
