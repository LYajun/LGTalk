//
//  LGTBaseViewController.m
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGTBaseViewController.h"
#import <Masonry/Masonry.h>
#import "LGTActivityIndicatorView.h"
#import "LGTExtension.h"
#import "LGTalkManager.h"
#import <YJExtensions/YJExtensions.h>



@interface LGTBaseViewController ()
/** 加载中 */
@property (strong, nonatomic) UIView *viewLoading;

/** 没有数据 */
@property (strong, nonatomic) UIView *viewNoData;
/** 发生错误 */
@property (strong, nonatomic) UIView *viewLoadError;
@property (strong, nonatomic) UILabel *marqueeTitleLabel;

@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UILabel *loadNoDataLab;
@end

@implementation LGTBaseViewController

#pragma mark lifecycle
- (instancetype)initWithServiceName:(NSString *)serviceName{
    if (self = [super init]) {
        if (!LGT_IsStrEmpty(serviceName)) {
            Class ServiceClass = NSClassFromString(serviceName);
            self.service = [[ServiceClass alloc] initWithOwnController:self];
        }
        [self configure];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseUI];
    [self initBaseNavigationBar];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.navBar_leftItemType != LGTNavBarLeftItemTypeBack) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ --dealloc",NSStringFromClass(self.class));
}
- (void)configure {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.marqueeTitle = @"";
}
- (void)initBaseUI{
    self.view.backgroundColor = [UIColor whiteColor];
   
}
- (void)initBaseNavigationBar{
     if (self.navBar_leftItemType == LGTNavBarLeftItemTypeBack) {
         self.navigationController.interactivePopGestureRecognizer.enabled = YES;
         self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
     }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backBtn];
    self.navigationItem.titleView = self.marqueeTitleLabel;
}

#pragma mark action
- (void)_navBar_leftItemPressed:(UIBarButtonItem *)sender{
    [self navBar_leftItemPressed:sender];
}
- (void)navBar_leftItemPressed:(UIBarButtonItem *)sender{
    [[LGTalkManager defaultManager] resetParams];
    if (self.navBar_leftItemType == LGTNavBarLeftItemTypeBack){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)setNavBar_rightItemTitles:(NSArray *)titles{
    NSMutableArray *itemArr = [NSMutableArray array];
    UIBarButtonItem *navigationSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    navigationSpacer.width = 10;
    for (int i = 0; i < titles.count; i++) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:titles[i] style:UIBarButtonItemStylePlain target:self action:@selector(navBar_rightItemPressed:)];
        item.tag = i;
        if (itemArr.count > 0) {
            [itemArr addObject:navigationSpacer];
        }
        [itemArr addObject:item];
    }
    self.navigationItem.rightBarButtonItems = itemArr;
}
- (void)setNavBar_rightItemImages:(NSArray *)images{
    NSMutableArray *itemArr = [NSMutableArray array];
    UIBarButtonItem *navigationSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    navigationSpacer.width = 10;
    for (int i = 0; i < images.count; i++) {
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.frame = CGRectMake(0, 0, 28, 28);
        [item setImage:images[i] forState:UIControlStateNormal];
        [item addTarget:self action:@selector(navBar_rightItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = i;
        if (itemArr.count > 0) {
            [itemArr addObject:navigationSpacer];
        }
        [itemArr addObject:[[UIBarButtonItem alloc] initWithCustomView:item]];
    }
    self.navigationItem.rightBarButtonItems = itemArr;
}


- (void)navBar_rightItemPressed:(UIButton *)sender{
}

#pragma mark loadData
- (void)setNoDataTitleStr:(NSString *)titleStr{
    if (self.loadNoDataLab) {
        self.loadNoDataLab.text = titleStr;
    }
}
- (void)loadData{
    [self loadDataWithCompletion:nil];
}
- (void)loadDataWithCompletion:(void (^)(BOOL))completion{
    [self setViewLoadingShow:YES];
    __weak typeof(self) weakSelf = self;
    [self.service loadDataWithSuccess:^(BOOL noData) {
        if (noData) {
            [weakSelf setViewNoDataShow:YES];
        }else{
            [weakSelf setViewLoadingShow:NO];
            if (completion) {
                completion(YES);
            }
            [weakSelf updateData];
        }
    } failed:^(NSError *error) {
        [weakSelf setViewLoadErrorShow:YES];
        if (completion) {
            completion(NO);
        }
    }];
}
- (void)updateData{
}
#pragma mark Stateview

- (void)setViewLoadingShow:(BOOL)show{
    [self.viewNoData removeFromSuperview];
    [self.viewLoadError removeFromSuperview];
    [self setShowOnBackgroundView:self.viewLoading show:show];
}
- (void)setViewNoDataShow:(BOOL)show{
    [self.viewLoading removeFromSuperview];
    [self.viewLoadError removeFromSuperview];
    [self setShowOnBackgroundView:self.viewNoData show:show];
}
- (void)setViewLoadErrorShow:(BOOL)show{
    [self.viewLoading removeFromSuperview];
    [self.viewNoData removeFromSuperview];
    [self setShowOnBackgroundView:self.viewLoadError show:show];
}
- (void)setShowOnBackgroundView:(UIView *)aView show:(BOOL)show {
    if (!aView) {
        return;
    }
    if (show) {
        if (aView.superview) {
            [aView removeFromSuperview];
        }
        if (self.aboveView) {
            [self.view insertSubview:aView belowSubview:self.aboveView];
        }else{
            [self.view addSubview:aView];
            [self.view bringSubviewToFront:aView];
        }
        [aView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(self.yj_loadingViewTopSpace);
            make.centerX.left.bottom.equalTo(self.view);
        }];
    }
    else {
        [aView removeFromSuperview];
    }
}

- (UIView *)viewLoading {
    if (!_viewLoading) {
        _viewLoading = [[UIView alloc]init];
        _viewLoading.backgroundColor = self.view.backgroundColor;
         UIImageView *gifImageView = [[UIImageView alloc]  initWithFrame:CGRectZero];
        gifImageView.animationImages = [LGTalkManager defaultManager].loadingImgs;
        gifImageView.animationDuration = [LGTalkManager defaultManager].loadingImgs.count * 0.05;
        [gifImageView startAnimating];
        [_viewLoading addSubview:gifImageView];
        
        [gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.viewLoading);
            make.centerY.equalTo(self.viewLoading).offset(-10);
            make.width.mas_equalTo(140);
            make.height.equalTo(gifImageView.mas_width).multipliedBy(1.01);
        }];
        
        
        UILabel *loadingGifLab = [[UILabel alloc]init];
        loadingGifLab.font = [UIFont systemFontOfSize:14];
        loadingGifLab.textAlignment = NSTextAlignmentCenter;
        loadingGifLab.textColor = LGT_ColorWithHex(0x989898);
        loadingGifLab.text = @"努力加载中...";
        
        [_viewLoading addSubview:loadingGifLab];
        [loadingGifLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(self.viewLoading);
            make.top.equalTo(gifImageView.mas_bottom).offset(10);
        }];
    }
    return _viewLoading;
}

- (UIView *)viewNoData {
    if (!_viewNoData) {
        _viewNoData = [[UIView alloc]init];
        _viewNoData.backgroundColor = self.view.backgroundColor;
        NSString *imgName = @"empty_1";
        if (IsIPad) {
            imgName = [imgName stringByAppendingString:@"_ipad"];
        }
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:imgName atDir:@"empty" atBundle:[LGTalkManager defaultManager].lgBundle]];
        [_viewNoData addSubview:img];
        __weak typeof(self) weakSelf = self;
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.viewNoData);
            make.centerY.equalTo(weakSelf.viewNoData).offset(IsIPad ? -70 : -50);
        }];
        UILabel *lab = [[UILabel alloc] init];
        lab.tag = 11;
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor =  LGT_ColorWithHex(0x989898);
        lab.text = @"暂无内容";
        self.loadNoDataLab = lab;
        [_viewNoData addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(self.viewNoData);
            make.centerY.equalTo(weakSelf.viewNoData).offset(20);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadErrorUpdate)];
        [_viewNoData addGestureRecognizer:tap];
    }
    return _viewNoData;
}
- (UIView *)viewLoadError {
    if (!_viewLoadError) {
        _viewLoadError = [[UIView alloc]init];
        _viewLoadError.backgroundColor = self.view.backgroundColor;
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage yj_imageNamed: @"error_1" atDir:@"error" atBundle:[LGTalkManager defaultManager].lgBundle]];
        [_viewLoadError addSubview:img];
        __weak typeof(self) weakSelf = self;
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.viewLoadError);
            make.centerY.equalTo(weakSelf.viewLoadError).offset(-15);
        }];
        UILabel *lab = [[UILabel alloc]init];
        lab.tag = 11;
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = LGT_ColorWithHex(0x989898);
        lab.text = @"数据加载失败，轻触刷新";;
        [_viewLoadError addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(self.viewLoadError);
            make.top.equalTo(img.mas_bottom).offset(18);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadErrorUpdate)];
        [_viewLoadError addGestureRecognizer:tap];
    }
    return _viewLoadError;
}
- (void)loadErrorUpdate{
    [self loadData];
}
#pragma mark setter getter
- (void)setMarqueeTitle:(NSString *)marqueeTitle {
    _marqueeTitle = marqueeTitle;
    self.marqueeTitleLabel.text = marqueeTitle;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 28, 28);
        [_backBtn setImageEdgeInsets: UIEdgeInsetsMake(0, -15, 0, 0)];
        [_backBtn setImage:[UIImage lgt_imageNamed:@"lg_navigationBar_back" atDir:@"NavBar"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(_navBar_leftItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)marqueeTitleLabel{
    if (!_marqueeTitleLabel) {
        _marqueeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,LGT_ScreenWidth-180, 25)];
//        _marqueeTitleLabel.animationDelay = 2.0;
        _marqueeTitleLabel.font = [UIFont systemFontOfSize:18];
        _marqueeTitleLabel.textColor = [UIColor whiteColor];
        _marqueeTitleLabel.textAlignment = NSTextAlignmentCenter;
//        _marqueeTitleLabel.trailingBuffer = 24;
//        _marqueeTitleLabel.marqueeType = MLContinuous;
    }
    return _marqueeTitleLabel;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
@end
