//
//  LGTResponseModel.m
//
//
//  Created by 刘亚军 on 2019/1/10.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTResponseModel.h"
#import <MJExtension/MJExtension.h>
#import <XMLDictionary/XMLDictionary.h>


@implementation LGTResponseModel
+ (LGTResponseModel *)responseModelWithData:(NSData *)data{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    LGTResponseModel *model = [self mj_objectWithKeyValues:dic];
    return model;
}
@end
