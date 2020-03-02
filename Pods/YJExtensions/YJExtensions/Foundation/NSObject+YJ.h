//
//  NSObject+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YJ)

#pragma mark - KVO
- (void)yj_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
- (void)yj_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

#pragma mark - App信息
-(NSString *)yj_version;
-(NSInteger)yj_build;
-(NSString *)yj_identifier;
-(NSString *)yj_currentLanguage;
-(NSString *)yj_deviceModel;
@end

@interface NSObject (Reflection)
//类名
- (NSString *)yj_className;
+ (NSString *)yj_className;
//父类名称
- (NSString *)yj_superClassName;
+ (NSString *)yj_superClassName;

//实例属性字典
-(NSDictionary *)yj_propertyDictionary;

//属性名称列表
- (NSArray*)yj_propertyKeys;
+ (NSArray *)yj_propertyKeys;

//属性详细信息列表
- (NSArray *)yj_propertiesInfo;
+ (NSArray *)yj_propertiesInfo;

//格式化后的属性列表
+ (NSArray *)yj_propertiesWithCodeFormat;

//方法列表
-(NSArray*)yj_methodList;
+(NSArray*)yj_methodList;

-(NSArray*)yj_methodListInfo;

//创建并返回一个指向所有已注册类的指针列表
+ (NSArray *)yj_registedClassList;
//实例变量
+ (NSArray *)yj_instanceVariable;

//协议列表
-(NSDictionary *)yj_protocolList;
+ (NSDictionary *)yj_protocolList;


- (BOOL)yj_hasPropertyForKey:(NSString*)key;
- (BOOL)yj_hasIvarForKey:(NSString*)key;
@end

NS_ASSUME_NONNULL_END
