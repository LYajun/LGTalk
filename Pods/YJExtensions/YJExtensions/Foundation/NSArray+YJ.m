//
//  NSArray+YJ.m
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "NSArray+YJ.h"

@implementation NSArray (YJ)
- (id)yj_objectAtIndex:(NSUInteger)index{
    if (index > self.count-1) {
        return self.lastObject;
    }
    return [self objectAtIndex:index];
}
- (void)yj_each:(void (^)(id object))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (void)yj_eachWithIndex:(void (^)(id object, NSUInteger index))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx);
    }];
}

- (NSArray *)yj_map:(id (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    
    for (id object in self) {
        [array addObject:block(object) ?: [NSNull null]];
    }
    
    return array;
}

- (NSArray *)yj_filter:(BOOL (^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return block(evaluatedObject);
    }]];
}

- (NSArray *)yj_reject:(BOOL (^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return !block(evaluatedObject);
    }]];
}

- (id)yj_detect:(BOOL (^)(id object))block {
    for (id object in self) {
        if (block(object))
            return object;
    }
    return nil;
}

- (id)yj_reduce:(id (^)(id accumulator, id object))block {
    return [self yj_reduce:nil withBlock:block];
}

- (id)yj_reduce:(id)initial withBlock:(id (^)(id accumulator, id object))block {
    id accumulator = initial;
    
    for(id object in self)
        accumulator = accumulator ? block(accumulator, object) : object;
    
    return accumulator;
}
@end


@implementation NSMutableArray (YJ)
- (void)yj_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    if (index > self.count-1) {
        return;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
}
- (void)yj_removeObjectAtIndex:(NSUInteger)index{
    if (index > self.count-1) {
        return;
    }
    [self removeObjectAtIndex:index];
}
@end
