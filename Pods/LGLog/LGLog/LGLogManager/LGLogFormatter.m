//
//  LGLogFormatter.m
//  LGLogDemo
//
//  Created by 刘亚军 on 2018/3/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//
#import "LGLogFormatter.h"
@interface LGLogFormatter (){
    NSInteger wLoggerCount;
    NSDateFormatter *wThreadUnsafeDateFormatter;
}
@end
@implementation LGLogFormatter
- (instancetype)init{
    if (self = [super init]) {
        wThreadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
        [wThreadUnsafeDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return self;
}
#pragma mark LGLogFormatter协议方法
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage{
     NSString *logLevel;
    switch (logMessage.flag) {
        case DDLogFlagError:
            logLevel = @"[ERROR]->";
            break;
        case DDLogFlagWarning:
            logLevel = @"[WARN]-->";
            break;
        case DDLogFlagInfo:
            logLevel = @"[INFO]--->";
            break;
        case DDLogFlagDebug:
            logLevel = @"[DEBUG]---->";
            break;
        case DDLogFlagVerbose:
            logLevel = @"[VBOSE]----->";
            break;
        default:
            logLevel = @"[Default]----->";
            break;
    }
    NSString *dateAndTime = [wThreadUnsafeDateFormatter stringFromDate:(logMessage.timestamp)];
    NSString *logMsg = logMessage.message;
    NSString *fileName = logMessage.fileName;
    NSString *function = logMessage.function;
    NSInteger line = logMessage.line;
    return [NSString stringWithFormat:@"\n[ %@ %@ ] \n位置: \nfileName:%@\nfunction:%@\nline:%ld \n信息:%@[ %@  %@ ]\n", logLevel, dateAndTime,fileName,function,line, logMsg,logLevel, dateAndTime];
}
- (void)didAddToLogger:(id<DDLogger>)logger{
    wLoggerCount++;
    NSAssert(wLoggerCount <= 1, @"This logger isn't thread-safe");
}
- (void)willRemoveFromLogger:(id<DDLogger>)logger{
    wLoggerCount--;
}
@end
