//
//  LGTBaseTextView.h
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGTConst.h"
typedef NS_ENUM(NSInteger, LGTBaseTextViewLimitType)
{
    LGTBaseTextViewLimitTypeDefault,      // 不限制
    LGTBaseTextViewLimitTypeNumber,      // 只允许输入数字
    LGTBaseTextViewLimitTypeDecimal,     //  只允许输入实数，包括.
    LGTBaseTextViewLimitTypeCharacter,  // 只允许非中文输入
    LGTBaseTextViewLimitTypeEmojiLimit  // 过滤表情
};
@class LGTBaseTextView;
@protocol LGTBaseTextViewDelegate <NSObject>
@optional
- (void)lgt_textViewShouldReturn:(nullable LGTBaseTextView *)textView;
- (BOOL)lgt_textViewShouldBeginEditing:(nullable LGTBaseTextView *)textView;
- (BOOL)lgt_textViewShouldEndEditing:(nullable LGTBaseTextView *)textView;

- (void)lgt_textViewDidBeginEditing:(nullable LGTBaseTextView *)textView;
- (void)lgt_textViewDidEndEditing:(nullable LGTBaseTextView *)textView;

- (BOOL)lgt_textView:(nullable LGTBaseTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(nullable NSString *)text;
- (void)lgt_textViewDidChange:(nullable LGTBaseTextView *)textView;

@end
@interface LGTBaseTextView : UITextView
@property(nullable, nonatomic,copy) IBInspectable NSString  *placeholder;
@property (nonatomic,assign) LGTBaseTextViewLimitType limitType;
@property (nonatomic,assign) NSInteger maxLength;
@property (nullable,nonatomic,weak) id<LGTBaseTextViewDelegate> lgtDelegate;

/** 移除辅助视图 */
- (void)deleteAccessoryView;
@end
