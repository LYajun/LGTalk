//
//  NSBundle+LGT.h
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (LGT)

+ (instancetype)lgt_knowledgeBundle;

+ (NSString *)lgt_bundlePathWithName:(NSString *)name;

@end
