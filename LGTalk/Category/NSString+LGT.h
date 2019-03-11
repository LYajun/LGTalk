//
//  NSString+LGT.h
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (LGT)
- (NSString *)lgt_fileExtensionName;
- (NSString *)lgt_deleteWhitespaceCharacter;
+ (NSString *)LGT_Char1;
+ (NSString *)LGT_StandardAnswerSeparatedStr;
+ (NSString *)lgt_stringToASCIIStringWithIntCount:(NSInteger)intCount;
- (NSInteger)lgt_stringToASCIIInt;
+ (NSString *)lgt_stringToSmallTopicIndexStringWithIntCount:(NSInteger)intCount;
- (NSMutableAttributedString *)lgt_toMutableAttributedString;
- (NSMutableAttributedString *)lgt_toHtmlMutableAttributedString;
- (NSString *)lgt_appendFontAttibuteWithSize:(CGFloat)size;
- (NSString *)lgt_replaceStrongWithFontAtTextColorHex:(NSString *)textColorHex;
- (NSString *)lgt_htmlImgFrameAdjust;
- (NSArray *)lgt_splitToCharacters;
- (NSArray *)lgt_emojiRanges;
- (BOOL)lgt_containsEmoji;
- (BOOL)lgt_isPureEmojiString;
- (NSInteger)lgt_emojiCount;

- (CGFloat)lgt_widthWithFont:(UIFont *)font;
- (CGFloat)lgt_heightWithFont:(UIFont *)font;
/** 按格式将字符串转为日期 */
- (NSDate *)lgt_dateWithFormat:(NSString *)format;
- (NSString *)lgt_yearString;
/** 按"yyyy-MM-dd'T'HH:mm:ss.SSS"或"yyyy-MM-dd HH:mm:ss"格式将字符串转为日期 */
- (NSDate *)lgt_date;

/** 将日期字符串按格式format处理 */
- (NSString *)lgt_dateStringWithFormat:(NSString *)format;

/** yyyy-MM-dd */
- (NSString *)lgt_dateString;

/** MM-dd */
- (NSString *)lgt_shortDateString;
/** HH:mm */
- (NSString *)lgt_shortTimeString;
/** 将"yyyy-MM-dd HH:mm:ss"转为"MM-dd HH:mm" */
- (NSString *)lgt_shortDateTimeString;
/** 将"yyyy-MM-dd HH:mm:ss"转为"yyyy-MM-dd HH:mm" */
- (NSString *)lgt_longDateTimeString;
- (NSString *)lgt_absoluteDateTimeString;
+ (NSString *)lgt_timeFromTimeInterval:(NSTimeInterval)timeInterval isShowChinese:(BOOL)isShowChinese isRetainMinuter:(BOOL)isRetainMinuter;
+ (NSString *)lgt_displayTimeWithCurrentTime:(NSString *)currentTime referTime:(NSString *)referTime;
@end
