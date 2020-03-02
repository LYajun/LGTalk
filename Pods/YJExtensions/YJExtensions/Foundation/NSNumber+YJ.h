//
//  NSNumber+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (YJ)
/* 展示 */
- (NSString*)yj_toDisplayNumberWithDigit:(NSInteger)digit;
- (NSString*)yj_toDisplayPercentageWithDigit:(NSInteger)digit;

/** 四舍五入 */
- (NSNumber*)yj_doRoundWithDigit:(NSUInteger)digit;
/** 取上整 */
- (NSNumber*)yj_doCeilWithDigit:(NSUInteger)digit;
/** 取下整 */
- (NSNumber*)yj_doFloorWithDigit:(NSUInteger)digit;
@end

NS_ASSUME_NONNULL_END
