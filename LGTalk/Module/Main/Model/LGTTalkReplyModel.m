//
//  LGTTalkReplyModel.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/11/2.
//  Copyright © 2017年 lange. All rights reserved.
//

#import "LGTTalkReplyModel.h"

@implementation LGTTalkReplyModel
- (NSString *)UserType{
    if (!_UserType) {
        return @"2";
    }
    return _UserType;
}
- (NSString *)UserTypeTo{
    if (!_UserTypeTo) {
        return @"2";
    }
    return _UserTypeTo;
}
@end
