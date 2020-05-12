//
//  NSObject+LGT.m
//
//
//  Created by 刘亚军 on 2018/11/14.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "NSObject+LGT.h"

@implementation NSObject (LGT)
// 交换后的方法
- (void)lgt_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    if ([self observerKeyPath:keyPath]) {
        [self removeObserver:observer forKeyPath:keyPath];
    }
}
// 交换后的方法
- (void)lgt_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    if (![self observerKeyPath:keyPath]) {
        [self addObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

// 进行检索获取Key
- (BOOL)observerKeyPath:(NSString *)key{
    id info = self.observationInfo;
    NSArray *array = [info valueForKey:@"_observances"];
    for (id objc in array) {
        id Properties = [objc valueForKeyPath:@"_property"];
        NSString *keyPath = [Properties valueForKeyPath:@"_keyPath"];
        if ([key isEqualToString:keyPath]) {
            return YES;
        }
    }
    return NO;
}
@end
