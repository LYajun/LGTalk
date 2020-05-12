//
//  LGTBaseNavigationController.m
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGTBaseNavigationController.h"
#import "UIImage+LGT.h"

@interface LGTBaseNavigationController ()<UINavigationControllerDelegate>
@property (nonatomic, getter=isPushing) BOOL pushing;
@end

@implementation LGTBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)initNavigationBar {
    self.navigationBar.translucent = NO;
    NSString *imageName = @"lg_navBar_bg";
    if (LGT_IsIPad()) {
        imageName = @"lg_navBar_bg_ipad";
    }else if (LGT_IsIPhoneX()) {
        imageName = @"lg_navBar_bg_x";
    }
    [self.navigationBar setBackgroundImage:[UIImage lgt_imageNamed:imageName atDir:@"NavBar"]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary *titleAttr = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSFontAttributeName:[UIFont systemFontOfSize:18.0f]};
    self.navigationBar.titleTextAttributes = titleAttr;
    self.delegate = self;
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.pushing == YES) {
        return;
    } else {
        self.pushing = YES;
    }
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.pushing = NO;
}
@end
