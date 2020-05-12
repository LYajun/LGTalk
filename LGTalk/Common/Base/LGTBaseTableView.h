//
//  LGTBaseTableView.h
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGTBaseTableService.h"

@interface LGTBaseTableView : UITableView
@property (strong, nonatomic) LGTBaseTableService *service;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style ownController:(UIViewController *)ownController serviceName:(NSString *)serviceName;

@property (nonatomic,strong) void (^TotalCountBlock) (NSInteger count);

/** 设置默认值 */
- (void)setDefaultValue;

/** 加载第一页 */
- (void)loadFirstPage;
- (void)loadFirstPageWithCompletion:(void(^)(BOOL success))completion;

/** 加载下一页 */
- (void)loadNextPage;
- (void)loadNextPageWithCompletion:(void(^)(BOOL success))completion;

/**
 *  为table设置上拉加载和下拉刷新
 *
 *  @param installHeader 是否装载mj_header
 *  @param installFooter 是否装载mj_footer
 */
- (void)installRefreshHeader:(BOOL)installHeader footer:(BOOL)installFooter;
/**
 *  更新数据
 *
 *  @param page 页码 (页码为首页码时，会清空数据并载入首页数据，比如用于下拉刷新；页码不为首页码则更新相应页的数据，比如用于上拉加载)
 */
- (void)updateDataWithPage:(NSInteger)page withCompletion:(void(^)(BOOL success))completion;

@end
