//
//  YJUploadModel.h
//  YJNetManagerDemo
//
//  Created by 刘亚军 on 2019/3/18.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJUploadModel : NSObject
/** 数据流 */
@property (nonatomic,strong) NSArray *uploadDatas;
/** 给定数据流的数据名 */
@property (nonatomic,strong) NSString *name;
/** 文件名 */
@property (nonatomic,strong) NSArray *fileNames;
/** 文件类型 常用数据流类型：
 1、"image/png" 图片
 2、“video/quicktime” 视频流
 */
@property (nonatomic,strong) NSString *fileType;
@end

NS_ASSUME_NONNULL_END
