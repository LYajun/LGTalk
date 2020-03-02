//
//  YJVipControlView.h
//  LGAlertHUDDemo
//
//  Created by 刘亚军 on 2019/9/19.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJVipControlView : UIView
+ (YJVipControlView *)vipControlViewWithTitleStr:(NSString *)titleStr contentStr:(NSString *)contentStr btnTitleStr:(NSString *)btnTitleStr closeBlock:(nullable void (^) (void))closeBlock btnClickBlock:(nullable void (^) (void))btnClickBlock;
- (void)showOnView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
