//
//  NSBundle+YJ.m
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "NSBundle+YJ.h"

@implementation NSBundle (YJ)

+ (instancetype)yj_bundleWithCustomClass:(Class)customClass bundleName:(NSString *)bundleName{
    
//    static NSBundle *bundle = nil;
//    if (!bundle) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
      NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:customClass] pathForResource:bundleName ofType:@"bundle"]];
//    }
    return bundle;
}

- (NSString *)yj_bundlePathWithName:(NSString *)name{
    return [[self resourcePath] stringByAppendingPathComponent:name];
}
@end
