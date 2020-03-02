//
//  NSDate+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (YJ)
- (NSString *)yj_string;

- (NSString *)yj_stringDate;

- (NSString *)yj_stringWithFormat:(NSString *)format;

- (NSDateComponents *)yj_dateComponents;

- (NSDate *)yj_dayBegin;

- (NSDate *)yj_dayEnd;
@end

NS_ASSUME_NONNULL_END
