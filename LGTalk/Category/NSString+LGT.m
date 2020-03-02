//
//  NSString+LGT.m
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "NSString+LGT.h"
#import "LGTConst.h"

#import <YJExtensions/YJEHpple.h>


@implementation NSString (LGT)
- (NSString *)lgt_fileExtensionName{
    if (LGT_IsStrEmpty(self)) {
        return @"";
    }else{
        return [self componentsSeparatedByString:@"."].lastObject;
    }
}
- (NSString *)lgt_deleteWhitespaceCharacter{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
- (NSString *)lgt_deleteWhitespaceAndNewlineCharacter{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
+ (NSString *)lgt_stringToSmallTopicIndexStringWithIntCount:(NSInteger)intCount{
    NSDictionary *dic = @{
                          @"0":@"①",
                          @"1":@"②",
                          @"2":@"③",
                          @"3":@"④",
                          @"4":@"⑤",
                          @"5":@"⑥",
                          @"6":@"⑦",
                          @"7":@"⑧",
                          @"8":@"⑨",
                          @"9":@"⑩",
                          @"10":@"⑪",
                          @"11":@"⑫",
                          @"12":@"⑬",
                          @"13":@"⑭",
                          @"14":@"⑮",
                          @"15":@"⑯"
                          };
    NSArray *allKeys = [dic allKeys];
    NSString *key = [NSString stringWithFormat:@"%li",intCount];
    if (![allKeys containsObject:key]) {
        return @"-";
    }
    return [dic objectForKey:key];
}
+ (NSString *)LGT_Char1{
    return [NSString stringWithFormat:@"%c",1];
}
+ (NSString *)LGT_StandardAnswerSeparatedStr{
    return @"$、 ";
}
/*65-A*/
+ (NSString *)lgt_stringToASCIIStringWithIntCount:(NSInteger)intCount{
    return [NSString stringWithFormat:@"%c",(int)intCount];
}
/*A-65*/
- (NSInteger)lgt_stringToASCIIInt{
    if (LGT_IsStrEmpty(self)) {
        return -1;
    }
    return [self characterAtIndex:0];
}
+ (NSString *)lgt_HTML:(NSString *)html{
    NSScanner *theScaner = [NSScanner scannerWithString:html];
    NSDictionary *dict = @{@"<":@"&lt;", @">":@"&gt;"};
    while ([theScaner isAtEnd] == NO) {
        for (int i = 0; i <[dict allKeys].count; i ++) {
            [theScaner scanUpToString:[dict allKeys][i] intoString:NULL];
            html = [html stringByReplacingOccurrencesOfString:[dict allKeys][i] withString:[dict allValues][i]];
        }
    }
    return html;
}
- (NSMutableAttributedString *)lgt_toMutableAttributedString{
     return [[NSMutableAttributedString alloc] initWithString:self];
}
- (NSMutableAttributedString *)lgt_toHtmlMutableAttributedString{
    NSData *htmlData = [self dataUsingEncoding:NSUnicodeStringEncoding];
    return [[NSMutableAttributedString alloc] initWithData:htmlData options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
}
- (NSString *)lgt_appendFontAttibuteWithSize:(CGFloat)size{
    return [NSString stringWithFormat:@"<font size=\"%f\">%@</font>",size,self];
}
- (NSString *)lgt_replaceStrongWithFontAtTextColorHex:(NSString *)textColorHex{
    NSString *str = self;
    if (LGT_IsStrEmpty(str) || ![str containsString:@"<strong>"]) {
        return str;
    }
    str = [str stringByReplacingOccurrencesOfString:@"<strong>" withString:[NSString stringWithFormat:@"<font color=\"%@\">",textColorHex]];
    str = [str stringByReplacingOccurrencesOfString:@"</strong>" withString:@"</font>"];
    return str;
}
- (NSArray *)lgt_splitToCharacters{
    if (LGT_IsStrEmpty(self)) {
        return @[];
    }
    NSInteger length = [self length];
    NSInteger len = 0;
    NSMutableArray *arr = [NSMutableArray array];
    while (len < length) {
        [arr addObject:[NSString stringWithFormat:@"%c",[self characterAtIndex:len]]];
        len++;
    }
    return arr;
}
- (NSString *)lgt_htmlImgFrameAdjust{
    __block NSString *html = self.copy;
    if (LGT_IsStrEmpty(html)) {
        return html;
    }
    NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    // 解析html数据
    YJEHpple *xpathParser = [[YJEHpple alloc] initWithHTMLData:htmlData];
    // 根据标签来进行过滤
    NSArray *imgArray = [xpathParser searchWithXPathQuery:@"//img"];
    
    if (!LGT_IsArrEmpty(imgArray)) {
        [imgArray enumerateObjectsUsingBlock:^(YJEHppleElement *hppleElement, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *attributes = hppleElement.attributes;
            NSString *src = attributes[@"src"];
            NSString *srcSuf = [src componentsSeparatedByString:@"."].lastObject;
            if (srcSuf && [srcSuf.lowercaseString containsString:@"gif"]) {
                // gif 自适应
            }else{
                html = [NSString stringWithFormat:@"<html><head><style>img{max-width:%.f;height:auto !important;width:auto !important;};</style></head><body style='margin:0; padding:0;'>%@</body></html>",LGT_ScreenWidth-30, html];
            }
        }];
    }
    return html;
}
- (CGFloat)lgt_widthWithFont:(UIFont *)font{
    CGSize stringSize = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return ceil(stringSize.width);
}
- (CGFloat)lgt_heightWithFont:(UIFont *)font{
    CGSize stringSize = [self boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return ceil(stringSize.height);
}
#pragma mark - 时间
+ (NSString *)lgt_displayTimeWithCurrentTime:(NSString *)currentTime referTime:(NSString *)referTime{
    NSDate *currentDate = currentTime.lgt_date;
    NSDate *referDate = referTime.lgt_date;
    NSTimeInterval intervalEnd = [currentDate timeIntervalSinceDate:referDate];
    NSString *displayTime;
    if (intervalEnd > 24*60*60) {
        displayTime = [NSString stringWithFormat:@"%@",referTime.lgt_shortDateTimeString];
    }else{
        NSInteger nowDay = [currentTime.lgt_shortDateString componentsSeparatedByString:@"-"].lastObject.integerValue;
        NSInteger creaDay = [referTime.lgt_shortDateString componentsSeparatedByString:@"-"].lastObject.integerValue;
        if (nowDay == creaDay) {
            displayTime = [NSString stringWithFormat:@"今天: %@",referTime.lgt_shortTimeString];
        }else{
            displayTime = [NSString stringWithFormat:@"昨天: %@",referTime.lgt_shortTimeString];
        }
    }
    return displayTime;
}
- (NSDate *)lgt_dateWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:self];
    return date;
}

- (NSDate *)lgt_date {
    NSString *zelf = [self copy];
    if ([zelf containsString:@"T"]) {
        zelf = [zelf stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    }else if ([zelf containsString:@"/"]){
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateformatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSDate *date = [dateformatter dateFromString:zelf];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        zelf = [dateformatter stringFromDate:date];
        //        time = [time stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    }
    if (zelf.length > 19) {
        zelf = [zelf substringToIndex:19];
    }else if (zelf.length == 16){
        zelf = [zelf stringByAppendingString:@":00"];
    }else if (zelf.length == 13){
        zelf = [zelf stringByAppendingString:@":00:00"];
    }
    return [zelf lgt_dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)lgt_dateStringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self.lgt_date];
}
- (NSString *)lgt_yearString{
    return [self lgt_dateStringWithFormat:@"yyyy"];
}
- (NSString *)lgt_dateString {
    return [self lgt_dateStringWithFormat:@"yyyy-MM-dd"];
}

- (NSString *)lgt_shortDateString {
    return [self lgt_dateStringWithFormat:@"MM-dd"];
}
- (NSString *)lgt_shortTimeString {
    return [self lgt_dateStringWithFormat:@"HH:mm"];
}
- (NSString *)lgt_shortDateTimeString {
    return [self lgt_dateStringWithFormat:@"MM-dd HH:mm"];
}
- (NSString *)lgt_longDateTimeString {
    return [self lgt_dateStringWithFormat:@"yyyy-MM-dd HH:mm"];
}
- (NSString *)lgt_absoluteDateTimeString {
    return [self lgt_dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}
+ (NSString *)lgt_timeFromTimeInterval:(NSTimeInterval)timeInterval isShowChinese:(BOOL)isShowChinese isRetainMinuter:(BOOL)isRetainMinuter{
    if (timeInterval < 60) {
        NSInteger second = timeInterval;
        if (isShowChinese) {
            if (isRetainMinuter) {
                return [NSString stringWithFormat:@"00:%02li秒",second];
            }else{
                return [NSString stringWithFormat:@"%02li秒",second];
            }
        }else{
            if (isRetainMinuter) {
                return [NSString stringWithFormat:@"00:%02li",second];
            }else{
                return [NSString stringWithFormat:@"%02li",second];
            }
        }
    }if (timeInterval < 60*60) {
        NSInteger minute = (NSInteger)timeInterval % (60*60) / 60;
        NSInteger second = (NSInteger)timeInterval % (60*60) % 60;
        if (isShowChinese) {
            return [NSString stringWithFormat:@"%li分%02li秒",minute,second];
        }else{
            return [NSString stringWithFormat:@"%02li:%02li",minute,second];
        }
    }else if (timeInterval < 24*60*60){
        NSInteger hour = (NSInteger)timeInterval / (60*60);
        NSInteger minute = (NSInteger)timeInterval % (60*60) / 60;
        NSInteger second = (NSInteger)timeInterval % (60*60) % 60;
        if (isShowChinese) {
            return [NSString stringWithFormat:@"%li时%li分%02li秒",hour,minute,second];
        }else{
            return [NSString stringWithFormat:@"%02li:%02li:%02li",hour,minute,second];
        }
    }else{
        NSInteger day = (NSInteger)timeInterval / (24*60*60);
        NSInteger hour = (NSInteger)timeInterval % (24*60*60) / (60*60);
        NSInteger minute = (NSInteger)timeInterval % (24*60*60) % (60*60) / 60;
        NSInteger second = (NSInteger)timeInterval % (24*60*60) % (60*60) % 60;
        if (isShowChinese) {
            return [NSString stringWithFormat:@"%li天%li时%li分%02li秒",day,hour,minute,second];
        }else{
            return [NSString stringWithFormat:@"%02li:%02li:%02li:%02li",day,hour,minute,second];
        }
    }
}
#pragma mark - 限制表情
- (NSArray *)lgt_emojiRanges
{
    __block NSMutableArray *emojiRangesArray = [NSMutableArray new];
    
    [self enumerateSubstringsInRange:NSMakeRange(0,
                                                 [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring,
                                       NSRange substringRange,
                                       NSRange enclosingRange,
                                       BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs &&
             hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc &&
                     uc <= 0x1f9c0)
                 {
                     [emojiRangesArray addObject:[NSValue valueWithRange:substringRange]];
                 }
             }
         }
         else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3 ||
                 ls == 0xfe0f ||
                 ls == 0xd83c)
             {
                 [emojiRangesArray addObject:[NSValue valueWithRange:substringRange]];
             }
         }
         else
         {
             // non surrogate
             if (0x2100 <= hs &&
                 hs <= 0x27ff)
             {
                 [emojiRangesArray addObject:[NSValue valueWithRange:substringRange]];
             }
             else if (0x2B05 <= hs &&
                      hs <= 0x2b07)
             {
                 [emojiRangesArray addObject:[NSValue valueWithRange:substringRange]];
             }
             else if (0x2934 <= hs &&
                      hs <= 0x2935)
             {
                 [emojiRangesArray addObject:[NSValue valueWithRange:substringRange]];
             }
             else if (0x3297 <= hs &&
                      hs <= 0x3299)
             {
                 [emojiRangesArray addObject:[NSValue valueWithRange:substringRange]];
             }
             else if (hs == 0xa9 ||
                      hs == 0xae ||
                      hs == 0x303d ||
                      hs == 0x3030 ||
                      hs == 0x2b55 ||
                      hs == 0x2b1c ||
                      hs == 0x2b1b ||
                      hs == 0x2b50)
             {
                 [emojiRangesArray addObject:[NSValue valueWithRange:substringRange]];
             }
         }
     }];
    
    return emojiRangesArray;
}

- (BOOL)lgt_containsEmoji
{
    __block BOOL containsEmoji = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0,
                                                 [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring,
                                       NSRange substringRange,
                                       NSRange enclosingRange,
                                       BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs &&
             hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc &&
                     uc <= 0x1f9c0)
                 {
                     containsEmoji = YES;
                 }
             }
         }
         else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3 ||
                 ls == 0xfe0f ||
                 ls == 0xd83c)
             {
                 containsEmoji = YES;
             }
         }
         else
         {
             // non surrogate
             if (0x2100 <= hs &&
                 hs <= 0x27ff)
             {
                 containsEmoji = YES;
             }
             else if (0x2B05 <= hs &&
                      hs <= 0x2b07)
             {
                 containsEmoji = YES;
             }
             else if (0x2934 <= hs &&
                      hs <= 0x2935)
             {
                 containsEmoji = YES;
             }
             else if (0x3297 <= hs &&
                      hs <= 0x3299)
             {
                 containsEmoji = YES;
             }
             else if (hs == 0xa9 ||
                      hs == 0xae ||
                      hs == 0x303d ||
                      hs == 0x3030 ||
                      hs == 0x2b55 ||
                      hs == 0x2b1c ||
                      hs == 0x2b1b ||
                      hs == 0x2b50)
             {
                 containsEmoji = YES;
             }
         }
         
         if (containsEmoji)
         {
             *stop = YES;
         }
     }];
    
    return containsEmoji;
}
- (BOOL)lgt_isPureEmojiString
{
    if (self.length == 0) {
        return NO;
    }
    
    __block BOOL isPureEmojiString = YES;
    
    [self enumerateSubstringsInRange:NSMakeRange(0,
                                                 [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring,
                                       NSRange substringRange,
                                       NSRange enclosingRange,
                                       BOOL *stop)
     {
         BOOL containsEmoji = NO;
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs &&
             hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc &&
                     uc <= 0x1f9c0)
                 {
                     containsEmoji = YES;
                 }
             }
         }
         else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3 ||
                 ls == 0xfe0f ||
                 ls == 0xd83c)
             {
                 containsEmoji = YES;
             }
         }
         else
         {
             // non surrogate
             if (0x2100 <= hs &&
                 hs <= 0x27ff)
             {
                 containsEmoji = YES;
             }
             else if (0x2B05 <= hs &&
                      hs <= 0x2b07)
             {
                 containsEmoji = YES;
             }
             else if (0x2934 <= hs &&
                      hs <= 0x2935)
             {
                 containsEmoji = YES;
             }
             else if (0x3297 <= hs &&
                      hs <= 0x3299)
             {
                 containsEmoji = YES;
             }
             else if (hs == 0xa9 ||
                      hs == 0xae ||
                      hs == 0x303d ||
                      hs == 0x3030 ||
                      hs == 0x2b55 ||
                      hs == 0x2b1c ||
                      hs == 0x2b1b ||
                      hs == 0x2b50)
             {
                 containsEmoji = YES;
             }
         }
         
         if (!containsEmoji)
         {
             isPureEmojiString = NO;
             *stop = YES;
         }
     }];
    
    return isPureEmojiString;
}

#pragma mark - EmojiCount

- (NSInteger)lgt_emojiCount
{
    __block NSInteger emojiCount = 0;
    
    [self enumerateSubstringsInRange:NSMakeRange(0,
                                                 [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring,
                                       NSRange substringRange,
                                       NSRange enclosingRange,
                                       BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs &&
             hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc &&
                     uc <= 0x1f9c0)
                 {
                     emojiCount = emojiCount + 1;
                 }
             }
         }
         else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3 ||
                 ls == 0xfe0f ||
                 ls == 0xd83c)
             {
                 emojiCount = emojiCount + 1;
             }
         }
         else
         {
             // non surrogate
             if (0x2100 <= hs &&
                 hs <= 0x27ff)
             {
                 emojiCount = emojiCount + 1;
             }
             else if (0x2B05 <= hs &&
                      hs <= 0x2b07)
             {
                 emojiCount = emojiCount + 1;
             }
             else if (0x2934 <= hs &&
                      hs <= 0x2935)
             {
                 emojiCount = emojiCount + 1;
             }
             else if (0x3297 <= hs &&
                      hs <= 0x3299)
             {
                 emojiCount = emojiCount + 1;
             }
             else if (hs == 0xa9 ||
                      hs == 0xae ||
                      hs == 0x303d ||
                      hs == 0x3030 ||
                      hs == 0x2b55 ||
                      hs == 0x2b1c ||
                      hs == 0x2b1b ||
                      hs == 0x2b50)
             {
                 emojiCount = emojiCount + 1;
             }
         }
     }];
    
    return emojiCount;
}

@end
