//
//  LGTNetworking.m
//
//
//  Created by 刘亚军 on 2019/1/10.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTNetworking.h"
#import "LGTConst.h"
#import "LGTExtension.h"
#import <AFNetworking/AFNetworking.h>
#import "LGTalkManager.h"
@implementation LGTUploadModel

@end
static NSString *LGTNetStatus = @"LGTNetStatus";
@interface LGTNetworking ()
@property (nonatomic,copy) NSString * url;
@property (nonatomic,assign) LGTRequestType wRequestType;
@property (nonatomic,assign) LGTResponseType wResponseType;
@property (nonatomic,copy) NSDictionary *parameters;
@property (nonatomic,copy) NSDictionary * wHTTPHeader;
@property (nonatomic,strong) LGTUploadModel *uploadModel;
@property (nonatomic,assign) NSTimeInterval timeout;
@property (nonatomic,strong) NSMutableArray *dataTaskkArr;
@end
@implementation LGTNetworking
+ (LGTNetworking *)shareNetworking{
    static LGTNetworking * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[LGTNetworking alloc]init];
        [macro replace];
    });
    return macro;
}
- (void)netMonitoring{
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:2 forKey:LGTNetStatus];
    [userDefaults synchronize];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"使用手机网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"使用WIFI");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            default:
                break;
        }
        //        [userDefaults setInteger:status forKey:netStatus];
        //        [userDefaults synchronize];
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
- (void)cancelAllRequest{
    for (NSURLSessionDataTask *dataTask in self.dataTaskkArr) {
        [dataTask cancel];
    }
    [self.dataTaskkArr removeAllObjects];
}

- (void)startRequestWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self startRequestWithProgress:nil success:success failure:failure];
}

- (void)startRequestWithProgress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure{
     NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    if ([[userDefaults objectForKey:LGTNetStatus] integerValue] <= 0) {
        failure([NSError lgt_localErrorWithCode:LGTLocalErrorNoNetwork description:@"当前无网络连接"]);
    }else{
        [self _startRequestWithProgress:progress success:success failure:failure];
    }
}

- (void)_startRequestWithProgress:(void(^)(NSProgress * progress))progress success:(void(^)(id response))success failure:(void (^)(NSError * error))failure{
    if (LGT_IsStrEmpty(self.url)) {
        failure([NSError lgt_localErrorWithCode:LGTLocalErrorUrlEmpty description:@"资源地址为空"]);
    }else{
        switch (self.wRequestType) {
            case LGTRequestTypeGET:
                [self getRequestWithSuccess:success failure:failure];
                break;
            case LGTRequestTypePOST:
                [self postRequestWithSuccess:success failure:failure];
                break;
            case LGTRequestTypeUploadPhoto:
                [self uploadPhotoWithProgress:progress success:success failure:failure];
                break;
            case LGTRequestTypeMD5GET:
                [self md5GetRequestWithSuccess:success failure:failure];
                break;
            case LGTRequestTypeMD5POST:
                [self md5PostRequestWithSuccess:success failure:failure];
                break;
            default:
                break;
        }
    }
    [self replace];
}

#pragma mark - Private
- (void)uploadPhotoWithProgress:(void(^)(NSProgress * progress))progress success:(void(^)(id response))success failure:(void (^)(NSError * error))failure{
    WeakSelf;
    [[AFHTTPSessionManager manager] POST:self.url parameters:self.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < selfWeak.uploadModel.uploadDatas.count; i++) {
            NSData *imageData = selfWeak.uploadModel.uploadDatas[i];
            NSString *imageName = selfWeak.uploadModel.fileNames[i];
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"%@%i",selfWeak.uploadModel.name,i] fileName:imageName mimeType:selfWeak.uploadModel.fileType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progress(uploadProgress);
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            success(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}
- (void)getRequestWithSuccess:(void(^)(id response))success failure:(void (^)(NSError * error))failure{
    NSString *urlStr = self.url;
    if (self.parameters) {
        urlStr = [NSString stringWithFormat:@"%@?%@",urlStr,self.parameterStr];
    }
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *requestUrl = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    request.timeoutInterval = self.timeout;
    NSURLSession *session = [NSURLSession sharedSession];
    LGTResponseType responseType = self.wResponseType;
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failure(error);
            }else{
                success([weakSelf responseResultWithData:data responseType:responseType]);
            }
        });
    }];
    [dataTask resume];
    [self.dataTaskkArr addObject:dataTask];
}

- (void)postRequestWithSuccess:(void(^)(id response))success failure:(void (^)(NSError * error))failure{
    NSString *urlStr = [self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *requestUrl = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = self.timeout;
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:self.parameters options:NSJSONWritingPrettyPrinted error:NULL];
    NSURLSession *session = [NSURLSession sharedSession];
    LGTResponseType responseType = self.wResponseType;
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failure(error);
            }else{
                success([weakSelf responseResultWithData:data responseType:responseType]);
            }
        });
    }];
    [dataTask resume];
    [self.dataTaskkArr addObject:dataTask];
}
- (void)md5GetRequestWithSuccess:(void(^)(id response))success failure:(void (^)(NSError * error))failure{
    NSString *urlStr = self.url;
    NSString *dataStr = @"";
    if (self.parameters) {
        dataStr = [NSString lgt_encryptWithKey:[LGTalkManager defaultManager].userID encryptDic:self.parameters];
    }
    NSString *stampStr = self.currentServiceTimeStamp;
     NSString *signMd5String = [NSString stringWithFormat:@"%@%@%@",[LGTalkManager defaultManager].userID,stampStr,dataStr];
    NSString *sign = [NSString lgt_md5EncryptStr:signMd5String];
    
    urlStr = [NSString stringWithFormat:@"%@?privateKey=%@&timeStamp=%@&sign=%@&data=%@",urlStr,[LGTalkManager defaultManager].userID,stampStr,sign,dataStr];
    NSURL *requestUrl = [NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    request.timeoutInterval = self.timeout;
    
    NSURLSession *session = [NSURLSession sharedSession];
    LGTResponseType responseType = self.wResponseType;
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failure(error);
            }else{
                success([weakSelf responseResultWithData:data responseType:responseType]);
            }
        });
    }];
    [dataTask resume];
    [self.dataTaskkArr addObject:dataTask];
}
- (void)md5PostRequestWithSuccess:(void(^)(id response))success failure:(void (^)(NSError * error))failure{
    NSString *urlStr = self.url;
    NSString *dataStr = @"";
    if (self.parameters) {
        dataStr = [NSString lgt_encryptWithKey:[LGTalkManager defaultManager].userID encryptDic:self.parameters];
    }
    NSString *stampStr = self.currentServiceTimeStamp;
    NSString *signMd5String = [NSString stringWithFormat:@"%@%@%@",[LGTalkManager defaultManager].userID,stampStr,dataStr];
    NSString *sign = [NSString lgt_md5EncryptStr:signMd5String];
    
    NSString *bodyStr = [NSString stringWithFormat:@"privateKey=%@&timeStamp=%@&sign=%@&data=%@",[LGTalkManager defaultManager].userID,stampStr,sign,dataStr];
    
    NSURL *requestUrl = [NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    
    request.HTTPMethod = @"POST";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = self.timeout;

    request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    LGTResponseType responseType = self.wResponseType;
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failure(error);
            }else{
                success([weakSelf responseResultWithData:data responseType:responseType]);
            }
        });
    }];
    [dataTask resume];
    [self.dataTaskkArr addObject:dataTask];
}
- (id)responseResultWithData:(NSData *)data responseType:(LGTResponseType)type{
    switch (type) {
        case LGTResponseTypeJSON:
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            return json;
        }
            break;
        case LGTResponseTypeModel:
        {
            LGTResponseModel *model = [LGTResponseModel responseModelWithData:data];
            return model;
        }
            break;
        case LGTResponseTypeString:
        {
            NSData *xmldata = [data subdataWithRange:NSMakeRange(0,40)];
            NSString *xmlstr = [[NSString alloc] initWithData:xmldata encoding:NSUTF8StringEncoding];
            NSData *newData = data;
            if (xmlstr && xmlstr.length > 0 && [xmlstr rangeOfString:@"\"GB2312\"" options:NSCaseInsensitiveSearch].location != NSNotFound){
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                NSString *utf8str = [[NSString alloc] initWithData:newData encoding:enc];
                utf8str = [utf8str stringByReplacingOccurrencesOfString:@"\"GB2312\"" withString:@"\"utf-8\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,40)];
                newData = [utf8str dataUsingEncoding:NSUTF8StringEncoding];
            }
            NSString *str = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
            if (!str || str.length == 0) {
                str = [[NSString alloc] initWithData:newData encoding:NSUnicodeStringEncoding];
            }
            return str;
        }
            break;
        case LGTResponseTypeData:
            return data;
            break;
    }
}
- (NSString *)parameterStr{
    if (self.parameters && self.parameters.count > 0) {
        NSString *str = @"";
        for (NSString *key in self.parameters.allKeys) {
            if (str.length == 0) {
                str = [NSString stringWithFormat:@"%@=%@",key,[self.parameters objectForKey:key]];
            }else{
                str = [str stringByAppendingFormat:@"&%@=%@",key,[self.parameters objectForKey:key]];
            }
        }
        return str;
    }
    return @"";
}
- (void)replace {
    _url = nil;
    _wRequestType = LGTRequestTypeGET;
    _wResponseType = LGTResponseTypeJSON;
    _parameters = nil;
    _wHTTPHeader = nil;
    _uploadModel = nil;
    _timeout = 15;
}
#pragma mark - getter

- (NSString *)currentServiceTimeStamp{
     NSTimeInterval currentDateInterval = [self.currentServiceTimeString.lgt_date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.f",currentDateInterval*1000];
}
- (NSString *)currentServiceTimeString{
    NSDate *currentServiceDate = [[NSDate date] dateByAddingTimeInterval:self.timeInteverval];
    NSString *currentServiceStr = currentServiceDate.lgt_string;
    return currentServiceStr;
}
- (NSMutableArray *)dataTaskkArr{
    if (!_dataTaskkArr) {
        _dataTaskkArr = [NSMutableArray array];
    }
    return _dataTaskkArr;
}
- (LGTNetworking *(^)(NSTimeInterval))setTimeoutInterval{
    return ^LGTNetworking *(NSTimeInterval timeoutInterval){
        self.timeout = timeoutInterval;
        return self;
    };
}
- (LGTNetworking *(^)(LGTUploadModel *))setUploadModel{
    return ^LGTNetworking * (LGTUploadModel *uploadModel) {
        self.uploadModel = uploadModel;
        return self;
    };
}
- (LGTNetworking *(^)(NSString *))setRequest{
    return ^LGTNetworking* (NSString * url) {
        self.url = url;
        return self;
    };
}
- (LGTNetworking *(^)(LGTRequestType))setRequestType{
    return ^LGTNetworking* (LGTRequestType type) {
        self.wRequestType = type;
        return self;
    };
}
- (LGTNetworking *(^)(LGTResponseType))setResponseType{
    return ^LGTNetworking* (LGTResponseType type) {
        self.wResponseType = type;
        return self;
    };
}
- (LGTNetworking *(^)(NSDictionary *))setParameters{
    return ^LGTNetworking* (NSDictionary *parameters) {
        self.parameters = parameters;
        return self;
    };
}
- (LGTNetworking *(^)(NSDictionary *))setHTTPHeader{
    return ^LGTNetworking* (NSDictionary *HTTPHeaderDic) {
        self.wHTTPHeader = HTTPHeaderDic;
        return self;
    };
}

@end
