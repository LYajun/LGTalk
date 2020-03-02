//
//  NSDictionary+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (YJ)
- (void)yj_each:(void (^)(id k, id v))block;
- (void)yj_eachKey:(void (^)(id k))block;
- (void)yj_eachValue:(void (^)(id v))block;
- (NSArray *)yj_map:(id (^)(id key, id value))block;
- (NSDictionary *)yj_pick:(NSArray *)keys;
- (NSDictionary *)yj_omit:(NSArray *)key;

#pragma msrk - URL
+ (NSDictionary *)yj_dictionaryWithURLQuery:(NSString *)query;
- (NSString *)yj_URLQueryString;
@end

NS_ASSUME_NONNULL_END
