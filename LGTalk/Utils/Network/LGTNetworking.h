//
//  LGTNetworking.h
//  
//
//  Created by 刘亚军 on 2019/1/10.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGTResponseModel.h"
#import "NSError+LGTNetworking.h"


#define LGTNet [LGTNetworking shareNetworking]
typedef NS_ENUM(NSInteger,LGTRequestType){
    LGTRequestTypeGET,
    LGTRequestTypePOST,
    LGTRequestTypeUploadPhoto,
    LGTRequestTypeMD5GET,
    LGTRequestTypeMD5POST,
};
typedef NS_ENUM(NSInteger,LGTResponseType){
    LGTResponseTypeJSON,
    LGTResponseTypeModel,
    LGTResponseTypeString,
    LGTResponseTypeData,
};

@interface LGTUploadModel : NSObject
/** 数据流 */
@property (nonatomic,strong) NSArray *uploadDatas;
/** //给定数据流的数据名 */
@property (nonatomic,strong) NSString *name;
/** 文件名 */
@property (nonatomic,strong) NSArray *fileNames;
/** 文件类型 常用数据流类型：
 1、"image/png" 图片
 2、“video/quicktime” 视频流
 */
@property (nonatomic,strong) NSString *fileType;
@end


@interface LGTNetworking : NSObject
+ (LGTNetworking *)shareNetworking;

@property (nonatomic,copy) NSString *apiUrl;
@property (nonatomic,copy) NSString *apiUrl_Enter;
/** 时间差：服务器时间相比设备当前时间 */
@property (assign, nonatomic) NSTimeInterval timeInteverval;
- (NSString *)currentServiceTimeString;

/** 填充网址 */
- (LGTNetworking* (^)(NSString * url))setRequest;

/** 设置网络请求时间 */
- (LGTNetworking *(^)(NSTimeInterval timeoutInterval))setTimeoutInterval;

/** 请求类型，默认为GET */
- (LGTNetworking* (^)(LGTRequestType type))setRequestType;

/** 响应类型，默认为GET */
- (LGTNetworking* (^)(LGTResponseType type))setResponseType;

/** 填充参数 */
- (LGTNetworking* (^)(NSDictionary *parameters))setParameters;

/** 填充请求头 */
- (LGTNetworking* (^)(NSDictionary * HTTPHeaderDic))setHTTPHeader;
/** 上传文件模型 */
- (LGTNetworking* (^)(LGTUploadModel *uploadModel))setUploadModel;

/** 网络监控 */
- (void)netMonitoring;
/** 断开网络 */
- (void)cancelAllRequest;

- (void)startRequestWithSuccess:(void(^)(id response))success
                        failure:(void (^)(NSError * error))failure;

- (void)startRequestWithProgress:(void(^)(NSProgress * progress))progress
                         success:(void(^)(id response))success
                         failure:(void (^)(NSError * error))failure;


@end
