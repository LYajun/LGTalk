//
//  LGLogManager.h
//  LGLogDemo
//
//  Created by 刘亚军 on 2018/3/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGLogFormatter.h"

#if DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelAll;
#else
static const DDLogLevel ddLogLevel = DDLogLevelError;
#endif
/** 同步日志回调 */
typedef void(^LGUploadFileLogBlock)(NSString *logFilePath);
/** 日志同步频率 */
typedef NS_ENUM(NSInteger, LGLogFrequency) {
    LGLogFrequencyYear,
    LGLogFrequencyMonth,
    LGLogFrequencyWeek,
    LGLogFrequencyDay
};

@interface LGLogManager : NSObject
+ (instancetype)shareInstence;
/** 开启日志文件系统, 默认日志文件刷新频率为1周 */
- (void)startFileLogSystem;

/**
 以指定日志文件保存路径开启日志文件系统

 @param direct 日志文件保存路径
 @param freshLogFrequency 日志刷新频率
 */
- (void)startFileLogSystemWithDirectory:(NSString *)direct
                      freshLogFrequency:(LGLogFrequency) freshLogFrequency;

/* 获得默认日志的路径 **/
- (NSArray *)getLogPath;
/** 获取当前日志的路劲 */
- (NSString *)getCurrentLogPath;
/** 清除日志文件 注意调用删除日志文件的方法后, 要在下次启动才会产生新的日志文件 */
- (BOOL)clearLogFile;
/** 停止所有Log系统, 并清除日志文件 */
- (void)stopLogSystem;

/** 定期上传日志文件 */
- (void)uploadLogFileWithBlock:(LGUploadFileLogBlock)uploadBlock;
- (void)uploadLogFileWithBlock:(LGUploadFileLogBlock)uploadBlock
                 uploadFrequency:(LGLogFrequency)uploadFrequency;

@end
