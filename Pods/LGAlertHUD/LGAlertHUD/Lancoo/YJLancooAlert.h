//
//  YJLancooAlert.h
//  LGAlertHUDDemo
//
//  Created by 刘亚军 on 2019/4/4.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJLancooAlert : UIView


+ (YJLancooAlert *)lancooAlertWithTitle:(NSString *)title
                                    msg:(NSString *)msg
                            cancelTitle:(NSString *)cancelTitle
                       destructiveTitle:(NSString *)destructiveTitle
                            cancelBlock:(void (^)(void))cancelBlock
                       destructiveBlock:(void (^)(void))destructiveBlock;

+ (YJLancooAlert *)lancooAlertWithTitle:(NSString *)title
                                    msg:(NSString *)msg
                              sureTitle:(NSString *)sureTitle
                              sureBlock:(void (^)(void))sureBlock;

+ (YJLancooAlert *)lancooAlertWithTitle:(NSString *)title
                                    msgAttr:(NSAttributedString *)msgAttr
                            cancelTitle:(NSString *)cancelTitle
                       destructiveTitle:(NSString *)destructiveTitle
                            cancelBlock:(void (^)(void))cancelBlock
                       destructiveBlock:(void (^)(void))destructiveBlock;
+ (YJLancooAlert *)lancooAlertWithTitle:(NSString *)title
                                msgAttr:(NSAttributedString *)msgAttr
                              alignment:(NSTextAlignment)alignment
                            cancelTitle:(NSString *)cancelTitle
                       destructiveTitle:(NSString *)destructiveTitle
                            cancelBlock:(void (^)(void))cancelBlock
                       destructiveBlock:(void (^)(void))destructiveBlock;

+ (YJLancooAlert *)lancooAlertWithTitle:(NSString *)title
                                msgAttr:(NSAttributedString *)msgAttr
                              sureTitle:(NSString *)sureTitle
                              sureBlock:(void (^)(void))sureBlock;

+ (YJLancooAlert *)lancooAlertGifViewWithGifName:(NSString *)gifName msg:(NSString *)msg duration:(NSInteger)duration;

- (void)show;
- (void)hide;
+ (void)dismiss;
@end

NS_ASSUME_NONNULL_END
