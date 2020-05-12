//
//  YJNetManager.h
//  YJNetManagerDemo
//
//  Created by 刘亚军 on 2019/3/16.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJUploadModel.h"
#import "NSError+YJNetManager.h"
#import "YJNetMonitoring.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,YJRequestType){
    YJRequestTypeGET,
    YJRequestTypePOST,
    YJRequestTypeTxt,
    YJRequestTypeUpload,
    YJRequestTypeMD5GET,
    YJRequestTypeMD5POST,
};
typedef NS_ENUM(NSInteger,YJResponseType){
    YJResponseTypeJSON,
    YJResponseTypeString,
    YJResponseTypeData,
};
@interface YJNetManager : NSObject

/** 时间差：服务器时间相比设备当前时间 */
@property (assign, nonatomic) NSTimeInterval serverTimeInteverval;
/** 用户ID */
@property (nonatomic,copy) NSString *userID;
/** 用户token */
@property (nonatomic,copy) NSString *token;

@property (nonatomic,copy,readonly) NSDictionary *wParameters;


+ (YJNetManager *)defaultManager;
+ (YJNetManager *)createManager;
- (void)cancelRequest;
/** 填充网址 */
- (YJNetManager* (^)(NSString *url))setRequest;

/** 设置网络请求时间 */
- (YJNetManager *(^)(NSTimeInterval timeoutInterval))setTimeoutInterval;

/** 请求类型，默认为GET */
- (YJNetManager* (^)(YJRequestType type))setRequestType;

/** 响应类型，默认为GET */
- (YJNetManager* (^)(YJResponseType type))setResponseType;

/** 填充参数 */
- (YJNetManager* (^)(NSDictionary *parameters))setParameters;

/** 填充请求头 */
- (YJNetManager* (^)(NSDictionary *HTTPHeaderDic))setHTTPHeader;

/** 上传文件模型 */
- (YJNetManager* (^)(YJUploadModel *uploadModel))setUploadModel;

/** 缓存文件夹路径 */
- (NSString *)cachePath;

- (void)startRequestWithSuccess:(void(^)(id response))success
                        failure:(void (^)(NSError * error))failure;

- (void)startRequestWithProgress:(nullable void(^)(NSProgress * progress))progress
                            success:(void(^)(id _Nullable response))success
                            failure:(void (^)(NSError * _Nullable error))failure;

- (void)downloadCacheFileWithSuccess:(void(^)(id _Nullable response))success
                         failure:(void (^)(NSError * _Nullable error))failure;


- (NSString *)currentServiceTimeStamp;

- (NSMutableURLRequest *)exerciseMd5GetReqWithUrl:(NSString *)url;
- (NSMutableURLRequest *)exerciseMd5PostReqWithUrl:(NSString *)url;
- (NSDictionary *)exerciseMd5ParamsWithMd5Str:(NSString *)md5Str;
@end

NS_ASSUME_NONNULL_END
