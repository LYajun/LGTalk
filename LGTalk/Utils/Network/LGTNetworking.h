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
    LGTRequestTypeMD5GET,
    LGTRequestTypeMD5POST,
};
typedef NS_ENUM(NSInteger,LGTResponseType){
    LGTResponseTypeJSON,
    LGTResponseTypeModel,
    LGTResponseTypeString,
    LGTResponseTypeData,
};


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



/** 断开网络 */
- (void)cancelAllRequest;

- (void)startRequestWithSuccess:(void(^)(id response))success
                        failure:(void (^)(NSError * error))failure;

- (void)startRequestWithProgress:(void(^)(NSProgress * progress))progress
                         success:(void(^)(id response))success
                         failure:(void (^)(NSError * error))failure;


@end
