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
#import "LGTPullDownMenu.h"

@interface LGTMainViewController ()
@property (nonatomic,strong) LGTMainTableView *tableView;
@property (nonatomic, strong) LGTPullDownMenu *pullDownMenu;
@property (nonatomic, copy) NSString *currentFilterTitle;
@end

@implementation LGTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
    [self.tableView loadFirstPage];
    __weak typeof(self) weakSelf = self;
    self.tableView.TotalCountBlock = ^(NSInteger count){
        [weakSelf.pullDownMenu setTitle:[NSString stringWithFormat:@"共%li组讨论",count]];
    };
}
- (void)updateData{
    if ([[LGTalkManager defaultManager].systemID isEqualToString:@"930"]) {
        self.pullDownMenu.menuDataArray = @[@[],self.tableView.service.mutiFilterTitleArray];
        [self.pullDownMenu setDefauldSelectedCell];
        if (!self.pullDownMenu.superview) {
            [self.view addSubview:self.pullDownMenu];
            self.pullDownMenu.currentSelTitle = [LGTalkManager defaultManager].resName;
        }
    }
}
- (void)layoutUI{
    self.navBar_leftItemType = LGTNavBarLeftItemTypeMenu;
    self.marqueeTitle = ([LGTalkManager defaultManager].homeTitle != nil && [LGTalkManager defaultManager].homeTitle.length > 0) ?  [LGTalkManager defaultManager].homeTitle : @"在线讨论";
    if (![LGTalkManager defaultManager].forbidAddTalk) {
        [self setNavBar_rightItemImages:@[[UIImage lgt_imageNamed:@"add" atDir:@"NavBar"]]];
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.bottom.equalTo(self.view);
        if ([[LGTalkManager defaultManager].systemID isEqualToString:@"930"]) {
            make.top.equalTo(self.view).offset(40);
        }else{
            make.top.equalTo(self.view);
        }
    }];
    self.currentFilterTitle = [LGTalkManager defaultManager].resName;
    if ([[LGTalkManager defaultManager].systemID isEqualToString:@"930"]) {
        self.yj_loadingViewTopSpace = 40;
        self.aboveView = self.pullDownMenu;
    }
    self.tableView.service.resID = [LGTalkManager defaultManager].resID;
  
}
- (void)loadErrorUpdate{
     [self.tableView loadFirstPage];
}

- (void)navBar_rightItemPressed:(UIBarButtonItem *)sender{
    LGTAddViewController *uploadVC = [[LGTAddViewController alloc] init];
    
    if ([[LGTalkManager defaultManager].systemID isEqualToString:@"930"]) {
        uploadVC.resID = LGT_ApiParams(self.tableView.service.resID);
        uploadVC.resName = self.currentFilterTitle;
    }else{
        uploadVC.resID = [LGTalkManager defaultManager].resID;
        uploadVC.resName = [LGTalkManager defaultManager].resName;
    }
    
    WeakSelf;
    uploadVC.addSccessBlock = ^{
//        if ([[LGTalkManager defaultManager].systemID isEqualToString:@"930"]) {
//            selfWeak.pullDownMenu.currentSelTitle = @"全部来源";
//            selfWeak.tableView.service.resID = @"";
//        }
        [selfWeak.tableView loadFirstPage];
    };
    [self.navigationController pushViewController:uploadVC animated:NO];
}
- (LGTPullDownMenu *)pullDownMenu{
    if (!_pullDownMenu) {
        _pullDownMenu = [[LGTPullDownMenu alloc] initWithFrame:CGRectMake(0, 0, LGT_ScreenWidth, 40) menuTitleArray:@[@"共0组讨论",@"全部来源"]];
        _pullDownMenu.menuDataArray = @[@[],self.tableView.service.mutiFilterTitleArray];
        __weak typeof(self) weakSelf = self;
        [_pullDownMenu setHandleSelectDataBlock:^(NSString *selectTitle, NSUInteger selectIndex, NSUInteger selectButtonTag) {
            if (selectButtonTag == 0) {
            }else{
                if (selectIndex == 0) {
                    weakSelf.currentFilterTitle = @"";
                }else{
                    weakSelf.currentFilterTitle = [weakSelf.tableView.service.mutiFilterTitleArray lgt_objectAtIndex:selectIndex];
                }
                weakSelf.tableView.service.resID = [weakSelf.tableView.service.mutiFilterTextArray lgt_objectAtIndex:selectIndex];
            }
            [weakSelf.tableView loadFirstPage];
        }];
    }
    return _pullDownMenu;
}
- (LGTMainTableView *)tableView{
    if (!_tableView) {
        _tableView = [[LGTMainTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped ownController:self serviceName:@"LGTMainTableService"];
    }
    return _tableView;
}

@end
