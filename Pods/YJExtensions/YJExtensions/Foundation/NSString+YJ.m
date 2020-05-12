//
//  NSString+YJ.m
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "NSString+YJ.h"
#import <CommonCrypto/CommonCrypto.h>
#import "YJEHpple.h"
#import <objc/runtime.h>

#define YJ_ASSOCIATIVE_CURRENT_DICTIONARY_KEY @"ASSOCIATIVE_CURRENT_DICTIONARY_KEY"
#define YJ_ASSOCIATIVE_CURRENT_TEXT_KEY @"ASSOCIATIVE_CURRENT_TEXT_KEY"

#define IsObjEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))


static inline NSDictionary *YJHTMLEscapeMap() {
    return @{@"&nbsp;":@" ",
             @"&lt;":@"<",
             @"&gt;":@">",
             @"&amp;":@"&",
             @"&quot;":@"\"",
             @"&apos;":@"'"
    };
}

@interface NSString () <NSXMLParserDelegate>

@property(nonatomic, retain)NSMutableArray *currentDictionaries;
@property(nonatomic, retain)NSMutableString *currentText;


@end

@implementation NSString (YJ)



+ (NSString *)yj_Char1{
    return [NSString stringWithFormat:@"%c",1];
}
+ (NSString *)yj_StandardAnswerSeparatedStr{
    return @"$/";
}
+ (NSString *)yj_stringToASCIIStringWithIntCount:(NSInteger)intCount{
    return [NSString stringWithFormat:@"%c",(int)intCount];
}
+ (NSString *)yj_stringToSmallTopicIndexStringWithIntCount:(NSInteger)intCount{
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
- (NSString *)yj_fileExtensionName{
    return [self componentsSeparatedByString:@"."].lastObject;
}
- (NSString *)yj_deleteWhitespaceCharacter{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
- (NSString *)yj_deleteWhitespaceAndNewlineCharacter{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (NSInteger)yj_stringToASCIIInt{
    return [self characterAtIndex:0];
}
- (NSArray *)yj_splitToCharacters{
    if (self.length > 0) {
        NSInteger length = [self length];
        NSInteger len = 0;
        NSMutableArray *arr = [NSMutableArray array];
        while (len < length) {
            [arr addObject:[NSString stringWithFormat:@"%c",[self characterAtIndex:len]]];
            len++;
        }
        return arr;
    }
    return @[];
}
+ (NSString *)yj_ChineseNumbersWithNumber:(NSInteger)number{
    NSDictionary *numberDic = @{@"0":@"零",@"1":@"一",@"2":@"二",@"3":@"三",@"4":@"四",@"5":@"五",@"6":@"六",@"7":@"七",@"8":@"八",@"9":@"九",@"10":@"十",@"100":@"一百",@"1000":@"一千"};
    NSString *numberStr = @"零";
    if (number <= 10 || number == 100 || number == 1000) {
        numberStr = [numberDic objectForKey:[NSString stringWithFormat:@"%li",number]];
    }else if (number < 100){
        NSInteger shi = number / 10;
        NSInteger ge =  number % 10;
        numberStr = [NSString stringWithFormat:@"%@十%@",[numberDic objectForKey:[NSString stringWithFormat:@"%li",shi]],[numberDic objectForKey:[NSString stringWithFormat:@"%li",ge]]] ;
    }else if (number < 1000){
        NSInteger bai = number / 100;
        NSInteger shi = number % 100 / 10;
        NSInteger ge =  number % 100 % 10;
        numberStr = [NSString stringWithFormat:@"%@百%@十%@",[numberDic objectForKey:[NSString stringWithFormat:@"%li",bai]],[numberDic objectForKey:[NSString stringWithFormat:@"%li",shi]],[numberDic objectForKey:[NSString stringWithFormat:@"%li",ge]]] ;
    }
    return numberStr;
}
#pragma mark - Xml

-(NSDictionary *)yj_XMLDictionary{
    //TURN THE STRING INTO DATA
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    //INTIALIZE NECESSARY HELPER VARIABLES
    self.currentDictionaries = [[NSMutableArray alloc] init] ;
    self.currentText = [[NSMutableString alloc] init];
    
    //INITIALIZE WITH A DICTIONARY TO START WITH
    [self.currentDictionaries addObject:[NSMutableDictionary dictionary]];
    
    //DO PARSING
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL success = [parser parse];
    
    //RETURNS
    if(success)
        return [self.currentDictionaries objectAtIndex:0];
    else
        return nil;
}

- (void)setCurrentDictionaries:(NSMutableArray *)currentDictionaries{
    objc_setAssociatedObject(self, YJ_ASSOCIATIVE_CURRENT_DICTIONARY_KEY, currentDictionaries, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray *)currentDictionaries{
    return objc_getAssociatedObject(self, YJ_ASSOCIATIVE_CURRENT_DICTIONARY_KEY);
}

- (void)setCurrentText:(NSMutableString *)currentText{
    objc_setAssociatedObject(self, YJ_ASSOCIATIVE_CURRENT_TEXT_KEY, currentText, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableString *)currentText{
    return objc_getAssociatedObject(self, YJ_ASSOCIATIVE_CURRENT_TEXT_KEY);
}



- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //GET THE LAST DICTIONARY
    NSMutableDictionary *parent = [self.currentDictionaries lastObject];
    
    //CREATE A NEW DICTIONARY AND SET ALL THE ATTRIBUTES
    NSMutableDictionary *child = [NSMutableDictionary dictionary];
    [child addEntriesFromDictionary:attributeDict];
    
    id currentValue = [parent objectForKey:elementName];
    
    //SHOULD BE AN ARRAY IF WE ALREADY HAVE ONE FOR THIS KEY, OTHERWISE JUST ADD IT IN
    if (currentValue)
    {
        NSMutableArray *array = nil;
        
        //IF CURRENTVALUE IS ALREADY AN ARRAY USE IT, OTHERWISE, MAKE ONE
        if ([currentValue isKindOfClass:[NSMutableArray class]])
            array = (NSMutableArray *) currentValue;
        else
        {
            array = [NSMutableArray array];
            [array addObject:currentValue];
            
            //REPLACE DICTIONARY WITH ARRAY IN PARENT
            [parent setObject:array forKey:elementName];
        }
        
        [array addObject:child];
    }
    else
        [parent setObject:child forKey:elementName];
    
    //ADD NEW OBJECT
    [self.currentDictionaries addObject:child];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //UPDATE PARENT INFO
    NSMutableDictionary *dictInProgress = [self.currentDictionaries lastObject];
    
    if ([self.currentText length] > 0)
    {
        //REMOVE WHITE SPACE
        [dictInProgress setObject:self.currentText forKey:@"text"];
        
        self.currentText = nil;
        self.currentText = [[NSMutableString alloc] init];
    }
    
    //NO LONGER NEED THIS DICTIONARY, AS WE'RE DONE WITH IT
    [self.currentDictionaries removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [self.currentText appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    //WILL RETURN NIL FOR ERROR
}

#pragma mark - UUID

+ (NSString *)yj_UUID{
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0){
        return  [[NSUUID UUID] UUIDString];
    }else{
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        return (__bridge_transfer NSString *)uuid;
    }
}
+ (NSString *)yj_UUIDTimestamp{
    return  [[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]*1000] stringValue];
}
#pragma mark - 富文本
- (NSMutableAttributedString *)yj_toMutableAttributedString{
    return [[NSMutableAttributedString alloc] initWithString:self];
}
- (NSMutableAttributedString *)yj_toHtmlMutableAttributedString{
    NSData *htmlData = [self dataUsingEncoding:NSUnicodeStringEncoding];
    return [[NSMutableAttributedString alloc] initWithData:htmlData options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
}
- (NSString *)yj_appendFontAttibuteWithSize:(CGFloat)size{
    return [NSString stringWithFormat:@"<font size=\"%f\">%@</font>",size,self];
}
- (NSString *)yj_replaceStrongFontWithTextColorHex:(NSString *)textColorHex{
     NSString *str = self;
    if (![str containsString:@"<strong>"]) {
        return str;
    }
    str = [str stringByReplacingOccurrencesOfString:@"<strong>" withString:[NSString stringWithFormat:@"<font color=\"%@\">",textColorHex]];
    str = [str stringByReplacingOccurrencesOfString:@"</strong>" withString:@"</font>"];
    return str;
}
- (NSString *)yj_htmlImgFrameAdjust{
    __block NSString *html = self.copy;
    if (!html || html.length == 0) {
        return html;
    }
    NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    // 解析html数据
    YJEHpple *xpathParser = [[YJEHpple alloc] initWithHTMLData:htmlData];
    // 根据标签来进行过滤
    NSArray *imgArray = [xpathParser searchWithXPathQuery:@"//img"];
    
    if (imgArray && imgArray.count > 0) {
        [imgArray enumerateObjectsUsingBlock:^(YJEHppleElement *hppleElement, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *attributes = hppleElement.attributes;
            NSString *src = attributes[@"src"];
            NSString *srcSuf = [src componentsSeparatedByString:@"."].lastObject;
            if (srcSuf && [srcSuf.lowercaseString containsString:@"gif"]) {
                // gif 自适应
            }else{
                CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
                html = [NSString stringWithFormat:@"<html><head><style>img{max-width:%.f;height:auto !important;width:auto !important;};</style></head><body style='margin:0; padding:0;'>%@</body></html>",screenW-30, html];
            }
        }];
    }
    return html;
}
+ (NSString *)yj_filterHTML:(NSString *)html{
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return html;
}
+ (NSString *)yj_adaptWebViewForHtml:(NSString *)htmlStr{
    NSMutableString *headHtml = [[NSMutableString alloc] initWithCapacity:0];
    [headHtml appendString : @"<html>" ];
    [headHtml appendString : @"<head>" ];
    [headHtml appendString : @"<meta charset=\"utf-8\">" ];
    [headHtml appendString : @"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />" ];
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />" ];
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />" ];
    [headHtml appendString : @"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />" ];
    [headHtml appendString:@"<body style=\"word-wrap:break-word;\">"];
    //适配图片宽度，让图片宽度等于屏幕宽度
    //[headHtml appendString : @"<style>img{width:100%;}</style>" ];
    //[headHtml appendString : @"<style>img{height:auto;}</style>" ];
    //适配图片宽度，让图片宽度最大等于屏幕宽度
    //    [headHtml appendString : @"<style>img{max-width:100%;width:auto;height:auto;}</style>"];
    //适配图片宽度，如果图片宽度超过手机屏幕宽度，就让图片宽度等于手机屏幕宽度，高度自适应，如果图片宽度小于屏幕宽度，就显示图片大小
    [headHtml appendString : @"<script type='text/javascript'>"
     "window.onload = function(){\n"
     "var maxwidth=document.body.clientWidth;\n" //屏幕宽度
     "for(i=0;i <document.images.length;i++){\n"
     "var myimg = document.images[i];\n"
     "if(myimg.width > maxwidth){\n"
     "myimg.style.width = '90%';\n"
     "myimg.style.height = 'auto'\n;"
     "}\n"
     "}\n"
     "}\n"
     "</script>\n"];
    [headHtml appendString : @"<style>table{width:90%;}</style>" ];
    [headHtml appendString : @"<title>webview</title>" ];
    NSString *bodyHtml;
    bodyHtml = [NSString stringWithString:headHtml];
    bodyHtml = [bodyHtml stringByAppendingString:htmlStr];
    return bodyHtml;
}
+ (BOOL)predicateMatchWithText:(NSString *)text matchFormat:(NSString *)matchFormat{
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", matchFormat];
    return [predicate evaluateWithObject:text];
}
#pragma mark - 尺寸
- (CGFloat)yj_widthWithFont:(UIFont *)font{
    CGSize stringSize = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return ceil(stringSize.width);
}
- (CGFloat)yj_heightWithFont:(UIFont *)font{
    CGSize stringSize = [self boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return ceil(stringSize.height);
}
#pragma mark - 时间
- (NSDate *)yj_dateWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:self];
    return date;
}

- (NSDate *)yj_date {
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
    }
    if (zelf.length > 19) {
        zelf = [zelf substringToIndex:19];
    }else if (zelf.length == 16){
        zelf = [zelf stringByAppendingString:@":00"];
    }else if (zelf.length == 13){
        zelf = [zelf stringByAppendingString:@":00:00"];
    }
    return [zelf yj_dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)yj_dateStringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self.yj_date];
}
- (NSString *)yj_yearString{
    return [self yj_dateStringWithFormat:@"yyyy"];
}
- (NSString *)yj_dateString {
    return [self yj_dateStringWithFormat:@"yyyy-MM-dd"];
}

- (NSString *)yj_shortDateString {
    return [self yj_dateStringWithFormat:@"MM-dd"];
}
- (NSString *)yj_shortTimeString {
    return [self yj_dateStringWithFormat:@"HH:mm"];
}
- (NSString *)yj_shortDateTimeString {
    return [self yj_dateStringWithFormat:@"MM-dd HH:mm"];
}
- (NSString *)yj_longDateTimeString {
    return [self yj_dateStringWithFormat:@"yyyy-MM-dd HH:mm"];
}
- (NSString *)yj_absoluteDateTimeString {
    return [self yj_dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}
+ (NSString *)yj_timeFromTimeInterval:(NSTimeInterval)timeInterval isShowChinese:(BOOL)isShowChinese isRetainMinuter:(BOOL)isRetainMinuter{
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
    }else{
        NSInteger hour = (NSInteger)timeInterval / (60*60);
        NSInteger minute = (NSInteger)timeInterval % (60*60) / 60;
        NSInteger second = (NSInteger)timeInterval % (60*60) % 60;
        if (isShowChinese) {
            return [NSString stringWithFormat:@"%li时%li分%02li秒",hour,minute,second];
        }else{
            return [NSString stringWithFormat:@"%02li:%02li:%02li",hour,minute,second];
        }
    }
}
+ (NSString *)yj_displayTimeWithCurrentTime:(NSString *)currentTime referTime:(NSString *)referTime{
    NSDate *currentDate = currentTime.yj_date;
    NSDate *referDate = referTime.yj_date;
    NSTimeInterval intervalEnd = [currentDate timeIntervalSinceDate:referDate];
    NSString *displayTime;
    if (intervalEnd > 24*60*60) {
        displayTime = [NSString stringWithFormat:@"%@",referTime.yj_shortDateTimeString];
    }else{
        NSInteger nowDay = [currentTime.yj_shortDateString componentsSeparatedByString:@"-"].lastObject.integerValue;
        NSInteger creaDay = [referTime.yj_shortDateString componentsSeparatedByString:@"-"].lastObject.integerValue;
        if (nowDay == creaDay) {
            displayTime = [NSString stringWithFormat:@"今天: %@",referTime.yj_shortTimeString];
        }else{
            displayTime = [NSString stringWithFormat:@"昨天: %@",referTime.yj_shortTimeString];
        }
    }
    return displayTime;
}
#pragma mark - 编码、转码
- (NSString *)yj_URLDecode{
    return [self stringByRemovingPercentEncoding];
}
- (NSString *)yj_URLEncode{
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kYJCharactersGeneralDelimitersToEncode stringByAppendingString:kYJCharactersSubDelimitersToEncode]];
    NSString *URLEscapedString = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    return URLEscapedString;
}
- (NSString *)yj_URLQueryAllowedCharacterSet{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
+ (NSString *)yj_deleteURLDoubleSlashWithUrlStr:(NSString *)urlStr{
    if (urlStr && urlStr.length > 0 && [urlStr containsString:@"://"]) {
        NSArray *urlArr = [urlStr componentsSeparatedByString:@"://"];
       NSString *lastStr = [urlArr.lastObject stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
       while ([lastStr containsString:@"//"]) {
           lastStr = [lastStr stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
       }
       urlStr = [NSString stringWithFormat:@"%@://%@",urlArr.firstObject,lastStr];
    }
    return urlStr;
}
- (NSString *)yj_htmlDecode{
    if (self && self.length > 0) {
        NSString *html = self;
        for (NSString *keyStr in YJHTMLEscapeMap().allKeys) {
            if ([html containsString:keyStr]) {
                html = [html stringByReplacingOccurrencesOfString:keyStr withString:[YJHTMLEscapeMap() objectForKey:keyStr]];
            }
        }
        return html;
    }
    return @"";
}
+ (BOOL)yj_isNum:(NSString *)checkedNumString{
    if (!checkedNumString || checkedNumString.length == 0) {
        return NO;
    }
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}
+ (BOOL)yj_predicateMatchWithText:(NSString *)text matchFormat:(NSString *)matchFormat{
    if (!text || text.length == 0) {
        return NO;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", matchFormat];
    return [predicate evaluateWithObject:text];
}
@end

@implementation NSString (Emo)
- (NSArray *)yj_emojiRanges{
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

- (BOOL)yj_containsEmoji{
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
- (BOOL)yj_isPureEmojiString{
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

- (NSInteger)yj_emojiCount{
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

@implementation NSString (Encrypt)
+ (NSString *)yj_encryptWithKey:(NSString *)key encryptStr:(NSString *)encryptStr{
    if (IsObjEmpty(key) || IsObjEmpty(encryptStr)) {
        return @"";
    }
    //转化skey
    NSString *keyAfterMD5 = [self yj_md5EncryptStr:key];
    NSData *keyData = [keyAfterMD5 dataUsingEncoding: NSUTF8StringEncoding];
    Byte *keyByte = (Byte *)[keyData bytes];
    Byte key_S = keyByte[keyData.length-1];//skey
    
    //转化加密字符串
    NSData *strData = [encryptStr dataUsingEncoding: NSUTF8StringEncoding];
    Byte *strByte = (Byte *)[strData bytes];
    //遍历数组并异或
    NSMutableString *strF = [NSMutableString stringWithCapacity:5];
    for(int i = 0;i < [strData length] ; i++){
        strByte[i] = strByte[i]^key_S;
        [strF appendFormat:@"%03d",strByte[i]];
    }
    //逆序输出
    NSString *reverseStrF = strF.yj_reverse;
    return reverseStrF;
}
+ (NSString *)yj_md5EncryptStr:(NSString *)encryptStr{
    if (IsObjEmpty(encryptStr)) {
        return @"";
    }
    const char *cStrValue = [encryptStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStrValue, (CC_LONG)strlen(cStrValue), result);
    NSMutableString *ciphertext = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ciphertext appendFormat:@"%02x", result[i]];
    }
    NSString *mdfiveString = [ciphertext lowercaseString];
    return mdfiveString;
}
+ (NSString *)yj_encryptWithKey:(NSString *)key encryptDic:(NSDictionary *)encryptDic{
    if (IsObjEmpty(key) || IsObjEmpty(encryptDic)) {
        return @"";
    }
    NSData *jsData;
    if (@available(iOS 11.0, *)) {
        jsData = [NSJSONSerialization dataWithJSONObject:encryptDic options:NSJSONWritingSortedKeys error:nil];
    }else{
        jsData = [NSJSONSerialization dataWithJSONObject:encryptDic options:NSJSONWritingPrettyPrinted error:nil];
    }
    NSString *codeString = [[NSString alloc] initWithData:jsData encoding:NSUTF8StringEncoding];
    return [self yj_encryptWithKey:key encryptStr:codeString];
}

+ (NSString *)yj_decryptWithKey:(NSString *)key decryptStr:(NSString *)decryptStr{
    if (IsObjEmpty(key) || IsObjEmpty(decryptStr)) {
        return @"";
    }
    //转化skey
    NSString *keyAfterMD5 = [self yj_md5EncryptStr:key];
    NSData *keyData = [keyAfterMD5 dataUsingEncoding: NSUTF8StringEncoding];
    Byte *keyByte = (Byte *)[keyData bytes];
    Byte key_S = keyByte[keyData.length-1];//skey
    
    //字符串逆序
    int temp;
    NSMutableString *strRerverse = [NSMutableString stringWithCapacity:5];
    for(int i = (int)decryptStr.length-1 ; i>= 0; i--){
        temp = [decryptStr characterAtIndex:i];
        [strRerverse appendFormat:@"%c",temp];
    }
    //分割字符串
    Byte value[strRerverse.length/3];//定义字节数组
    
    for (int i=0, k=0; i<strRerverse.length; i+=3,k++) {
        NSRange range = NSMakeRange(i, 3);//i为开始点，3为取多少位
        temp = [[strRerverse substringWithRange:range]intValue];
        value[k] = temp ^ key_S;
    }
    NSData *adata = [[NSData alloc] initWithBytes:value length:strRerverse.length/3];
    NSString *strFin = [[NSString alloc] initWithData:adata encoding:NSUTF8StringEncoding];
    return strFin;
}

- (NSString *)yj_reverse{
    NSMutableString *reverseString;
    NSInteger len = [self length];
    // 给字符串分配一块内存空间
    reverseString = [NSMutableString stringWithCapacity:len];
    // 对字符串进行反转
    while (len > 0) {
        [reverseString appendString:[NSString stringWithFormat:@"%c",[self characterAtIndex:--len]]];
    }
    return reverseString;
}
@end
