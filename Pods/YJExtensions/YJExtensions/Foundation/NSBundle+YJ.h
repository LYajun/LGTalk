//
//  NSBundle+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (YJ)
+ (instancetype)yj_bundleWithCustomClass:(Class)customClass bundleName:(NSString *)bundleName;
- (NSString *)yj_bundlePathWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
