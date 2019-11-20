//
//  LGTChatBox.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/11/1.
//  Copyright © 2017年 lange. All rights reserved.
//

#import "LGTChatBox.h"
#import "LGTBaseTextView.h"
#import "LGTExtension.h"

#define HEIGHT_TEXTVIEW      30
#define SPAES_TEXTVIEW       (HEIGHT_TABBAR-HEIGHT_TEXTVIEW)/2
@interface LGTChatBox ()<LGTBaseTextViewDelegate>
{
    CGFloat keyboardY;
}
@property(nonatomic,strong)LGTBaseTextView *textView;
@end
@implementation LGTChatBox
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = LGT_ColorWithHex(0xF4F4F4);
        [self lgt_makeInsetShadowWithRadius:1 Color:LGT_ColorWithHex(0xF0F8FF) Directions:@[@"top"]];
        [self layoutUI];
        [self addNotification];
    }
    return self;
}
- (void)layoutUI{

    [self addSubview:self.textView];
    [self.textView deleteAccessoryView];
    [self.textView becomeFirstResponder];
}

- (void)changeFrame:(CGFloat)height{
    CGFloat maxH = 0;
    if (self.maxVisibleLine) {
        maxH = ceil(self.textView.font.lineHeight * (self.maxVisibleLine - 1) + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom);
    }
    self.textView.scrollEnabled = height >maxH && maxH >0;
    if (self.textView.scrollEnabled) {
        height = 5+maxH;
    }
    CGFloat totalH = height + SPAES_TEXTVIEW *2;
    self.y = keyboardY - totalH - self.contentOffsetHeight;
    self.height = totalH;
    self.textView.y = SPAES_TEXTVIEW;
    self.textView.height = height;
    if (self.delegate && [self.delegate respondsToSelector:@selector(LGTChatBox:didChangeOffsetY:)]) {
        [self.delegate LGTChatBox:self didChangeOffsetY:self.y];
    }
    [self.textView scrollRangeToVisible:NSMakeRange(0, self.textView.text.length)];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)setPlacehold:(NSString *)placehold{
    _placehold = placehold;
    self.textView.placeholder = placehold;
}
- (void)sendAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LGTChatBox:didClickSend:)]) {
        NSString *html = self.textView.text;
        [self.delegate LGTChatBox:self didClickSend:html];
    }
}
#pragma mark UITextViewDelegate
- (void)lgt_textViewShouldReturn:(LGTBaseTextView *)textView{
     NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!LGT_IsStrEmpty(text)) {
        [self sendAction];
    }
}
- (void)lgt_textViewDidBeginEditing:(LGTBaseTextView *)textView{
    [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
}
-(void)lgt_textViewDidChange:(LGTBaseTextView *)textView{
    [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
}
#pragma mark NSNotification
-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardY = keyboardF.origin.y;
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        self.y = keyboardF.origin.y - self.height - self.contentOffsetHeight;
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(LGTChatBox:didChangeOffsetY:)]) {
        [self.delegate LGTChatBox:self didChangeOffsetY:self.y];
    }
}
- (CGFloat)contentOffsetHeight{
    return LGT_ScreenHeight - self.superview.height;
}
-(void)keyboardDidChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.y = keyboardF.origin.y - self.height - self.contentOffsetHeight;
}
-(void)keyboardWillHide:(NSNotification *)notification{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LGTChatBoxDidRemoved)]) {
        [self.delegate LGTChatBoxDidRemoved];
    }
}

#pragma Property init
- (LGTBaseTextView *)textView{
    if (!_textView) {
        CGFloat w = LGT_ScreenWidth - 20;
        CGFloat h = HEIGHT_TEXTVIEW;
        CGFloat x = 10;
        CGFloat y = (HEIGHT_TABBAR-h)/2;
        _textView = [[LGTBaseTextView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
        _textView.placeholder = @"回复:";
        _textView.maxLength = 300;
        _textView.limitType = LGTBaseTextViewLimitTypeEmojiLimit;
        [_textView lgt_clipLayerWithRadius:4 width:0.5 color:LGT_ColorWithHex(0xEDEDED)];
        _textView.lgtDelegate = self;
    }
    return _textView;
}

@end
