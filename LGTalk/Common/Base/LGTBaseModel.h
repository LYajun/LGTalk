//
//  LGTBaseModel.h
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGTConst.h"

@interface LGTBaseModel : NSObject<NSMutableCopying>
/** 用字典初始化（MJExtension） */
- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

/** 用JSONString初始化 */
- (instancetype)initWithJSONString:(NSString *)aJSONString;
- (NSDictionary *)lgt_JsonModel;
@end
