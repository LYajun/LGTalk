//
//  YJAnswerAlertView.h
//  YJAnswernowledgeFramework
//
//  Created by 刘亚军 on 2018/11/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJAnswerAlertView : UIView
/** 消息内容 */
@property (nonatomic,copy) NSString *normalMsg;

@property (nonatomic,assign) NSInteger timeCount;
+ (YJAnswerAlertView *)alertWithTimeCount:(NSInteger)timeCount;
+ (YJAnswerAlertView *)alertWithControllerName:(NSString *)controllerName hideBlock:(void (^) (void))hideBlock;
+ (YJAnswerAlertView *)alertWithTitle:(NSString *)title
             normalMsg:(NSString *)normalMsg
          highLightMsg:(NSString *)highLightMsg
           cancelTitle:(NSString *) cancelTitle
      destructiveTitle:(NSString *) destructiveTitle
           choiceTitle:(NSString *) choiceTitle
           cancelBlock:(void (^)(void)) cancelBlock
      destructiveBlock:(void (^)(void)) destructiveBlock
           choiceBlock:(void (^)(BOOL isChoice)) choiceBlock;

+ (YJAnswerAlertView *)alertWithTitle:(NSString *)title
             normalMsg:(NSString *)normalMsg
          highLightMsg:(NSString *)highLightMsg
           cancelTitle:(NSString *) cancelTitle
      destructiveTitle:(NSString *) destructiveTitle
           cancelBlock:(void (^)(void)) cancelBlock
      destructiveBlock:(void (^)(void)) destructiveBlock;

+ (YJAnswerAlertView *)alertWithTitle:(NSString *)title
             normalMsg:(NSString *)normalMsg
          highLightMsg:(NSString *)highLightMsg
      destructiveTitle:(NSString *) destructiveTitle
      destructiveBlock:(void (^)(void)) destructiveBlock;
- (void)show;
- (void)hide;
+ (void)dismiss;
@end
