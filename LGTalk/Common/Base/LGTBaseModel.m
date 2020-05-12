//
//  LGTBaseModel.m
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGTBaseModel.h"
#import <objc/runtime.h>
#import <MJExtension/MJExtension.h>
@implementation LGTBaseModel
+ (NSArray *)mj_ignoredPropertyNames{
    return @[@"hash",@"superclass",@"description",@"debugDescription"];
}
//完全复制属性
- (id)mutableCopyWithZone:(NSZone *)zone
{
    id mode = [[[self class] allocWithZone:zone] init];
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        // 设置到成员变量身上
        NSString *key = [NSString stringWithUTF8String:name];
        
        id value = [self valueForKey:key];
        //数组对象 完全复制
        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSMutableArray class]]) {
            [mode setValue:[self copyArray:value] forKey:key];
        }
        else if ([value conformsToProtocol:@protocol(NSMutableCopying)]) {
            [mode setValue:[value mutableCopy] forKey:key];
        }
        else
        {
            [mode setValue:value forKey:key];
        }
    }
    
    free(ivars);
    
    return mode;
}


//数组对象完全复制
- (id)copyArray:(id)array
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    for (id object in array) {
        if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSMutableArray class]]) {
            [mutableArray addObject:[self copyArray:object]];
        }
        else if ([object conformsToProtocol:@protocol(NSMutableCopying)]) {
            [mutableArray addObject:[object mutableCopy]];
        }
        else
        {
            [mutableArray addObject:object];
        }
    }
    return mutableArray;
}

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary {
    self = [self.class mj_objectWithKeyValues:aDictionary];
    return self;
}

- (instancetype)initWithJSONString:(NSString *)aJSONString {
    self = [self.class mj_objectWithKeyValues:aJSONString];
    return self;
}

- (NSDictionary *)lgt_JsonModel{
    return [self mj_JSONObject];
}

@end
