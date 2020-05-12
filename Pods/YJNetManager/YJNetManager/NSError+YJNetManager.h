//
//  NSError+YJNetManager.h
//
//
//  Created by 刘亚军 on 2017/6/14.
//  Copyright © 2017年 Time. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString * const kYJNetManagerErrorDamain = @"_YJNetManagerErrorDamain";
NS_ENUM(NSInteger) {
    YJErrorUnknown = -1,
    
    //User
    YJErrorTokenExpired = -1001,
    
    //Network
    YJErrorNoNetwork = -2000,
    YJErrorApiServerCannotConnect = -2101,
    YJErrorApiServerTimeout = -2102,
    YJErrorRequestFailed = -2103,
    YJErrorUrlEmpty = -2104,
    
    //DataTransform
    YJErrorCannotParseJSON = -3101,
    YJErrorCannotParseXML = -3102,
    
    YJErrorIllegalParameter = -4001,
    YJErrorValueNull = -4002,
};

@interface NSError (YJNetManager)
+ (instancetype)yj_errorWithCode:(NSInteger)code description:(NSString *)description;
@end
