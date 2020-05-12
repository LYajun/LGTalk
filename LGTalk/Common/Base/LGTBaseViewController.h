//
//  LGTBaseViewController.h
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGTBaseService.h"
#import "LGTConst.h"


typedef NS_ENUM(NSUInteger, LGTNavBarLeftItemType) {
    LGTNavBarLeftItemTypeBack,
    LGTNavBarLeftItemTypeMenu
};


@interface LGTBaseViewController : UIViewController
/** 导航栏左侧按钮类型 */
@property (assign, nonatomic) LGTNavBarLeftItemType navBar_leftItemType;
- (void)navBar_leftItemPressed:(UIBarButtonItem *)sender;

/** 数据处理对象 */
@property (nonatomic,strong) LGTBaseService *service;
/** 跑马灯标题 */
@property (copy, nonatomic) NSString *marqueeTitle;
/** 加载视图与顶部的间距 */
@property (nonatomic,assign) CGFloat yj_loadingViewTopSpace;
@property (nonatomic,weak) UIView *aboveView;
/** 空页面 */
- (void)setViewLoadingShow:(BOOL)show;
- (void)setViewNoDataShow:(BOOL)show;
- (void)setViewLoadErrorShow:(BOOL)show;
- (void)loadData;
- (void)updateData;

- (void)loadErrorUpdate;
/** 初始化 */
- (instancetype)initWithServiceName:(NSString *)serviceName;

- (void)setNavBar_rightItemImages:(NSArray *)images;
- (void)setNavBar_rightItemTitles:(NSArray *)titles;
- (void)navBar_rightItemPressed:(UIBarButtonItem *)sender;

@end
