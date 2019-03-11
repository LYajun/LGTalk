//
//  LGTBaseService.h
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGTBaseModel.h"


@class LGTBaseViewController;
@interface LGTBaseService : NSObject
/** 知识点编码 */
@property (nonatomic,copy) NSString *klgCode;
@property (nonatomic,copy) NSString *reqUrl;
/** 数据对象 */
@property (nonatomic,strong) LGTBaseModel *model;
/** 所属的控制器 */
@property (weak, nonatomic) LGTBaseViewController *ownController;

- (instancetype)initWithOwnController:(LGTBaseViewController *)ownController;
/** 请求数据 */
- (void)loadDataWithSuccess:(void(^)(BOOL noData))success
                     failed:(void(^)(NSError *error))failed;
/** 处理Json数据 */
- (void)handleJsonModel:(NSDictionary *) jsonModel
             modelClass:(Class)modelClass
                success:(void(^)(BOOL noData))success;
@end
