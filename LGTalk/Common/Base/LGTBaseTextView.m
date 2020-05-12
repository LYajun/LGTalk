//
//  LGTBaseTextView.m
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGTBaseTextView.h"
#import "NSString+LGT.h"
#import <LGAlertHUD/LGAlertHUD.h>



@interface LGTBaseTextView ()<UITextViewDelegate>
{
    UILabel *placeHolderLabel;
}
@property (nonatomic, strong) UIToolbar *customAccessoryView;
-(void)refreshPlaceholder;
@end
@implementation LGTBaseTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.inputAccessoryView = self.customAccessoryView;
        [self initialize];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.inputAccessoryView = self.customAccessoryView;
        [self initialize];
    }
    return self;
}
- (UIToolbar *)customAccessoryView{
    if (!_customAccessoryView) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _customAccessoryView = [[UIToolbar alloc]initWithFrame:(CGRect){0,0,width,40}];
        _customAccessoryView.barTintColor = [UIColor whiteColor];
        UIBarButtonItem *clear = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(clearAction)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *finish = [[UIBarButtonItem alloc]initWithTitle:@"收起" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        [_customAccessoryView setItems:@[clear,space,finish]];
        
    }
    return _customAccessoryView;
}
- (void)deleteAccessoryView{
    self.inputAccessoryView = nil;
}
- (void)clearAction{
    self.text = @"";
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}
- (void)done{
    [self resignFirstResponder];
}
-(void)initialize
{
    self.delegate = self;
    self.maxLength = NSUIntegerMax;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPlaceholder) name:UITextViewTextDidChangeNotification object:self];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)refreshPlaceholder
{
    if([[self text] length])
    {
        [placeHolderLabel setAlpha:0];
    }
    else
    {
        [placeHolderLabel setAlpha:1];
    }
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self refreshPlaceholder];
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    placeHolderLabel.font = self.font;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (LGT_IsStrEmpty(self.placeholder)) {
        self.placeholder = @"请输入...";
    }
    if ([self.placeholder containsString:@"("]) {
        placeHolderLabel.frame = CGRectMake(self.frame.size.width/2 - 10, 8, 60, 20);
    }
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    if ( placeHolderLabel == nil )
    {
        placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, [UIScreen mainScreen].bounds.size.width - 100, 20)];
//        placeHolderLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
//        placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.font = self.font;
        placeHolderLabel.backgroundColor = [UIColor clearColor];
        placeHolderLabel.textColor = LGT_ColorWithHex(0xC7C7CF);
        placeHolderLabel.alpha = 0;
        [self addSubview:placeHolderLabel];
    }
    
    placeHolderLabel.text = self.placeholder;
    [self refreshPlaceholder];
}
//When any text changes on textField, the delegate getter is called. At this time we refresh the textView's placeholder
-(id<UITextViewDelegate>)delegate
{
    [self refreshPlaceholder];
    return [super delegate];
}


#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.lgtDelegate && [self.lgtDelegate respondsToSelector:@selector(lgt_textViewShouldBeginEditing:)]) {
         [self.lgtDelegate lgt_textViewShouldBeginEditing:self];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (self.lgtDelegate && [self.lgtDelegate respondsToSelector:@selector(lgt_textViewShouldEndEditing:)]) {
        return [self.lgtDelegate lgt_textViewShouldEndEditing:self];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.lgtDelegate && [self.lgtDelegate respondsToSelector:@selector(lgt_textViewDidBeginEditing:)]) {
        [self.lgtDelegate lgt_textViewDidBeginEditing:self];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.lgtDelegate && [self.lgtDelegate respondsToSelector:@selector(lgt_textViewDidEndEditing:)]) {
        [self.lgtDelegate lgt_textViewDidEndEditing:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //如果用户点击了return
    if([text isEqualToString:@"\n"]){
        if (self.lgtDelegate && [self.lgtDelegate respondsToSelector:@selector(lgt_textViewShouldReturn:)]) {
            [self.lgtDelegate lgt_textViewShouldReturn:self];
            return NO;
        }
        return YES;
    }
    if (self.lgtDelegate && [self.lgtDelegate respondsToSelector:@selector(lgt_textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.lgtDelegate lgt_textView:self shouldChangeTextInRange:range replacementText:text];
    }
    if (LGT_IsStrEmpty(text)) {
        return YES;
    }
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        //如果有高亮且当前字数开始位置小于最大限制时允许输入
        if (offsetRange.location < self.maxLength) {
            if (self.lgtDelegate && [self.lgtDelegate respondsToSelector:@selector(lgt_textViewDidChange:)]) {
                [self.lgtDelegate lgt_textViewDidChange:self];
            }
            return [self isContainEmojiInRange:range replacementText:text];
        }else{
            return NO;
        }
    }else{
        return [self isContainEmojiInRange:range replacementText:text];
    }
}
- (BOOL)isContainEmojiInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *emojis = @"➋➌➍➎➏➐➑➒";
    if ([emojis containsString:text]) {
        return YES;
    }
    switch (self.limitType) {
        case LGTBaseTextViewLimitTypeDefault:
            return [self limitTypeDefaultInRange:range replacementText:text];
            break;
        case LGTBaseTextViewLimitTypeNumber:
            return [self limitTypeNumberInRange:range replacementText:text];
            break;
        case LGTBaseTextViewLimitTypeDecimal:
            return [self limitTypeDecimalInRange:range replacementText:text];
            break;
        case LGTBaseTextViewLimitTypeCharacter:
            return [self limitTypeCharacterInRange:range replacementText:text];
            break;
        case LGTBaseTextViewLimitTypeEmojiLimit:
            return [self limitTypeEmojiInRange:range replacementText:text];
            break;
        default:
            break;
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    if (self.lgtDelegate && [self.lgtDelegate respondsToSelector:@selector(lgt_textViewDidChange:)]) {
        [self.lgtDelegate lgt_textViewDidChange:self];
    }
}
#pragma mark LimitAction
- (BOOL)limitTypeDefaultInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self exceedLimitLengthInRange:range replacementText:text]) {
        return NO;
    }else{
        return YES;
    }
}
- (BOOL)limitTypeNumberInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self exceedLimitLengthInRange:range replacementText:text]) {
        return NO;
    }else{
        if ([self predicateMatchWithText:text matchFormat:@"^\\d$"]) {
            return YES;
        }
        return NO;
    }
}
- (BOOL)limitTypeDecimalInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self exceedLimitLengthInRange:range replacementText:text]) {
        return NO;
    }else{
        if ([self predicateMatchWithText:text matchFormat:@"^[0-9.]$"]) {
            return YES;
        }
        return NO;
    }
}
- (BOOL)limitTypeCharacterInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self exceedLimitLengthInRange:range replacementText:text]) {
        return NO;
    }else{
        if ([self predicateMatchWithText:text matchFormat:@"^[^[\\u4e00-\\u9fa5]]$"]) {
            return YES;
        }
        return NO;
    }
}
- (BOOL)limitTypeEmojiInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self exceedLimitLengthInRange:range replacementText:text]) {
        return NO;
    }else{
        //        if (![NSString stringContainsEmoji:text]) {
        //            return YES;
        //        }
        if (![text lgt_containsEmoji]) {
            return YES;
        }
        return NO;
    }
}
- (BOOL)exceedLimitLengthInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *str = [NSString stringWithFormat:@"%@%@", self.text, text];
    if (str.length > self.maxLength){
        
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
        if (rangeIndex.length == 1){//字数超限
            self.text = [str substringToIndex:self.maxLength];
            if (self.lgtDelegate && [self.lgtDelegate respondsToSelector:@selector(lgt_textViewDidChange:)]) {
                [self.lgtDelegate lgt_textViewDidChange:self];
            }
        }else{
            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
            self.text = [str substringWithRange:rangeRange];
        }
        [LGAlert showInfoWithStatus:@"字数已达限制"];
        return YES;
    }
    return NO;
}
- (NSString *)filterStringWithText:(NSString *) text matchFormat:(NSString *) matchFormat{
    NSMutableString * modifyString = text.mutableCopy;
    for (NSInteger idx = 0; idx < modifyString.length;) {
        NSString * subString = [modifyString substringWithRange: NSMakeRange(idx, 1)];
        if ([self predicateMatchWithText:subString matchFormat:matchFormat]) {
            idx++;
        } else {
            [modifyString deleteCharactersInRange: NSMakeRange(idx, 1)];
        }
    }
    return modifyString;
}
- (BOOL)predicateMatchWithText:(NSString *) text matchFormat:(NSString *) matchFormat{
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", matchFormat];
    return [predicate evaluateWithObject:text];
}

@end
