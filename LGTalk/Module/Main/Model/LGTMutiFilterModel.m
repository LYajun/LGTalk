//
//  LGTMutiFilterModel.m
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/11/27.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTMutiFilterModel.h"

@implementation LGTMutiFilterSubModel


@end

@implementation LGTMutiFilterModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"TeachMaterilaAllDatas":[LGTMutiFilterSubModel class]};
}
@end
