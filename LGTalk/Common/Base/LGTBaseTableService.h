//
//  LGTBaseTableService.h
//  
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LGTBaseModel.h"

@interface LGTBaseTableService : NSObject

@property (nonatomic,copy) NSString *resID;

/** 所属的控制器 */
@property (weak, nonatomic) UIViewController *ownController;
/** 表格 当前页码 */
@property (nonatomic,assign) NSInteger currentPage;
/** 表格 起始页码 */
@property (nonatomic,assign) NSInteger startPage;
/** 表格 每页数据量 */
@property (nonatomic,assign) NSInteger pageSize;
/** 表格 总数 */
@property (nonatomic,assign) NSInteger totalCount;
/** 刷新数据索引 */
@property (nonatomic,strong) NSIndexPath *updateIndexPath;
/** 表格 模型数组 */
@property (nonatomic,strong,readonly) NSMutableArray *models;
/** 是否没有更多数据了 */
@property (assign, nonatomic) BOOL noMoreData;


/** 表格 数据列表清空 */
- (void)removeAllData;
/** 表格 添加单个数据 */
- (void)addDataModel:(id) model;
/** 表格 添加多个数据 */
- (void)addDataModels:(NSArray *) models;
/** 表格 是否需要清空刷新 */
- (BOOL)isRefresh;

- (instancetype)initWithOwnController:(UIViewController *)ownController;
/**
 *  更新数据 带有错误回调
 *
 *  @param page       页码
 *  @param success    成功后回调
 *  @param failed     失败后回调
 */
- (void)updateDataWithPage:(NSInteger)page success:(void(^)(BOOL noMore))success failed:(void(^)(NSError *error))failed;

/**
 *  处理接口返回数据，将字典转为模型
 *
 *  @param dataList   接口返回的数据数组
 *  @param modelClass 目标模型的Class
 *  @param totalCount 接口返回的数据总量(0：未知数，>0:已知数)
 *  @param success    成功回调，noMore表示分页数据是否还有更多
 */
- (void)handleResponseDataList:(NSArray *)dataList modelClass:(Class)modelClass totalCount:(NSInteger)totalCount success:(void(^)(BOOL noMore))success;

/** 教材筛选信息 */
- (NSArray *)mutiFilterTitleArray;
- (NSArray *)mutiFilterNameArray;
- (NSArray *)mutiFilterIDArray;

@end
