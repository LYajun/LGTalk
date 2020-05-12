//
//  LGTBaseService.m
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGTBaseService.h"


@implementation LGTBaseService
- (instancetype)initWithOwnController:(LGTBaseViewController *)ownController{
    if (self = [super init]) {
        self.ownController = ownController;
    }
    return self;
}
- (void)loadDataWithSuccess:(void (^)(BOOL))success failed:(void (^)(NSError *))failed{
    // This method is for override
}
- (void)handleJsonModel:(NSDictionary *)jsonModel modelClass:(Class)modelClass success:(void (^)(BOOL))success{
    BOOL noMoreData = NO;
    if (LGT_IsObjEmpty(jsonModel) || jsonModel.count == 0) {
        noMoreData = YES;
    }else{
        self.model = [[modelClass alloc] initWithDictionary:jsonModel];
    }
    if (success) {
        success(noMoreData);
    }
}
@end
