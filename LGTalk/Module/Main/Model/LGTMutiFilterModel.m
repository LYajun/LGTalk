//
//  LGTMutiFilterModel.m
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/11/27.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTMutiFilterModel.h"
@implementation LGTTraditionMaterialChapterTextModel

@end

@implementation LGTTraditionMaterialChapterModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"textTitle":[LGTTraditionMaterialChapterTextModel class]};
}
@end


@implementation LGTMutiFilterSubModel


@end

@implementation LGTMutiFilterModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"TeachMaterilaAllDatas":[LGTMutiFilterSubModel class],
             @"chapterList":[LGTTraditionMaterialChapterModel class]
             };
}
@end
