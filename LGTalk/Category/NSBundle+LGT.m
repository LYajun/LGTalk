//
//  NSBundle+LGT.m
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "NSBundle+LGT.h"
@interface LGTExtModel : NSObject
@end
@implementation LGTExtModel
@end

@implementation NSBundle (LGT)
+ (instancetype)lgt_knowledgeBundle{
    static NSBundle *dictionaryBundle = nil;
    if (!dictionaryBundle) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        dictionaryBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[LGTExtModel class]] pathForResource:@"LGTalk" ofType:@"bundle"]];
    }
    return dictionaryBundle;
}
+ (NSString *)lgt_bundlePathWithName:(NSString *)name{
    return [[[NSBundle lgt_knowledgeBundle] resourcePath] stringByAppendingPathComponent:name];
}

@end
