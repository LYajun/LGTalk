//
//  NSUserDefaults+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (YJ)
+ (NSString *)yj_stringForKey:(NSString *)defaultName;

+ (NSArray *)yj_arrayForKey:(NSString *)defaultName;

+ (NSDictionary *)yj_dictionaryForKey:(NSString *)defaultName;

+ (NSData *)yj_dataForKey:(NSString *)defaultName;

+ (NSArray *)yj_stringArrayForKey:(NSString *)defaultName;

+ (NSInteger)yj_integerForKey:(NSString *)defaultName;

+ (float)yj_floatForKey:(NSString *)defaultName;

+ (double)yj_doubleForKey:(NSString *)defaultName;

+ (BOOL)yj_boolForKey:(NSString *)defaultName;

+ (void)yj_setObject:(id)value forKey:(NSString *)defaultName;

@end

NS_ASSUME_NONNULL_END
