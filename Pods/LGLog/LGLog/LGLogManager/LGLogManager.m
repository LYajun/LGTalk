//
//  LGLogManager.m
//  LGLogDemo
//
//  Created by 刘亚军 on 2018/3/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGLogManager.h"
@interface LGLogManager ()
/** 发送日志到文件 */
@property (nonatomic, strong) DDFileLogger *fileLogger;
/** 日志文件系统是否开启 */
@property (nonatomic, assign) BOOL logFileEnabled;
/** 日志上次同步时间 */
@property (nonatomic, assign) NSTimeInterval lastUploadTimeInterval;
@end
@implementation LGLogManager
+ (instancetype)shareInstence{
    static LGLogManager * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[LGLogManager alloc]init];
        [DDLog addLogger:[DDASLLogger sharedInstance]]; //add log to Apple System Logs
        [DDLog addLogger:[DDTTYLogger sharedInstance]]; //add log to Xcode console
        [DDTTYLogger sharedInstance].logFormatter = [[LGLogFormatter alloc] init];
    });
    macro.lastUploadTimeInterval = [[NSUserDefaults standardUserDefaults] doubleForKey:@"LastUploadTimeInterval"] ? [[NSUserDefaults standardUserDefaults] doubleForKey:@"LastUploadTimeInterval"] : 0;
    return macro;
}
- (instancetype)init{
    if (self = [super init]) {}
    return self;
}
- (void)startFileLogSystem{
    self.logFileEnabled = YES;
    self.fileLogger = [[DDFileLogger alloc] init];
    self.fileLogger.rollingFrequency = 60 * 60 * 24 * 7;
//    self.fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
//    self.fileLogger.maximumFileSize = 1024 * 1024 * 2;
    self.fileLogger.logFormatter = [[LGLogFormatter alloc] init];
    [DDLog addLogger:self.fileLogger];
}
- (void)startFileLogSystemWithDirectory:(NSString *)direct freshLogFrequency:(LGLogFrequency)freshLogFrequency{
    self.logFileEnabled = YES;
    DDLogFileManagerDefault *logFileManager = \
    [[DDLogFileManagerDefault alloc] initWithLogsDirectory:direct];
    self.fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
    CGFloat logFreshTimer;
    switch (freshLogFrequency) {
        case LGLogFrequencyYear:
            logFreshTimer = 60 * 60 * 24 * 365;
            break;
        case LGLogFrequencyMonth:
            logFreshTimer = 60 * 60 * 24 * 30;
            break;
        case LGLogFrequencyWeek:
            logFreshTimer = 60 * 60 * 24 * 7;
            break;
        case LGLogFrequencyDay:
            logFreshTimer = 60 * 60 * 24;
            break;
        default:
            logFreshTimer = 60 * 60 * 24 * 7;
            break;
    }
    self.fileLogger.rollingFrequency = logFreshTimer;
    [DDLog addLogger:self.fileLogger];
}
- (NSString *)getCurrentLogPath{
    if (self.logFileEnabled && self.fileLogger) {
        return self.fileLogger.currentLogFileInfo.filePath;
    } else {
        return @"";
    }
}
- (NSArray*)getLogPath
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * logPath = [docPath stringByAppendingPathComponent:@"Caches"];
    logPath = [logPath stringByAppendingPathComponent:@"Logs"];
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSError * error = nil;
    NSArray * fileList = [[NSArray alloc]init];
    fileList = [fileManger contentsOfDirectoryAtPath:logPath error:&error];
    NSMutableArray * listArray = [[NSMutableArray alloc]init];
    for (NSString * oneLogPath in fileList)
    {
        //带有工程名前缀的路径才是我们存储的日志路径
        if([oneLogPath hasPrefix:[NSBundle mainBundle].bundleIdentifier])
        {
            NSString * truePath = [logPath stringByAppendingPathComponent:oneLogPath];
            [listArray addObject:truePath];
        }
    }
    return listArray;
}

- (BOOL)clearLogFile{
    if ([self getCurrentLogPath].length > 1) {
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[self getCurrentLogPath] error:&error];
        if (!error) {
            return true;
        } else {
            return false;
        }
    }
    return true;
}
- (void)stopLogSystem{
     [self clearLogFile];
    self.logFileEnabled = NO;
     [DDLog removeAllLoggers];
}

- (void)uploadLogFileWithBlock:(LGUploadFileLogBlock)uploadBlock{
    if ([self getCurrentLogPath].length > 1 && self.logFileEnabled) {
        uploadBlock([self getCurrentLogPath]);
    }
}
- (void)uploadLogFileWithBlock:(LGUploadFileLogBlock)uploadBlock uploadFrequency:(LGLogFrequency)uploadFrequency{
    if (self.logFileEnabled) {
        if (!self.lastUploadTimeInterval) {
            //获取当前的时间戳
            self.lastUploadTimeInterval = [[NSDate date] timeIntervalSince1970];
            //存储时间戳
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setDouble:self.lastUploadTimeInterval forKey:@"LastUploadTimeInterval"];
        }
        NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
        NSInteger days;
        switch (uploadFrequency) {
            case LGLogFrequencyYear:
                days = 365;
                break;
            case LGLogFrequencyMonth:
                days = 30;
                break;
            case LGLogFrequencyWeek:
                days = 7;
                break;
            case LGLogFrequencyDay:
                days = 1;
                break;
            default:
                break;
        }
        
        if (currentTimeInterval - self.lastUploadTimeInterval > 60 * 60 * 24 * days) {
            [self uploadLogFileWithBlock:uploadBlock];
        }
    }
}
@end
