 //
//  NSError+LGT.m
//
//
//  Created by 刘亚军 on 2017/6/14.
//  Copyright © 2017年 Time. All rights reserved.
//

#import "NSError+LGTNetworking.h"

@implementation NSError (LGTNetworking)
+ (instancetype)lgt_localErrorWithCode:(NSInteger)code description:(NSString *)description{
    if (!description || description.length == 0) {
        description = @"发生错误";
    }
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:description};
    NSError *error = [NSError errorWithDomain:kLGTLocalErrorDamain code:code userInfo:userInfo];
    return error;
}
@end
