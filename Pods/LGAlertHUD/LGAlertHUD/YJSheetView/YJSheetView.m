//
//  YJSheetView.m
//  LGAlertHUDDemo
//
//  Created by 刘亚军 on 2019/10/11.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJSheetView.h"
#import <Masonry/Masonry.h>
#import <YJExtensions/YJExtensions.h>
#import "YJSheetCell.h"
#import "YJSheetHeaderView.h"

#define IsIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define YJSheetViewTitleH (IsIPad ? 50 : 44)
#define YJSheetViewBtnH (IsIPad ? 50 : 44)
#define YJSheetViewCancelH (IsIPad ? 48 : 44)
#define YJSheetViewRadiu (IsIPad ? 8 : 5)
@interface YJSheetView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIView *maskView;

@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) void (^cancelBlock)(void);
@property (nonatomic,copy) void (^buttonBlock)(NSInteger index);
@property (nonatomic,strong) NSArray *btnTitleArr;
@end

@implementation YJSheetView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title canceTitle:(NSString *)canceTitle buttonTitles:(NSArray *)buttonTitles{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.mas_equalTo(YJSheetViewCancelH);
            if (IsIPad) {
                make.width.mas_equalTo(400);
                make.bottom.equalTo(self).offset(-15);
            }else{
                make.left.equalTo(self).offset(10);
                make.bottom.equalTo(self).offset(-8);
            }
        }];
        
        [self.cancelBtn setTitle:canceTitle forState:UIControlStateNormal];
        
        self.titleStr = title;
        self.btnTitleArr = buttonTitles;
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancelBtn);
            make.centerX.equalTo(self);
            make.top.equalTo(self);
            if (IsIPad) {
                make.bottom.equalTo(self.cancelBtn.mas_top).offset(-6);
            }else{
                make.bottom.equalTo(self.cancelBtn.mas_top).offset(-6);
            }
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClickAction)];
        [self.maskView addGestureRecognizer:tap];
    }
    return self;
}
+ (YJSheetView *)sheetViewWithTitle:(NSString *)title canceTitle:(NSString *)canceTitle buttonTitles:(NSArray *)buttonTitles buttonBlock:(void (^)(NSInteger))buttonBlock cancelBlock:(void (^)(void))cancelBlock{
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat titleH = YJSheetViewTitleH;
    if (!title || title.length == 0) {
        titleH = 0;
    }
    CGFloat height = titleH + YJSheetViewBtnH * buttonTitles.count + 6 +  YJSheetViewCancelH + (IsIPad ? 15 : 8);
    YJSheetView *sheetView = [[YJSheetView alloc] initWithFrame:CGRectMake(0, screenH, screenW, height) title:title canceTitle:canceTitle buttonTitles:buttonTitles];
    
    sheetView.buttonBlock = buttonBlock;
    sheetView.cancelBlock = cancelBlock;
    
    return sheetView;
}

- (void)cancelClickAction{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self hide];
}
- (void)showOnView:(UIView *)view{
    [view addSubview:self.maskView];
    [view addSubview:self];
    self.maskView.alpha = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        self.maskView.alpha = 0.6f;
        self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
        self.alpha = 1.0f;
    }];
}
- (void)hide{
    [UIView animateWithDuration:0.2 animations:^(void) {
        self.transform = CGAffineTransformIdentity;
        self.maskView.alpha = 0;
    } completion:^(BOOL isFinished) {
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.btnTitleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YJSheetViewBtnH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.titleStr && self.titleStr.length > 0) {
        return YJSheetViewTitleH;
    }
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YJSheetHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([YJSheetHeaderView class])];
    headerView.titleStr = self.titleStr;
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJSheetCell class]) forIndexPath:indexPath];
    cell.titleStr = self.btnTitleArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.buttonBlock) {
        self.buttonBlock(indexPath.row);
    }
    [self hide];
}
#pragma mark - Getter
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor yj_colorWithHex:0x000000 alpha:0.6];
    }
    return _maskView;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelClickAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn yj_clipLayerWithRadius:YJSheetViewRadiu width:0 color:nil];
    }
    return _cancelBtn;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[YJSheetCell class] forCellReuseIdentifier:NSStringFromClass([YJSheetCell class])];
        [_tableView registerClass:[YJSheetHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([YJSheetHeaderView class])];
        [_tableView yj_clipLayerWithRadius:YJSheetViewRadiu width:0 color:nil];
    }
    return _tableView;
}
@end
