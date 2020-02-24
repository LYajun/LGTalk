//
//  LGTBaseTableService.m
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGTBaseTableService.h"

@implementation LGTBaseTableService
- (instancetype)initWithOwnController:(UIViewController *)ownController{
    if (self = [super init]) {
        self.ownController = ownController;
         [self setDefaultValue];
    }
    return self;
}
- (void)setDefaultValue{
    _models = [NSMutableArray array];
    _startPage = 1;
    _pageSize = 10;
    _updateIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}
- (void)removeAllData{
    [self.models removeAllObjects];
}
- (void)addDataModel:(id)model{
    [self.models addObject:model];
}
- (void)addDataModels:(NSArray *)models{
    [self.models addObjectsFromArray:models];
}
- (BOOL)isRefresh{
    return self.currentPage == self.startPage;
}
- (void)updateDataWithPage:(NSInteger)page success:(void (^)(BOOL))success failed:(void (^)(NSError *))failed{
    // This method is for override
}

- (void)handleResponseDataList:(NSArray *)dataList modelClass:(Class)modelClass totalCount:(NSInteger)totalCount success:(void (^)(BOOL))success{
    if (LGT_IsArrEmpty(dataList)) {
        self.noMoreData = YES;
        self.totalCount = 0;
    }else{
        if (totalCount > 0) {
            self.noMoreData = (self.pageSize * (self.currentPage - self.startPage) + dataList.count) >= totalCount;
        }else{
            self.noMoreData = (self.pageSize <= 0) || (dataList.count < self.pageSize);
        }
        NSMutableArray *modelList = [NSMutableArray array];
        for (NSDictionary *dict in dataList) {
            LGTBaseModel *model = [[modelClass alloc]initWithDictionary:dict];
            [modelList addObject:model];
        }
        if ([self isRefresh]) {
            [self removeAllData];
        }
        [self.models addObjectsFromArray:modelList];
        if (totalCount > 0) {
            self.totalCount = totalCount;
        }else{
            self.totalCount = self.models.count;
        }
    }
    
    if (success) {
        success(self.noMoreData);
    }
}

- (NSArray *)mutiFilterTitleArray{
    return @[];
}
- (NSArray *)mutiFilterNameArray{
    return @[];
}
- (NSArray *)mutiFilterIDArray{
    return @[];
}
@end
