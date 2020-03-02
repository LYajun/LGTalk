//
//  NSFileManager+YJ.m
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "NSFileManager+YJ.h"
#include <sys/xattr.h>
@implementation NSFileManager (YJ)
+ (NSURL *)yj_URLForDirectory:(NSSearchPathDirectory)directory{
    return [self.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (NSString *)yj_pathForDirectory:(NSSearchPathDirectory)directory{
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES)[0];
}

+ (NSURL *)yj_documentsURL{
    return [self yj_URLForDirectory:NSDocumentDirectory];
}

+ (NSString *)yj_documentsPath{
    return [self yj_pathForDirectory:NSDocumentDirectory];
}

+ (NSURL *)yj_libraryURL{
    return [self yj_URLForDirectory:NSLibraryDirectory];
}

+ (NSString *)yj_libraryPath{
    return [self yj_pathForDirectory:NSLibraryDirectory];
}

+ (NSURL *)yj_cachesURL{
    return [self yj_URLForDirectory:NSCachesDirectory];
}

+ (NSString *)yj_cachesPath{
    return [self yj_pathForDirectory:NSCachesDirectory];
}

+ (BOOL)yj_addSkipBackupAttributeToFile:(NSString *)path{
    return [[NSURL.alloc initFileURLWithPath:path] setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
}

+ (double)yj_availableDiskSpace{
    NSDictionary *attributes = [self.defaultManager attributesOfFileSystemForPath:self.yj_documentsPath error:nil];
    
    return [attributes[NSFileSystemFreeSize] unsignedLongLongValue] / (double)0x100000;
}

+ (BOOL)yj_fileIsExistOfPath:(NSString *)filePath{
    BOOL flag = NO;
    if ([self.defaultManager fileExistsAtPath:filePath]) {
        flag = YES;
    } else {
        flag = NO;
    }
    return flag;
}
+ (BOOL)yj_removeFileOfPath:(NSString *)filePath{
    BOOL flag = YES;
    if ([self.defaultManager fileExistsAtPath:filePath]) {
        if (![self.defaultManager removeItemAtPath:filePath error:nil]) {
            flag = NO;
        }
    }
    return flag;
}

+ (BOOL)yj_creatDirectoryWithPath:(NSString *)dirPath{
    BOOL ret = YES;
    BOOL isExist = [self.defaultManager fileExistsAtPath:dirPath];
    if (!isExist) {
        NSError *error;
        BOOL isSuccess = [self.defaultManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!isSuccess) {
            ret = NO;
            NSLog(@"creat Directory Failed. errorInfo:%@",error);
        }
    }
    return ret;
}
+ (BOOL)yj_creatFileWithPath:(NSString *)filePath{
    BOOL isSuccess = YES;
    BOOL temp = [self.defaultManager fileExistsAtPath:filePath];
    if (temp) {
        return YES;
    }
    NSError *error;
    //stringByDeletingLastPathComponent:删除最后一个路径节点
    NSString *dirPath = [filePath stringByDeletingLastPathComponent];
    isSuccess = [self.defaultManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"creat File Failed. errorInfo:%@",error);
    }
    if (!isSuccess) {
        return isSuccess;
    }
    isSuccess = [self.defaultManager createFileAtPath:filePath contents:nil attributes:nil];
    return isSuccess;
}

+ (BOOL)yj_saveFile:(NSString *)filePath withData:(NSData *)data{
    BOOL ret = YES;
    ret = [self yj_creatFileWithPath:filePath];
    if (ret) {
        ret = [data writeToFile:filePath atomically:YES];
        if (!ret) {
            NSLog(@"%s Failed",__FUNCTION__);
        }
    } else {
        NSLog(@"%s Failed",__FUNCTION__);
    }
    return ret;
}

+ (BOOL)yj_appendData:(NSData *)data withPath:(NSString *)path{
    BOOL result = [self yj_creatFileWithPath:path];
    if (result) {
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
        [handle seekToEndOfFile];
        [handle writeData:data];
        [handle synchronizeFile];
        [handle closeFile];
        return YES;
    } else {
        NSLog(@"%s Failed",__FUNCTION__);
        return NO;
    }
}

+ (NSData *)yj_getFileData:(NSString *)filePath{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *fileData = [handle readDataToEndOfFile];
    [handle closeFile];
    return fileData;
}

+ (NSData *)yj_getFileData:(NSString *)filePath startIndex:(long long)startIndex length:(NSInteger)length{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    [handle seekToFileOffset:startIndex];
    NSData *data = [handle readDataOfLength:length];
    [handle closeFile];
    return data;
}

+ (BOOL)yj_moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath{
    if (![self.defaultManager fileExistsAtPath:fromPath]) {
        NSLog(@"Error: fromPath Not Exist");
        return NO;
    }
    if (![self.defaultManager fileExistsAtPath:toPath]) {
        NSLog(@"Error: toPath Not Exist");
        return NO;
    }
    NSString *headerComponent = [toPath stringByDeletingLastPathComponent];
    if ([self yj_creatFileWithPath:headerComponent]) {
        return [self.defaultManager moveItemAtPath:fromPath toPath:toPath error:nil];
    } else {
        return NO;
    }
}

+ (BOOL)yj_copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath{
    if (![self.defaultManager fileExistsAtPath:fromPath]) {
        NSLog(@"Error: fromPath Not Exist");
        return NO;
    }
    if (![self.defaultManager fileExistsAtPath:toPath]) {
        NSLog(@"Error: toPath Not Exist");
        return NO;
    }
    NSString *headerComponent = [toPath stringByDeletingLastPathComponent];
    if ([self yj_creatFileWithPath:headerComponent]) {
        return [self.defaultManager copyItemAtPath:fromPath toPath:toPath error:nil];
    } else {
        return NO;
    }
}

+ (NSArray *)yj_getFileListInFolderWithPath:(NSString *)path{
    NSError *error;
    NSArray *fileList = [self.defaultManager contentsOfDirectoryAtPath:path error:&error];
    if (error) {
        NSLog(@"getFileListInFolderWithPathFailed, errorInfo:%@",error);
    }
    return fileList;
}

+ (long long)yj_getFileSizeWithPath:(NSString *)path{
    unsigned long long fileLength = 0;
    NSNumber *fileSize;
    NSDictionary *fileAttributes = [self.defaultManager attributesOfItemAtPath:path error:nil];
    if ((fileSize = [fileAttributes objectForKey:NSFileSize])) {
        fileLength = [fileSize unsignedLongLongValue];
    }
    return fileLength;
}

+ (NSString *)yj_sizeStringBy:(NSInteger)size{
    if (size > 1024 * 1024) {
        float currentSize = size / 1024.0 / 1024.0;
        return [NSString stringWithFormat:@"%.fM",currentSize];
    }else if (size > 1024){
        float currentSize = size / 1024.0 ;
        return [NSString stringWithFormat:@"%.fKB",currentSize];
    }else{
        return [NSString stringWithFormat:@"%ziB",size];
    }
    
}
@end
