//
//  LGTMainViewController.m
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/6.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTMainViewController.h"
#import "LGTMainTableView.h"
#import <Masonry/Masonry.h>
#import "LGTExtension.h"
#import "LGTAddViewController.h"
#import "LGTalkManager.h"

@interface LGTMainViewController ()
@property (nonatomic,strong) LGTMainTableView *tableView;
@end

@implementation LGTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar_leftItemType = LGTNavBarLeftItemTypeMenu;
    self.marqueeTitle = ([LGTalkManager defaultManager].homeTitle != nil && [LGTalkManager defaultManager].homeTitle.length > 0) ?  [LGTalkManager defaultManager].homeTitle : @"在线讨论";
    if (![LGTalkManager defaultManager].forbidAddTalk) {
        [self setNavBar_rightItemImages:@[[UIImage lgt_imageNamed:@"add" atDir:@"NavBar"]]];
    }
    [self layoutUI];
}
- (void)layoutUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView loadFirstPage];
}
- (void)loadErrorUpdate{
     [self.tableView loadFirstPage];
}

- (void)navBar_rightItemPressed:(UIBarButtonItem *)sender{
    LGTAddViewController *uploadVC = [[LGTAddViewController alloc] init];
    WeakSelf;
    uploadVC.addSccessBlock = ^{
        [selfWeak.tableView loadFirstPage];
    };
    [self.navigationController pushViewController:uploadVC animated:NO];
}

- (LGTMainTableView *)tableView{
    if (!_tableView) {
        _tableView = [[LGTMainTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped ownController:self serviceName:@"LGTMainTableService"];
    }
    return _tableView;
}

@end
