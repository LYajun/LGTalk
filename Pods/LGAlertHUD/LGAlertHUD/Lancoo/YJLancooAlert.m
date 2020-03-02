//
//  YJLancooAlert.m
//  LGAlertHUDDemo
//
//  Created by 刘亚军 on 2019/4/4.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJLancooAlert.h"
#import <YJExtensions/YJExtensions.h>
#import "LGAlertHUD.h"
#import <Masonry/Masonry.h>


#define kLancooScreenWidth [UIScreen mainScreen].bounds.size.width
#define kLancooScreenHeight [UIScreen mainScreen].bounds.size.height
#define IsPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kLancooWidth (IsPad ? 400 : kLancooScreenWidth * 0.8)
#define kLancooHeadImageH (IsPad ? 120 : 100)


@interface YJLancooAlert ()
/** 头像 */
@property (nonatomic,strong) UIImageView *headImageV;
/** 标题 */
@property (nonatomic,strong) UILabel *titleL;
/** 内容 */
@property (nonatomic,strong) UILabel *contentL;

@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *destructiveBtn;
@property (nonatomic,strong) UIButton *sureBtn;

@property (nonatomic,strong) UITextView *contentTextView;
@property(nonatomic,strong) UIView *maskView;

/** 取消回调 */
@property (nonatomic,copy) void (^cancelBlock)(void);
/** 确定回调 */
@property (nonatomic,copy) void (^destructiveBlock)(void);


/** 标题颜色 */
@property (nonatomic,strong) UIColor *titleColor;
/** 标题大小 */
@property (nonatomic,assign) CGFloat titleFontSize;
/** 内容颜色 */
@property (nonatomic,strong) UIColor *contentColor;
/** 内容大小 */
@property (nonatomic,assign) CGFloat contentFontSize;
/** 按钮背景色 */
@property (nonatomic,strong) UIColor *btnBackgroundColor;
/** 按钮边缘颜色 */
//@property (nonatomic,strong) UIColor *btnBorderColor;
/** 按钮文字颜色 */
@property (nonatomic,strong) UIColor *btnTitleColor;
/** 按钮文字大小 */
@property (nonatomic,assign) CGFloat btnTitleFontSize;

@end
@implementation YJLancooAlert
- (instancetype)init{
    if (self = [super init]) {
        [self configure];
    }
    return self;
}
- (void)configure{

    _titleFontSize = IsPad ? 21 : 18;
    _titleColor = [UIColor yj_colorWithHex:0x222222];
    
    _contentFontSize = IsPad ? 17 : 15;
    _contentColor = [UIColor yj_colorWithHex:0x252525];
    
    _btnBackgroundColor = [UIColor yj_colorWithHex:0x23a1fa];
    _btnTitleColor = [UIColor whiteColor];
    _btnTitleFontSize = IsPad ? 17 : 15;
//    _btnBorderColor = [UIColor yj_colorWithHex:0x1DBDB8];
    
}
- (void)layoutUI{
    
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.bottom.equalTo(self);
        make.top.equalTo(self.mas_top).offset(kLancooHeadImageH/2 - 10);
    }];
    [contentView yj_clipLayerWithRadius:5 width:0 color:nil];
    
    [self addSubview:self.headImageV];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
        make.height.mas_equalTo(kLancooHeadImageH);
        make.width.equalTo(self.headImageV.mas_height).multipliedBy(1.08);
    }];
    
    CGFloat leftOffset = kLancooScreenWidth > 320 ? 30 : 20;
    CGFloat btnSpace = 16;
    if (IsPad) {
        leftOffset = 48;
        btnSpace = 24;
    }
    CGFloat twoBtnWidth = (kLancooWidth - leftOffset * 2 - btnSpace)/2;
    CGFloat twoBtnHeight = IsPad ? 40 : 36;
    [contentView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView).offset(-20);
        make.left.equalTo(contentView).offset(leftOffset);
        make.width.mas_equalTo(twoBtnWidth);
        make.height.mas_equalTo(twoBtnHeight);
    }];
    
    
    [self.cancelBtn yj_shadowWithCornerRadius:twoBtnHeight/2 borderWidth:1.2 borderColor:_btnBackgroundColor shadowColor:[UIColor yj_colorWithHex:0x00C3F2] shadowOpacity:0.4 shadowOffset:CGSizeMake(0, 2.0) roundedRect:CGRectMake(3, 2, twoBtnWidth-6, twoBtnHeight) cornerRadii:CGSizeMake(twoBtnHeight/2, twoBtnHeight/2) rectCorner:UIRectCornerAllCorners];
    
    [contentView addSubview:self.destructiveBtn];
    [self.destructiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.width.height.equalTo(self.cancelBtn);
        make.left.equalTo(self.cancelBtn.mas_right).offset(btnSpace);
    }];
    [self.destructiveBtn yj_shadowWithCornerRadius:twoBtnHeight/2 borderWidth:0 borderColor:nil shadowColor:[UIColor yj_colorWithHex:0x00C3F2] shadowOpacity:0.5 shadowOffset:CGSizeMake(0, 2.5) roundedRect:CGRectMake(3, 2, twoBtnWidth-6, twoBtnHeight) cornerRadii:CGSizeMake(twoBtnHeight/2, twoBtnHeight/2) rectCorner:UIRectCornerAllCorners];
   
     CGFloat sureWidth = (kLancooScreenWidth > 320 ? 0.5 : 0.7)*kLancooWidth;
    if (IsPad) {
        sureWidth = 200;
    }
    [contentView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.width.mas_equalTo(sureWidth);
        make.height.bottom.equalTo(self.cancelBtn);
    }];
    
    [self.sureBtn yj_shadowWithCornerRadius:twoBtnHeight/2 borderWidth:0 borderColor:nil shadowColor:[UIColor yj_colorWithHex:0x00C3F2] shadowOpacity:0.5 shadowOffset:CGSizeMake(0, 2.5) roundedRect:CGRectMake(3, 2, sureWidth-6, twoBtnHeight) cornerRadii:CGSizeMake(sureWidth, twoBtnHeight/2) rectCorner:UIRectCornerAllCorners];
    
    [contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView.mas_top).offset(kLancooHeadImageH/2 + 10 + (IsPad ? 10 : 0));
        make.left.equalTo(contentView.mas_left).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    [contentView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.left.equalTo(contentView).offset(20);
        make.top.equalTo(self.titleL.mas_bottom).offset(20);
        make.bottom.equalTo(self.cancelBtn.mas_top).offset(-30);
    }];
    
    [contentView addSubview:self.contentTextView];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.left.equalTo(contentView).offset(20);
        make.top.equalTo(self.titleL.mas_bottom).offset(20);
        make.bottom.equalTo(self.cancelBtn.mas_top).offset(-30);
    }];
}
- (CGFloat)alertHeightuUnlessContentHeight{
    CGFloat topOffset = kLancooHeadImageH/2 - 10;
    CGFloat bottomOffset = (IsPad ? 40 : 36) + 20;
    CGFloat titleHeight = kLancooHeadImageH/2 + 10 + 20 + (IsPad ? 10 : 0);
    CGFloat contentTopOffset = 25;
    CGFloat contentBottomOffset = 35;
    
    if (IsPad) {
        contentTopOffset += 10;
        contentBottomOffset += 20;
    }
    
    return topOffset + bottomOffset + titleHeight + contentTopOffset + contentBottomOffset;
}
#pragma mark - Public
+ (YJLancooAlert *)lancooAlertWithTitle:(NSString *)title msg:(NSString *)msg sureTitle:(NSString *)sureTitle sureBlock:(void (^)(void))sureBlock{
    YJLancooAlert *alertView = [[YJLancooAlert alloc] init];
    alertView.destructiveBlock = sureBlock;
    alertView.contentTextView.hidden = YES;
    alertView.cancelBtn.hidden = YES;
    alertView.destructiveBtn.hidden = YES;
    alertView.titleL.text = title;
    alertView.contentL.text = msg;
    [alertView.sureBtn setTitle:sureTitle forState:UIControlStateNormal];
    CGFloat contentHeight = [msg boundingRectWithSize:CGSizeMake(kLancooWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:alertView.contentL.font} context:nil].size.height;
    alertView.frame = CGRectMake(0, 0, kLancooWidth, [alertView alertHeightuUnlessContentHeight] + contentHeight);
    [alertView layoutUI];
    return alertView;
}

+ (YJLancooAlert *)lancooAlertWithTitle:(NSString *)title msg:(NSString *)msg cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle cancelBlock:(void (^)(void))cancelBlock destructiveBlock:(void (^)(void))destructiveBlock{
    YJLancooAlert *alertView = [[YJLancooAlert alloc] init];
    alertView.cancelBlock = cancelBlock;
    alertView.destructiveBlock = destructiveBlock;
    alertView.contentTextView.hidden = YES;
    alertView.sureBtn.hidden = YES;
    alertView.titleL.text = title;
    alertView.contentL.text = msg;
    [alertView.cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
    [alertView.destructiveBtn setTitle:destructiveTitle forState:UIControlStateNormal];
    CGFloat contentHeight = [msg boundingRectWithSize:CGSizeMake(kLancooWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:alertView.contentL.font} context:nil].size.height;
    alertView.frame = CGRectMake(0, 0, kLancooWidth, [alertView alertHeightuUnlessContentHeight] + contentHeight);
    [alertView layoutUI];
    
    return alertView;
}

+ (YJLancooAlert *)lancooAlertWithTitle:(NSString *)title msgAttr:(NSAttributedString *)msgAttr sureTitle:(NSString *)sureTitle sureBlock:(void (^)(void))sureBlock{
    YJLancooAlert *alertView = [[YJLancooAlert alloc] init];
    alertView.destructiveBlock = sureBlock;
    alertView.contentL.hidden = YES;
    alertView.cancelBtn.hidden = YES;
    alertView.destructiveBtn.hidden = YES;
    alertView.titleL.text = title;
    NSMutableAttributedString *attr = msgAttr.mutableCopy;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.length)];
    alertView.contentTextView.attributedText = attr;
    [alertView.sureBtn setTitle:sureTitle forState:UIControlStateNormal];
    CGFloat contentHeight = [attr boundingRectWithSize:CGSizeMake(kLancooWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    if (contentHeight > kLancooScreenHeight * 0.3) {
        contentHeight = kLancooScreenHeight * 0.3;
    }
    alertView.frame = CGRectMake(0, 0, kLancooWidth, [alertView alertHeightuUnlessContentHeight] + contentHeight);
    [alertView layoutUI];
    
    return alertView;
}
+ (YJLancooAlert *)lancooAlertWithTitle:(NSString *)title msgAttr:(NSAttributedString *)msgAttr cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle cancelBlock:(void (^)(void))cancelBlock destructiveBlock:(void (^)(void))destructiveBlock{
    return [YJLancooAlert lancooAlertWithTitle:title msgAttr:msgAttr alignment:NSTextAlignmentCenter cancelTitle:cancelTitle destructiveTitle:destructiveTitle cancelBlock:cancelBlock destructiveBlock:destructiveBlock];
}
+ (YJLancooAlert *)lancooAlertWithTitle:(NSString *)title msgAttr:(NSAttributedString *)msgAttr alignment:(NSTextAlignment)alignment cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle cancelBlock:(void (^)(void))cancelBlock destructiveBlock:(void (^)(void))destructiveBlock{
    
    YJLancooAlert *alertView = [[YJLancooAlert alloc] init];
    alertView.cancelBlock = cancelBlock;
    alertView.destructiveBlock = destructiveBlock;
    alertView.contentL.hidden = YES;
    alertView.sureBtn.hidden = YES;
    alertView.titleL.text = title;
    NSMutableAttributedString *attr = msgAttr.mutableCopy;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    paragraphStyle.alignment = alignment;
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.length)];
    alertView.contentTextView.attributedText = attr;
    [alertView.cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
    [alertView.destructiveBtn setTitle:destructiveTitle forState:UIControlStateNormal];
    CGFloat contentHeight = [attr boundingRectWithSize:CGSizeMake(kLancooWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    if (contentHeight > kLancooScreenHeight * 0.3) {
        contentHeight = kLancooScreenHeight * 0.3;
    }
    alertView.frame = CGRectMake(0, 0, kLancooWidth, [alertView alertHeightuUnlessContentHeight] + contentHeight);
    [alertView layoutUI];
    
    return alertView;
}
+ (YJLancooAlert *)lancooAlertGifViewWithGifName:(NSString *)gifName msg:(NSString *)msg duration:(NSInteger)duration{
    YJLancooAlert *alertView = [[YJLancooAlert alloc] init];
    alertView.frame = CGRectMake(0, 0, 200, 200);
    alertView.backgroundColor = [UIColor whiteColor];

    [alertView yj_clipLayerWithRadius:5 width:0 color:nil];
    UIImageView *gifImg = [[UIImageView alloc] initWithImage:[UIImage yj_animatedImageNamed:gifName atDir:nil duration:duration atBundle:LGAlert.alertBundle]];
    [alertView addSubview:gifImg];
    [gifImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView);
        make.centerY.equalTo(alertView).offset(-15);
        make.width.height.mas_equalTo(100);
    }];
    [gifImg layoutIfNeeded];
    [gifImg yj_clipLayerWithRadius:50 width:0 color:nil];
    
    UILabel *titleL = [UILabel new];
    titleL.text = msg;
    titleL.numberOfLines = 2;
    titleL.textColor = alertView.contentColor;
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = [UIFont systemFontOfSize:alertView.contentFontSize];
    [alertView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView);
        make.top.equalTo(gifImg.mas_bottom).offset(10);
    }];
    return alertView;
}

+ (void)dismiss{
    UIWindow *rootWindow = [UIApplication sharedApplication].delegate.window;
    for (UIView *view in rootWindow.subviews) {
        if ([view isKindOfClass:[YJLancooAlert class]]) {
            [(YJLancooAlert *)view hide];
        }
    }
}
- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].delegate.window;
    for (UIView *view in rootWindow.subviews) {
        if ([view isKindOfClass:[YJLancooAlert class]]) {
            [(YJLancooAlert *)view hide];
        }
    }
    [rootWindow addSubview:self.maskView];
    [rootWindow addSubview:self];
    self.center = rootWindow.center;
    self.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                             CGAffineTransformMakeScale(0.7f, 0.7f));
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
#pragma mark - Action
- (void)cancelAction{
    [self hide];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
- (void)destructiveAction{
    [self hide];
    if (self.destructiveBlock) {
        self.destructiveBlock();
    }
}
- (void)sureAction{
    [self hide];
    if (self.destructiveBlock) {
        self.destructiveBlock();
    }
}
#pragma mark - Getter
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor yj_colorWithHex:0x000000 alpha:0.6];
    }
    return _maskView;
}
- (UIImageView *)headImageV{
    if (!_headImageV) {
        _headImageV = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"lancoo_1" atBundle:LGAlert.alertBundle]];
    }
    return _headImageV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont systemFontOfSize:_titleFontSize weight:UIFontWeightMedium];
        _titleL.textColor = _titleColor;
    }
    return _titleL;
}
- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [UILabel new];
        _contentL.textAlignment = NSTextAlignmentCenter;
        _contentL.font = [UIFont systemFontOfSize:_contentFontSize];
        _contentL.textColor = _contentColor;
        _contentL.numberOfLines = 3;
    }
    return _contentL;
}
- (UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [UITextView new];
        _contentTextView.font = [UIFont systemFontOfSize:_contentFontSize];
        _contentTextView.textColor = _contentColor;
        _contentTextView.editable = NO;
        _contentTextView.selectable = NO;
    }
    return _contentTextView;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:_btnTitleFontSize];
        [_cancelBtn setTitleColor:_btnBackgroundColor forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)destructiveBtn{
    if (!_destructiveBtn) {
        _destructiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _destructiveBtn.titleLabel.font = [UIFont systemFontOfSize:_btnTitleFontSize];
        [_destructiveBtn setTitleColor:_btnTitleColor forState:UIControlStateNormal];
        _destructiveBtn.backgroundColor = _btnBackgroundColor;
        [_destructiveBtn addTarget:self action:@selector(destructiveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _destructiveBtn;
}
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:_btnTitleFontSize];
        [_sureBtn setTitleColor:_btnTitleColor forState:UIControlStateNormal];
        _sureBtn.backgroundColor = _btnBackgroundColor;
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
@end
