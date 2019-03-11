//
//  NSDate+LGT.m
//
//
//  Created by 刘亚军 on 2018/11/12.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "NSDate+LGT.h"
#import "NSString+LGT.h"

@implementation NSDate (LGT)
- (NSString *)lgt_string {
    return [self lgt_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)lgt_stringDate {
    return [self lgt_stringWithFormat:@"yyyy-MM-dd"];
}

- (NSString *)lgt_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

- (NSDateComponents *)lgt_dateComponents {
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:unitFlags fromDate:self];
    return dateComponents;
}

- (NSDate *)lgt_dayBegin {
    NSDateComponents *dateComponents = self.lgt_dateComponents;
    NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 00:00:00", dateComponents.year, dateComponents.month, dateComponents.day];
    return dateString.lgt_date;
}

- (NSDate *)lgt_dayEnd {
    NSDateComponents *dateComponents = self.lgt_dateComponents;
    NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 23:59:59", dateComponents.year, dateComponents.month, dateComponents.day];
    return dateString.lgt_date;
}

@end
