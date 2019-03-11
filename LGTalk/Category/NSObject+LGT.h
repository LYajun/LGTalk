//
//  NSObject+LGT.h
//
//
//  Created by 刘亚军 on 2018/11/14.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LGT)
/** 添加观察者 */
- (void)lgt_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
/** 移除观察者 */
- (void)lgt_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
@end
