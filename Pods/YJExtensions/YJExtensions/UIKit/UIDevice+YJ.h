//
//  UIDevice+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (YJ)
+ (NSString *)yj_platform;
+ (NSString *)yj_platformString;


+ (NSString *)yj_macAddress;

//Return the current device CPU frequency
+ (NSUInteger)yj_cpuFrequency;
// Return the current device BUS frequency
+ (NSUInteger)yj_busFrequency;
//current device RAM size
+ (NSUInteger)yj_ramSize;
//Return the current device CPU number
+ (NSUInteger)yj_cpuNumber;
//Return the current device total memory

/// 获取iOS系统的版本号
+ (NSString *)yj_systemVersion;
/// 判断当前系统是否有摄像头
+ (BOOL)yj_hasCamera;
/// 获取手机内存总量, 返回的是字节数
+ (NSUInteger)yj_totalMemoryBytes;
/// 获取手机可用内存, 返回的是字节数
+ (NSUInteger)yj_freeMemoryBytes;

/// 获取手机硬盘空闲空间, 返回的是字节数
+ (long long)yj_freeDiskSpaceBytes;
/// 获取手机硬盘总空间, 返回的是字节数
+ (long long)yj_totalDiskSpaceBytes;
@end

NS_ASSUME_NONNULL_END
