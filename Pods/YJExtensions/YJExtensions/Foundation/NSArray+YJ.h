//
//  NSArray+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (YJ)

- (id)yj_objectAtIndex:(NSUInteger)index;

- (void)yj_each:(void (^)(id object))block;
- (void)yj_eachWithIndex:(void (^)(id object, NSUInteger index))block;
/** 映射：把一个列表变成相同长度的另一个列表，原始列表中的每一个值，在新的列表中都有一个对应的值 */
- (NSArray *)yj_map:(id (^)(id object))block;
/** 过滤：一个列表通过过滤能够返回一个只包含了原列表中符合条件的元素的新列表 */
- (NSArray *)yj_filter:(BOOL (^)(id object))block;
/** 反过滤：过滤掉符合条件的 */
- (NSArray *)yj_reject:(BOOL (^)(id object))block;

- (id)yj_detect:(BOOL (^)(id object))block;
- (id)yj_reduce:(id (^)(id accumulator, id object))block;
- (id)yj_reduce:(nullable id)initial withBlock:(id (^)(id accumulator, id object))block;

@end


@interface NSMutableArray (YJ)

- (void)yj_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

- (void)yj_removeObjectAtIndex:(NSUInteger)index;

@end
NS_ASSUME_NONNULL_END
