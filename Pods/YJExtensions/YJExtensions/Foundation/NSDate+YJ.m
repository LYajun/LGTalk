//
//  NSDate+YJ.m
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "NSDate+YJ.h"
#import "NSString+YJ.h"

@implementation NSDate (YJ)
- (NSString *)yj_string {
    return [self yj_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)yj_stringDate {
    return [self yj_stringWithFormat:@"yyyy-MM-dd"];
}

- (NSString *)yj_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

- (NSDateComponents *)yj_dateComponents {
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:unitFlags fromDate:self];
    return dateComponents;
}

- (NSDate *)yj_dayBegin {
    NSDateComponents *dateComponents = self.yj_dateComponents;
    NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 00:00:00", dateComponents.year, dateComponents.month, dateComponents.day];
    return dateString.yj_date;
}

- (NSDate *)yj_dayEnd {
    NSDateComponents *dateComponents = self.yj_dateComponents;
    NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 23:59:59", dateComponents.year, dateComponents.month, dateComponents.day];
    return dateString.yj_date;
}

@end
