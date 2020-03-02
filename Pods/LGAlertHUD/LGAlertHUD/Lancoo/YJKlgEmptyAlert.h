//
//  YJKlgEmptyAlert.h
//  LGAlertHUDDemo
//
//  Created by 刘亚军 on 2019/9/2.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJKlgEmptyAlert : UIView
+ (YJKlgEmptyAlert *)klgEmptyAlertWithText:(NSString *)text;

- (void)show;
@end

NS_ASSUME_NONNULL_END
