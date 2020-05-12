//
//  NSString+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

static NSString * const kYJCharactersGeneralDelimitersToEncode = @":#[]@";
static NSString * const kYJCharactersSubDelimitersToEncode = @"!$&'()*+,;=";

@interface NSString (YJ)
+ (NSString *)yj_Char1;
+ (NSString *)yj_StandardAnswerSeparatedStr;
+ (NSString *)yj_stringToASCIIStringWithIntCount:(NSInteger)intCount;
+ (NSString *)yj_stringToSmallTopicIndexStringWithIntCount:(NSInteger)intCount;

- (NSString *)yj_fileExtensionName;
- (NSString *)yj_deleteWhitespaceCharacter;
- (NSString *)yj_deleteWhitespaceAndNewlineCharacter;
- (NSInteger)yj_stringToASCIIInt;
- (NSArray *)yj_splitToCharacters;
+ (NSString *)yj_ChineseNumbersWithNumber:(NSInteger)number;

#pragma mark - Xml
/** xml字符串转换成NSDictionary */
- (NSDictionary *)yj_XMLDictionary;
#pragma mark - UUID
/** 获取随机 UUID 例如 E621E1F8-C36C-495A-93FC-0C247A3E6E5F */
+ (NSString *)yj_UUID;
/** 毫秒时间戳 例如 1443066826371 */
+ (NSString *)yj_UUIDTimestamp;
#pragma mark - 富文本
- (NSMutableAttributedString *)yj_toMutableAttributedString;
- (NSMutableAttributedString *)yj_toHtmlMutableAttributedString;
- (NSString *)yj_appendFontAttibuteWithSize:(CGFloat)size;
- (NSString *)yj_replaceStrongFontWithTextColorHex:(NSString *)textColorHex;
- (NSString *)yj_htmlImgFrameAdjust;
+ (NSString *)yj_filterHTML:(NSString *)html;
+ (NSString *)yj_adaptWebViewForHtml:(NSString *)htmlStr;
+ (BOOL)predicateMatchWithText:(NSString *)text matchFormat:(NSString *)matchFormat;
#pragma mark - 尺寸
- (CGFloat)yj_widthWithFont:(UIFont *)font;
- (CGFloat)yj_heightWithFont:(UIFont *)font;

#pragma mark - 时间
/** 按格式将字符串转为日期 */
- (NSDate *)yj_dateWithFormat:(NSString *)format;
- (NSString *)yj_yearString;
/** 按"yyyy-MM-dd'T'HH:mm:ss.SSS"或"yyyy-MM-dd HH:mm:ss"格式将字符串转为日期 */
- (NSDate *)yj_date;

/** 将日期字符串按格式format处理 */
- (NSString *)yj_dateStringWithFormat:(NSString *)format;

/** yyyy-MM-dd */
- (NSString *)yj_dateString;

/** MM-dd */
- (NSString *)yj_shortDateString;
/** HH:mm */
- (NSString *)yj_shortTimeString;
/** 将"yyyy-MM-dd HH:mm:ss"转为"MM-dd HH:mm" */
- (NSString *)yj_shortDateTimeString;
/** 将"yyyy-MM-dd HH:mm:ss"转为"yyyy-MM-dd HH:mm" */
- (NSString *)yj_longDateTimeString;
- (NSString *)yj_absoluteDateTimeString;
+ (NSString *)yj_timeFromTimeInterval:(NSTimeInterval)timeInterval isShowChinese:(BOOL)isShowChinese isRetainMinuter:(BOOL)isRetainMinuter;
+ (NSString *)yj_displayTimeWithCurrentTime:(NSString *)currentTime referTime:(NSString *)referTime;

#pragma mark - 编码、解码
- (NSString *)yj_URLDecode;
- (NSString *)yj_URLEncode;
- (NSString *)yj_URLQueryAllowedCharacterSet;
- (NSString *)yj_htmlDecode;
+ (NSString *)yj_deleteURLDoubleSlashWithUrlStr:(NSString *)urlStr;
+ (BOOL)yj_isNum:(NSString *)checkedNumString;
+ (BOOL)yj_predicateMatchWithText:(NSString *)text matchFormat:(NSString *)matchFormat;
@end

@interface NSString (Emo)
- (NSArray *)yj_emojiRanges;
- (BOOL)yj_containsEmoji;
- (BOOL)yj_isPureEmojiString;
- (NSInteger)yj_emojiCount;
@end

@interface NSString (Encrypt)

+ (NSString *)yj_encryptWithKey:(NSString *)key encryptStr:(NSString *)encryptStr;
+ (NSString *)yj_encryptWithKey:(NSString *)key encryptDic:(NSDictionary *)encryptDic;
+ (NSString *)yj_md5EncryptStr:(NSString *)encryptStr;

+ (NSString *)yj_decryptWithKey:(NSString *)key decryptStr:(NSString *)decryptStr;

- (NSString *)yj_reverse;
@end

NS_ASSUME_NONNULL_END
