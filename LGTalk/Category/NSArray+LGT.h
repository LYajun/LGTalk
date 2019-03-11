//
//  NSArray+LGT.h
//
//
//  Created by 刘亚军 on 2018/11/6.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LGT)
- (id)lgt_objectAtIndex:(NSUInteger)index;
@end


@interface NSMutableArray (LGT)
- (void)lgt_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
@end
