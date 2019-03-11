//
//  LGTBaseTableView.m
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGTBaseTableView.h"
#import <MJRefresh/MJRefresh.h>
#import "LGTBaseViewController.h"
#import <LGAlertHUD/LGAlertHUD.h>

@implementation LGTBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style ownController:(UIViewController *)ownController serviceName:(NSString *)serviceName{
    if (self = [super initWithFrame:frame style:style]) {
        Class ServiceClass = NSClassFromString(serviceName);
        self.service = [[ServiceClass alloc] initWithOwnController:ownController];
        [self setDefaultValue];
    }
    return self;
}
- (void)setDefaultValue{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)installRefreshHeader:(BOOL)installHeader footer:(BOOL)installFooter{
    WeakSelf;
    if (installHeader) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [selfWeak loadFirstPage];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        self.mj_header = header;
    }
    
    if (installFooter) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [selfWeak loadNextPage];
        }];
        // 设置文字
        [footer setTitle:@"上拉加载更多 ..." forState:MJRefreshStateIdle];
        [footer setTitle:@"正在拼命加载 ..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"已全部加载" forState:MJRefreshStateNoMoreData];
        // 设置字体
        footer.stateLabel.font = [UIFont systemFontOfSize:15];
        // 设置颜色
        footer.stateLabel.textColor = [UIColor darkGrayColor];
     
        self.mj_footer = footer;
    }
}
- (void)updateDataWithPage:(NSInteger)page withCompletion:(void (^)(BOOL))completion{
    if (page == self.service.startPage) {
        [self.service removeAllData];
        [self reloadData];
        [(LGTBaseViewController *)self.service.ownController setViewLoadingShow:YES];
    }
    WeakSelf;
    [self.service updateDataWithPage:page success:^(BOOL noMore) {
        [(LGTBaseViewController *)selfWeak.service.ownController setViewLoadingShow:NO];
        if (selfWeak.mj_header) {
            [selfWeak.mj_header endRefreshing];
        }
        if (selfWeak.mj_footer) {
            [selfWeak.mj_footer endRefreshing];
        }
        [selfWeak reloadData];
        if (noMore && selfWeak.mj_footer) {
            [selfWeak.mj_footer endRefreshingWithNoMoreData];
        }
        if ([selfWeak.service isRefresh]) {
            [selfWeak setContentOffset:CGPointMake(0, 0) animated:NO];
            
            [(LGTBaseViewController *)selfWeak.service.ownController setViewNoDataShow:(selfWeak.service.models.count == 0)];
        }
       
        if (completion) {
            completion(YES);
        }
        if (selfWeak.TotalCountBlock) {
            selfWeak.TotalCountBlock(selfWeak.service.totalCount);
        }
    } failed:^(NSError *error) {
        NSLog(@"ERR:\n%@", error.localizedDescription);
        if (selfWeak.mj_header) {
            [selfWeak.mj_header endRefreshing];
        }
        if (selfWeak.mj_footer) {
            [selfWeak.mj_footer endRefreshing];
        }
        if ([selfWeak.service isRefresh]) {
            [(LGTBaseViewController *)selfWeak.service.ownController setViewLoadErrorShow:YES];
            if (selfWeak.TotalCountBlock) {
                selfWeak.TotalCountBlock(0);
            }
        }else{
            [LGAlert showStatus: error.localizedDescription];
        }
        if (completion) {
            completion(NO);
        }
    }];
}

- (void)loadFirstPage{
    [self loadFirstPageWithCompletion:nil];
}
- (void)loadFirstPageWithCompletion:(void (^)(BOOL))completion{
    self.service.currentPage = self.service.startPage;
    [self updateDataWithPage:self.service.startPage withCompletion:completion];
}
- (void)loadNextPage{
    [self loadNextPageWithCompletion:nil];
}
- (void)loadNextPageWithCompletion:(void (^)(BOOL))completion{
    self.service.currentPage++;
    [self updateDataWithPage:self.service.currentPage withCompletion:completion];
}

@end
