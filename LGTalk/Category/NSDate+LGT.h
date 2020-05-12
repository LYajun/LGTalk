//
//  NSDate+LGT.h
//
//
//  Created by 刘亚军 on 2018/11/12.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LGT)
- (NSString *)lgt_string;

- (NSString *)lgt_stringDate;

- (NSString *)lgt_stringWithFormat:(NSString *)format;

- (NSDateComponents *)lgt_dateComponents;

- (NSDate *)lgt_dayBegin;

- (NSDate *)lgt_dayEnd;
@end
