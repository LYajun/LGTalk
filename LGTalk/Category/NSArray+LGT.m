//
//  NSArray+LGT.m
//
//
//  Created by 刘亚军 on 2018/11/6.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "NSArray+LGT.h"
#import "LGTConst.h"

@implementation NSArray (LGT)
- (id)lgt_objectAtIndex:(NSUInteger)index{
    if (LGT_IsArrEmpty(self)) {
        return @"";
    }
    if (index > self.count-1) {
        return self.lastObject;
    }
    return [self objectAtIndex:index];
}
@end

@implementation NSMutableArray (LGT)
- (void)lgt_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    if (LGT_IsArrEmpty(self)) {
        return;
    }
    if (index > self.count-1) {
        return;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
}
@end
