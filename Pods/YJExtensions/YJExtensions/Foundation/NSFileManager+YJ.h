//
//  NSFileManager+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (YJ)
+ (NSURL *)yj_documentsURL;

+ (NSString *)yj_documentsPath;

+ (NSURL *)yj_libraryURL;

+ (NSString *)yj_libraryPath;

+ (NSURL *)yj_cachesURL;

+ (NSString *)yj_cachesPath;

+ (BOOL)yj_addSkipBackupAttributeToFile:(NSString *)path;

+ (double)yj_availableDiskSpace;

/** 判断文件是否存在于某个路径中 */
+ (BOOL)yj_fileIsExistOfPath:(NSString *)filePath;

/** 从某个路径中移除文件 */
+ (BOOL)yj_removeFileOfPath:(NSString *)filePath;

/** 创建文件夹 */
+ (BOOL)yj_creatDirectoryWithPath:(NSString *)dirPath;

/** 创建文件 */
+ (BOOL)yj_creatFileWithPath:(NSString *)filePath;

/** 保存文件 */
+ (BOOL)yj_saveFile:(NSString *)filePath withData:(NSData *)data;

/** 追加写文件 */
+ (BOOL)yj_appendData:(NSData *)data withPath:(NSString *)path;

/** 获取文件 */
+ (NSData *)yj_getFileData:(NSString *)filePath;

/** 获取指定文件 */
+ (NSData *)yj_getFileData:(NSString *)filePath startIndex:(long long)startIndex length:(NSInteger)length;

/** 移动文件 */
+ (BOOL)yj_moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

/** 拷贝文件 */
+ (BOOL)yj_copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

/** 获取文件夹下文件列表 */
+ (NSArray *)yj_getFileListInFolderWithPath:(NSString *)path;

/** 获取文件大小 */
+ (long long)yj_getFileSizeWithPath:(NSString *)path;

+ (NSString *)yj_sizeStringBy:(NSInteger)size;
@end

NS_ASSUME_NONNULL_END
