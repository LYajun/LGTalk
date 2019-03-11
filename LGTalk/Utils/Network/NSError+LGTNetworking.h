//
//  NSError+LGT.h
//
//
//  Created by 刘亚军 on 2017/6/14.
//  Copyright © 2017年 Time. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString * const kLGTLocalErrorDamain = @"_LGTLocalErrorDamain";
NS_ENUM(NSInteger) {
    LGTLocalErrorUnknown = -1,
    
    //User
    LGTLocalErrorTokenExpired = -1001,
    
    //Network
    LGTLocalErrorNoNetwork = -2000,
    LGTLocalErrorApiServerCannotConnect = -2101,
    LGTLocalErrorApiServerTimeout = -2102,
    LGTLocalErrorRequestFailed = -2103,
    LGTLocalErrorUrlEmpty = -2104,
    
    //DataTransform
    LGTLocalErrorCannotParseJSON = -3101,
    LGTLocalErrorCannotParseXML = -3102,
    
    //DataBase
    LGTLocalErrorDataBase = -4000,
    
    //FileSystem
    LGTLocalErrorFileManager = -5001,
    LGTLocalErrorFileNotFound = -5002,
    LGTLocalErrorFileEmpty = -5003,
    
    //Other
    LGTLocalErrorIllegalParameter = -9001,
    LGTLocalErrorValueNull = -9002,
    LGTLocalErrorCanNotUnZip =  -9003
    };

@interface NSError (LGTNetworking)
+ (instancetype)lgt_localErrorWithCode:(NSInteger)code description:(NSString *)description;
@end
