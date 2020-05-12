//
//  UIWindow+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (YJ)
/** present */
- (UIViewController*)yj_topMostController;
/** push */
- (UIViewController*)yj_currentViewController;
@end

NS_ASSUME_NONNULL_END
