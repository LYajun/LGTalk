//
//  YJAnswerAlertView.m
//  YJAnswernowledgeFramework
//
//  Created by 刘亚军 on 2018/11/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJAnswerAlertView.h"
#import <YJExtensions/YJExtensions.h>
#import "YJAnswerConst.h"
#import "YJAnswerAlertCell.h"
#import "YJAnswerAlertChoiceCell.h"
#import <Masonry/Masonry.h>


#define kLeftSpace  (IsIPad ? 40 : 10)
#define kCellSpace  (IsIPad ? 24 : 6)
#define kCellRowSpace 10
@interface YJAnswerAlertView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
/** 头像 */
@property (nonatomic,strong) UIImageView *headImageV;
/** 标题 */
@property (nonatomic,strong) UILabel *titleL;
/** 内容 */
@property (nonatomic,strong) UILabel *contentL;
/** 时间 */
@property (nonatomic,strong) UILabel *timeL;
/** 按钮集合 */
@property (nonatomic,strong) UICollectionView *collectionView;
///** 标题 */
//@property (nonatomic,copy) NSString *titleStr;
/** 取消标题 */
@property (nonatomic,copy) NSString *cancelTitle;
/** 确定标题 */
@property (nonatomic,copy) NSString *destructiveTitle;
/** 选择标题 */
@property (nonatomic,copy) NSString *choiceTitle;
/** 高亮消息内容 */
@property (nonatomic,copy) NSString *highLightMsg;
/** 取消回调 */
@property (nonatomic,copy) void (^cancelBlock)(void);
/** 确定回调 */
@property (nonatomic,copy) void (^destructiveBlock)(void);
/** 选择回调 */
@property (nonatomic,copy) void (^choiceBlock)(BOOL isChoice);
/** 是否选中 */
@property (nonatomic,assign) BOOL isChoice;
@property(nonatomic,strong) UIView *maskView;

@property (nonatomic,copy) void (^hideBlock) (void);
@end
@implementation YJAnswerAlertView
- (instancetype)initWithFrame:(CGRect)frame choiceTitle:(NSString *)choiceTitle{
    if (self = [super initWithFrame:frame]) {
         self.choiceTitle = choiceTitle;
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    CGFloat headImageH = 130;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.bottom.equalTo(self);
        make.top.equalTo(self.mas_top).offset(headImageH - 30);
    }];
    [contentView yj_clipLayerWithRadius:5 width:0 color:nil];
    [self addSubview:self.headImageV];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self).offset(16);
        make.height.mas_equalTo(headImageH);
        make.width.equalTo(self.headImageV.mas_height).multipliedBy(1.04);
    }];
    [contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.left.equalTo(contentView);
        make.bottom.equalTo(contentView).offset(IsStrEmpty(self.choiceTitle) ? -15 : -10);
        make.height.mas_equalTo(IsStrEmpty(self.choiceTitle) ? kCellHeight+kCellRowSpace : kCellHeight*2+kCellRowSpace);
    }];
    [contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView.mas_top).offset(30);
        make.left.equalTo(contentView.mas_left).offset(20);
        make.height.mas_equalTo(20);
    }];
    [contentView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.left.equalTo(contentView).offset(20);
        make.top.equalTo(self.titleL.mas_bottom).offset(10);
        make.bottom.equalTo(self.collectionView.mas_top).offset(-25);
    }];
}
+ (YJAnswerAlertView *)alertWithTitle:(NSString *)title normalMsg:(NSString *)normalMsg highLightMsg:(NSString *)highLightMsg destructiveTitle:(NSString *)destructiveTitle destructiveBlock:(void (^)(void))destructiveBlock{
    return [self alertWithTitle:title normalMsg:normalMsg highLightMsg:highLightMsg cancelTitle:nil destructiveTitle:destructiveTitle choiceTitle:nil cancelBlock:nil destructiveBlock:destructiveBlock choiceBlock:nil];
}
+ (YJAnswerAlertView *)alertWithTitle:(NSString *)title normalMsg:(NSString *)normalMsg highLightMsg:(NSString *)highLightMsg cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle cancelBlock:(void (^)(void))cancelBlock destructiveBlock:(void (^)(void))destructiveBlock{
    return [self alertWithTitle:title normalMsg:normalMsg highLightMsg:highLightMsg cancelTitle:cancelTitle destructiveTitle:destructiveTitle choiceTitle:nil cancelBlock:cancelBlock destructiveBlock:destructiveBlock choiceBlock:nil];
}
+ (YJAnswerAlertView *)alertWithTitle:(NSString *)title normalMsg:(NSString *)normalMsg highLightMsg:(NSString *)highLightMsg cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle choiceTitle:(NSString *)choiceTitle cancelBlock:(void (^)(void))cancelBlock destructiveBlock:(void (^)(void))destructiveBlock choiceBlock:(void (^)(BOOL))choiceBlock{
    CGFloat w = LG_ScreenWidth*0.72;
    CGFloat h = w;
    if (LG_ScreenWidth <= 320) {
        h = w * 1.48;
    }else if (LG_ScreenWidth <= 375){
        h = w * 1.38;
    }else{
        h = w * 1.28;
    }
    CGFloat contentW = [normalMsg yj_widthWithFont:LG_SysFont(15)];
    CGFloat contentReferW = w - 20*2;
    if (contentW > contentReferW && contentW <= contentReferW*2) {
        h -= 30;
    }else if (contentW <= contentReferW){
        h -= 30*2;
    }
    if (IsIPad) {
        w = 400;
        if (IsStrEmpty(choiceTitle)) {
            h = 320;
        }else{
            h = 320 + kCellHeight;
        }
    }
     YJAnswerAlertView *alertView = [[YJAnswerAlertView alloc] initWithFrame:CGRectMake(0, 0, w, h) choiceTitle:choiceTitle];
     alertView.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertView.maskView.backgroundColor = LG_ColorWithHexA(0x000000, 0.6);
    alertView.titleL.text = title;
    
    alertView.highLightMsg = highLightMsg;
    alertView.normalMsg = normalMsg;
    alertView.cancelTitle = cancelTitle;
    alertView.destructiveTitle = destructiveTitle;
    alertView.cancelBlock = cancelBlock;
    alertView.destructiveBlock = destructiveBlock;
    alertView.choiceBlock = choiceBlock;
    return alertView;
}
+ (YJAnswerAlertView *)alertWithTimeCount:(NSInteger)timeCount{
    YJAnswerAlertView *alertView = [[YJAnswerAlertView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    [alertView addSubview:alertView.timeL];
    [alertView.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(alertView);
    }];
    
    alertView.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertView.maskView.backgroundColor = LG_ColorWithHexA(0x000000, 0.8);
    alertView.timeL.text = [NSString stringWithFormat:@"%li",timeCount];
    return alertView;
}
+ (YJAnswerAlertView *)alertWithControllerName:(NSString *)controllerName hideBlock:(void (^)(void))hideBlock{
    if (![NSUserDefaults yj_boolForKey:controllerName]) {
        YJAnswerAlertView *alertView = [[YJAnswerAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertView.backgroundColor = LG_ColorWithHexA(0x000000, 0.6);
        alertView.maskView = [[UIView alloc] initWithFrame:CGRectZero];
        alertView.hideBlock = hideBlock;
        
        UILabel *titleL = [UILabel new];
        titleL.text = @"左右滑动切换题目";
        titleL.textColor = LG_ColorWithHex(0xffffff);
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.font = [UIFont boldSystemFontOfSize:IsIPad ? 20 : 18];
        
        UIImageView *fingerimg = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"finger" atDir:LGAlertBundle_Answer atBundle:LGAlertBundle()]];
        [alertView addSubview:fingerimg];
        [fingerimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertView);
            make.top.equalTo(alertView.mas_centerY);
            make.width.mas_equalTo(IsIPad ? 100 : LG_ScreenWidth*0.18);
            make.height.equalTo(fingerimg.mas_width).multipliedBy(1.6);
        }];
        
        
        UIImageView *sureimg = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"sure" atDir:LGAlertBundle_Answer atBundle:LGAlertBundle()]];
        [alertView addSubview:sureimg];
        [sureimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertView);
            make.top.equalTo(fingerimg.mas_bottom).offset(LG_ScreenHeight*0.08);
            make.width.mas_equalTo(IsIPad ? 110 : LG_ScreenWidth*0.216);
            make.height.equalTo(sureimg.mas_width).multipliedBy(0.407);
        }];
        
        
        UIImageView *slideTipimg = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"slide_tip" atDir:LGAlertBundle_Answer atBundle:LGAlertBundle()]];
        [alertView addSubview:slideTipimg];
        [slideTipimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertView);
            make.bottom.equalTo(fingerimg.mas_top).offset(-LG_ScreenHeight*0.145);
            make.left.equalTo(alertView).offset(20).priority(999);
            make.width.mas_lessThanOrEqualTo(500).priority(1000);
            make.height.equalTo(slideTipimg.mas_width).multipliedBy(0.129);
        }];
        
        [alertView addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertView);
            make.left.equalTo(alertView).offset(20);
            make.bottom.equalTo(slideTipimg.mas_top).offset(-LG_ScreenHeight*0.12);
        }];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:alertView action:@selector(hideAlertTipView)];
        [alertView addGestureRecognizer:tap];
        [alertView show];
        [NSUserDefaults yj_setObject:@(YES) forKey:controllerName];
        return alertView;
    }
    return nil;
}

+ (void)dismiss{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in rootWindow.subviews) {
        if ([view isKindOfClass:[YJAnswerAlertView class]]) {
            [(YJAnswerAlertView *)view hide];
        }
    }
}
- (void)setTimeCount:(NSInteger)timeCount{
    _timeCount = timeCount;
    self.timeL.text = [NSString stringWithFormat:@"%li",timeCount];
}
- (CGFloat)alertWidth{
    if (IsIPad) {
        return 400;
    }
    return LG_ScreenWidth*0.72;
}
- (CGFloat)alertHeight{
    return self.alertWidth*1.14;
}
- (void)setNormalMsg:(NSString *)normalMsg{
    _normalMsg = normalMsg;
    NSMutableAttributedString *attr = normalMsg.yj_toMutableAttributedString;
    [attr yj_setFont: IsIPad ? 17 : 15];
    [attr yj_setColor:LG_ColorWithHex(0x333333)];
    if ([self.highLightMsg containsString:@"&"]) {
        NSArray *highLightArr = [self.highLightMsg componentsSeparatedByString:@"&"];
        for (NSString *str in highLightArr) {
            NSRange hightlightTextRange = [normalMsg rangeOfString:str];
            if (hightlightTextRange.length > 0) {
                [attr yj_setColor:LG_ColorWithHex(0xff9000) atRange:hightlightTextRange];
            }
        }
    }else{
        NSRange hightlightTextRange = [normalMsg rangeOfString:self.highLightMsg];
        if (hightlightTextRange.length > 0) {
            [attr yj_setColor:LG_ColorWithHex(0xff9000) atRange:hightlightTextRange];
        }
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.length)];
    self.contentL.attributedText = attr;
}
- (void)hideAlertTipView{
    [self hide];
    if (self.hideBlock) {
        self.hideBlock();
    }
}
- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in rootWindow.subviews) {
        if ([view isKindOfClass:[YJAnswerAlertView class]]) {
            [(YJAnswerAlertView *)view hide];
        }
    }
    [rootWindow addSubview:self.maskView];
    [rootWindow addSubview:self];
    self.center = rootWindow.center;
    self.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                  CGAffineTransformMakeScale(0.1f, 0.1f));
    self.alpha = 0.0f;
    self.maskView.alpha = 0.0f;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        self.maskView.alpha = 0.6f;
        weakSelf.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                      CGAffineTransformMakeScale(1.0f, 1.0f));
        weakSelf.alpha = 1.0f;
    }];
}
- (void)hide{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^(void) {
        weakSelf.maskView.alpha = 0.0f;
        weakSelf.alpha = 0.0f;
    } completion:^(BOOL isFinished) {
        [weakSelf.maskView removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}
#pragma mark UICollectionViewFlowLayout delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (!IsStrEmpty(self.cancelTitle) && !IsStrEmpty(self.destructiveTitle)) {
            return CGSizeMake((self.alertWidth-kLeftSpace*2-kCellSpace)/2, kCellHeight);
        }else{
            return CGSizeMake(self.alertWidth-kLeftSpace*2, kCellHeight);
        }
    }else{
        return CGSizeMake(self.alertWidth-kLeftSpace*2, kCellHeight);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kCellSpace;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
         return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(kCellRowSpace, 0, 0, 0);
}
#pragma mark UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (IsStrEmpty(self.choiceTitle)) {
        return 1;
    }
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        if (!IsStrEmpty(self.cancelTitle) && !IsStrEmpty(self.destructiveTitle)) {
            return 2;
        }else{
            return 1;
        }
    }else{
        return 1;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YJAnswerAlertCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YJAnswerAlertCell class]) forIndexPath:indexPath];
        if (!IsStrEmpty(self.cancelTitle) && !IsStrEmpty(self.destructiveTitle)) {
            if (indexPath.row == 0) {
                cell.titleStr = self.destructiveTitle;
                cell.clickHighlighted = NO;
            }else{
                cell.titleStr = self.cancelTitle;
                cell.clickHighlighted = YES;
            }
            cell.isSingle = NO;
        }else{
            cell.isSingle = YES;
            cell.titleStr = self.destructiveTitle;
            cell.clickHighlighted = YES;
        }
        return cell;
    }else{
        YJAnswerAlertChoiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YJAnswerAlertChoiceCell class]) forIndexPath:indexPath];
        cell.titleStr = self.choiceTitle;
        cell.clickHighlighted = NO;
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.destructiveBlock) {
                self.destructiveBlock();
            }
        }else{
            if (self.cancelBlock) {
                self.cancelBlock();
            }
        }
        if (self.choiceBlock) {
            self.choiceBlock(self.isChoice);
        }
        [self hide];
    }else{
        YJAnswerAlertChoiceCell *cell = (YJAnswerAlertChoiceCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.clickHighlighted = !cell.clickHighlighted;
        self.isChoice = cell.clickHighlighted;
    }
}
#pragma Getter&Setter
- (UIImageView *)headImageV{
    if (!_headImageV) {
        _headImageV = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"zx_top_lancoo" atDir:LGAlertBundle_Answer atBundle:LGAlertBundle()]];
    }
    return _headImageV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.textAlignment = NSTextAlignmentCenter;
        if(([[[UIDevice currentDevice] systemVersion] compare:@"8.2" options:NSNumericSearch] == NSOrderedAscending)) {
            _titleL.font = [UIFont systemFontOfSize:IsIPad ? 21 : 18];
        } else {
            _titleL.font = [UIFont systemFontOfSize:IsIPad ? 21 : 18 weight:UIFontWeightMedium];
        }
        _titleL.textColor = LG_ColorWithHex(0x222222);
        _titleL.text = @"温馨提示";
    }
    return _titleL;
}
- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [UILabel new];
        _timeL.textAlignment = NSTextAlignmentCenter;
        _timeL.textColor = [UIColor whiteColor];
        _timeL.font = [UIFont systemFontOfSize:80];
    }
    return _timeL;
}
- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [UILabel new];
        _contentL.textAlignment = NSTextAlignmentCenter;
        _contentL.font = [UIFont systemFontOfSize:15];
        _contentL.numberOfLines = 3;
    }
    return _contentL;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, kLeftSpace, 0, kLeftSpace);
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[YJAnswerAlertCell class] forCellWithReuseIdentifier:NSStringFromClass([YJAnswerAlertCell class])];
         [_collectionView registerClass:[YJAnswerAlertChoiceCell class] forCellWithReuseIdentifier:NSStringFromClass([YJAnswerAlertChoiceCell class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}
@end
