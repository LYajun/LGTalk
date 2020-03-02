//
//  YJScoreAlert.m
//  AFNetworking
//
//  Created by 刘亚军 on 2019/8/4.
//

#import "YJScoreAlert.h"
#import <Masonry/Masonry.h>
#import "YJAnswerConst.h"
#import "YJTaskMarLabel.h"

@interface YJScoreAlert ()
@property (nonatomic,strong) UIImageView *bgImgView;
@property (nonatomic,strong) UIImageView *flowerImgView;
@property (nonatomic,strong) UIImageView *rightCountImgView;
@property (nonatomic,strong) UIImageView *wrongCountImgView;
@property (nonatomic,strong) UILabel *scoreLab;
@property (nonatomic,strong) UILabel *scoreTitleLab;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *rightCountLab;
@property (nonatomic,strong) UILabel *wrongCountLab;
@property (nonatomic,strong) UILabel *rightCountTitleLab;
@property (nonatomic,strong) UILabel *wrongCountTitleLab;
@property (nonatomic,strong) UILabel *topicCountLab;
@property (nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) YJTaskMarLabel *tipLab;
@end
@implementation YJScoreAlert
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}
- (CGFloat)contentViewHeight{
    NSString *scoreStr = [NSString stringWithFormat:@"%.1f",self.answerScore];
    if ([scoreStr componentsSeparatedByString:@"."].lastObject.floatValue == 0) {
        return (self.height - 60) * 0.45 * 0.41;
    }else{
        return (self.height - 60) * 0.45 * 0.31;
    }
}
- (void)layoutUI{
    _tipStr = @"【注】未评阅的习题，不进行统计。";
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.width.height.mas_equalTo(40);
    }];
    
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.left.equalTo(self);
        make.bottom.equalTo(self.closeBtn.mas_top).offset(-20);
    }];
    
    [contentView yj_clipLayerWithRadius:14 width:0 color:nil];
    
    [contentView addSubview:self.bgImgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.top.equalTo(contentView);
        make.height.equalTo(contentView).multipliedBy(0.45);
    }];
    [contentView addSubview:self.scoreLab];
    [self.scoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImgView).offset(-20);
        make.centerY.equalTo(self.bgImgView);
        make.height.equalTo(self.bgImgView).multipliedBy(0.45);
    }];
    [contentView addSubview:self.scoreTitleLab];
    [self.scoreTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scoreLab);
        make.left.equalTo(self.scoreLab.mas_right).offset(5);
        make.height.mas_equalTo(self.scoreLab).multipliedBy(0.5);
    }];
    
    [contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(self.bgImgView.mas_bottom).offset(LG_ScreenWidth > 320 ? 30 : -20);
    }];
    
    [contentView addSubview:self.tipLab];
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.bottom.equalTo(contentView).offset(LG_ScreenWidth > 375 ? -30 : -20);
        make.left.equalTo(contentView).offset(20);
    }];
    
    [contentView addSubview:self.topicCountLab];
    [self.topicCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.bottom.equalTo(self.tipLab.mas_top).offset(LG_ScreenWidth > 375 ? -30 : -20);
        make.height.mas_equalTo(20);
    }];
    
    self.tipLab.hidden = YES;
    self.tipLab.text = self.tipStr;
    [contentView addSubview:self.rightCountTitleLab];
    [self.rightCountTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView).offset(-57);
        make.bottom.equalTo(self.topicCountLab.mas_top).offset(LG_ScreenWidth <= 375 ? -20 : -30);
        make.height.mas_equalTo(20);
    }];
    
    [contentView addSubview:self.wrongCountTitleLab];
    [self.wrongCountTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView).offset(57);
        make.bottom.height.equalTo(self.rightCountTitleLab);
    }];
    
    [contentView addSubview:self.rightCountImgView];
    [self.rightCountImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightCountTitleLab);
        make.bottom.equalTo(self.rightCountTitleLab.mas_top).offset(-10);
        make.width.height.mas_equalTo(50);
    }];
    [contentView addSubview:self.wrongCountImgView];
    [self.wrongCountImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.wrongCountTitleLab);
        make.bottom.width.height.equalTo(self.rightCountImgView);
    }];
    
    [contentView addSubview:self.rightCountLab];
    [self.rightCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.rightCountImgView);
    }];
    
    [contentView addSubview:self.wrongCountLab];
    [self.wrongCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.wrongCountImgView);
    }];
    
    [contentView addSubview:self.flowerImgView];
    [self.flowerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.titleLab);
        make.top.equalTo(self.bgImgView.mas_bottom);
        make.centerX.equalTo(contentView);
    }];
    self.flowerImgView.hidden = YES;
}
+ (YJScoreAlert *)scoreAlert{
    CGFloat width = 0;
    CGFloat height = 0;
    if (IsIPad) {
        width = 350;
        height = 600;
    }else{
        width = LG_ScreenWidth * 0.75;
        if (LG_ScreenWidth <= 320) {
            height = 568 * 0.82;
        }else if (LG_ScreenWidth <= 375){
            height = 667 * 0.82;
        }else{
            height = 736 * 0.82;
        }
    }
    
    YJScoreAlert *scoreAlert = [[YJScoreAlert alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    scoreAlert.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scoreAlert.maskView.backgroundColor = LG_ColorWithHexA(0x000000, 0.6);
    return scoreAlert;
    
}

- (void)setAnswerScore:(float)answerScore{
    _answerScore = answerScore;
    if (answerScore / self.totalScore < 0.6) {
        [self setIsPass:NO];
    }else{
        [self setIsPass:YES];
    }
}
- (void)setIsPass:(BOOL)isPass{
    self.bgImgView.highlighted = isPass;
    self.flowerImgView.hidden = !isPass;
    NSString *scoreStr = [NSString stringWithFormat:@"%.1f",self.answerScore];
    if ([scoreStr componentsSeparatedByString:@"."].lastObject.floatValue == 0) {
        scoreStr = [scoreStr componentsSeparatedByString:@"."].firstObject;
    }
     NSTextAttachment *scoreTitleAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    if (isPass) {
        self.titleLab.text = @"恭喜你完成本次测试";
        [self addAnimation];
        scoreTitleAttachment.image = [UIImage yj_imagePathName:@"分" atDir:[LGAlertBundle_Answer stringByAppendingPathComponent:@"right"] atBundle:LGAlertBundle()];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
        for (int i = 0; i < scoreStr.length; i++) {
            BOOL isPoint = NO;
            NSString *score = [scoreStr substringWithRange:NSMakeRange(i, 1)];
            if ([score isEqualToString:@"."]) {
                isPoint = YES;
                score = [score stringByReplacingOccurrencesOfString:@"." withString:@"point"];
            }
            NSTextAttachment *attachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
            attachment.image = [UIImage yj_imagePathName:score atDir:[LGAlertBundle_Answer stringByAppendingPathComponent:@"right"] atBundle:LGAlertBundle()];
            CGFloat width = attachment.image.size.width;
            CGFloat height = attachment.image.size.height;
            CGFloat rate = width/height;
            CGFloat imageH = self.contentViewHeight;
            if (isPoint) {
                if (IsIPad) {
                    imageH = 20;
                }else{
                    imageH = 15;
                }
            }
            attachment.image = [attachment.image yj_transformtoSize:CGSizeMake(imageH*rate, imageH)];
            [attr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
        }
        self.scoreLab.attributedText = attr;
    }else{
        self.titleLab.text = @"再接再厉，继续努力";
        scoreTitleAttachment.image = [UIImage yj_imageNamed:@"分" atDir:[LGAlertBundle_Answer stringByAppendingPathComponent:@"wrong"] atBundle:LGAlertBundle()];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
        for (int i = 0; i < scoreStr.length; i++) {
            BOOL isPoint = NO;
            NSString *score = [scoreStr substringWithRange:NSMakeRange(i, 1)];
            if ([score isEqualToString:@"."]) {
                isPoint = YES;
                score = [score stringByReplacingOccurrencesOfString:@"." withString:@"point"];
            }
            NSTextAttachment *attachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
            attachment.image = [UIImage yj_imageNamed:score atDir:[LGAlertBundle_Answer stringByAppendingPathComponent:@"wrong"] atBundle:LGAlertBundle()];
            CGFloat width = attachment.image.size.width;
            CGFloat height = attachment.image.size.height;
            CGFloat rate = width/height;
            CGFloat imageH = self.contentViewHeight;
            if (isPoint) {
                if (IsIPad) {
                    imageH = 20;
                }else{
                    imageH = 15;
                }
            }
            attachment.image = [attachment.image yj_transformtoSize:CGSizeMake(imageH*rate, imageH)];
            [attr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
        }
        self.scoreLab.attributedText = attr;
    }
    CGFloat width = scoreTitleAttachment.image.size.width;
    CGFloat height = scoreTitleAttachment.image.size.height;
    CGFloat rate = width/height;
    CGFloat imageH = self.contentViewHeight*0.5;
    scoreTitleAttachment.image = [scoreTitleAttachment.image yj_transformtoSize:CGSizeMake(imageH*rate, imageH)];
    self.scoreTitleLab.attributedText = [NSAttributedString attributedStringWithAttachment:scoreTitleAttachment];
}
- (void)setUnMarkCount:(NSInteger)unMarkCount{
    _unMarkCount = unMarkCount;
    self.tipLab.hidden = unMarkCount == 0;
    [self.topicCountLab mas_updateConstraints:^(MASConstraintMaker *make) {
        if (unMarkCount == 0) {
            make.bottom.equalTo(self.tipLab.mas_top).offset(LG_ScreenWidth > 375 ? -10 : 0);
        }else{
            make.bottom.equalTo(self.tipLab.mas_top).offset(LG_ScreenWidth > 375 ? -30 : -20);
        }
    }];
}
- (void)setTipStr:(NSString *)tipStr{
    _tipStr = tipStr;
    self.tipLab.text = tipStr;
}
- (void)setRightCount:(NSInteger)rightCount{
    _rightCount = rightCount;
    self.rightCountLab.text = [NSString stringWithFormat:@"%li",rightCount];
}
- (void)setWrongCount:(NSInteger)wrongCount{
    _wrongCount = wrongCount;
    self.wrongCountLab.text = [NSString stringWithFormat:@"%li",wrongCount];
}
- (void)setSmallTopicCount:(NSInteger)smallTopicCount{
    _smallTopicCount = smallTopicCount;
    
    self.topicCountLab.text = [NSString stringWithFormat:@"共%li道大题，%li道小题",self.bigTopicCount,smallTopicCount];
}
- (void)addAnimation{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=[NSNumber numberWithFloat:0.5];
    animation.toValue =[NSNumber numberWithFloat:2];
    animation.duration = 1.0;
    animation.repeatCount=NSIntegerMax;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [self.flowerImgView.layer addAnimation:animation forKey:@"zoom"];
}
- (void)stopAnimating{
    [self.flowerImgView.layer removeAllAnimations];
    self.flowerImgView.hidden = YES;
}
- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].delegate.window;
    
    for (UIView *subView in rootWindow.subviews) {
        if ([subView isKindOfClass:YJScoreAlert.class]) {
            [(YJScoreAlert *)subView hide];
        }
    }
    
    [rootWindow addSubview:self.maskView];
    [rootWindow addSubview:self];
    self.center = CGPointMake(rootWindow.center.x, rootWindow.center.y+20);
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
     [self.tipLab invalidateTimer];
    if (self.hideBlock) {
        self.hideBlock();
    }
    [self stopAnimating];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^(void) {
        weakSelf.maskView.alpha = 0.0f;
        weakSelf.alpha = 0.0f;
    } completion:^(BOOL isFinished) {
        [weakSelf.maskView removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - Getter

- (YJTaskMarLabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [YJTaskMarLabel new];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.font = [UIFont systemFontOfSize:IsIPad ? 15 : 14];
        _tipLab.textColor = [UIColor redColor];
    }
    return _tipLab;
}
- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"wrong_bg" atDir:LGAlertBundle_Answer atBundle:LGAlertBundle()] highlightedImage:[UIImage yj_imageNamed:@"right_bg" atDir:LGAlertBundle_Answer atBundle:LGAlertBundle()]];
    }
    return _bgImgView;
}
- (UIImageView *)flowerImgView{
    if (!_flowerImgView) {
        _flowerImgView = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"flower" atDir:LGAlertBundle_Answer atBundle:LGAlertBundle()]];
    }
    return _flowerImgView;
}
- (UIImageView *)rightCountImgView{
    if (!_rightCountImgView) {
        _rightCountImgView = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"right_count" atDir:LGAlertBundle_Answer atBundle:LGAlertBundle()]];
    }
    return _rightCountImgView;
}
- (UIImageView *)wrongCountImgView{
    if (!_wrongCountImgView) {
        _wrongCountImgView = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"wrong_count" atDir:LGAlertBundle_Answer atBundle:LGAlertBundle()]];
    }
    return _wrongCountImgView;
}
- (UILabel *)scoreLab{
    if (!_scoreLab) {
        _scoreLab = [UILabel new];
    }
    return _scoreLab;
}
- (UILabel *)scoreTitleLab{
    if (!_scoreTitleLab) {
        _scoreTitleLab = [UILabel new];
    }
    return _scoreTitleLab;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:20];
        _titleLab.textColor = [UIColor yj_colorWithHex:0x335adb];
        _titleLab.text = @"恭喜你完成本次测试";
    }
    return _titleLab;
}
- (UILabel *)rightCountLab{
    if (!_rightCountLab) {
        _rightCountLab = [UILabel new];
        _rightCountLab.textAlignment = NSTextAlignmentCenter;
        _rightCountLab.font = [UIFont systemFontOfSize:18];
        _rightCountLab.textColor = [UIColor whiteColor];
    }
    return _rightCountLab;
}
- (UILabel *)wrongCountLab{
    if (!_wrongCountLab) {
        _wrongCountLab = [UILabel new];
        _wrongCountLab.textAlignment = NSTextAlignmentCenter;
        _wrongCountLab.font = [UIFont systemFontOfSize:18];
        _wrongCountLab.textColor = [UIColor whiteColor];
    }
    return _wrongCountLab;
}
- (UILabel *)rightCountTitleLab{
    if (!_rightCountTitleLab) {
        _rightCountTitleLab = [UILabel new];
        _rightCountTitleLab.textAlignment = NSTextAlignmentCenter;
        _rightCountTitleLab.font = [UIFont systemFontOfSize:14];
        _rightCountTitleLab.textColor = [UIColor yj_colorWithHex:0x252525];
        _rightCountTitleLab.text = @"正确题数";
    }
    return _rightCountTitleLab;
}
- (UILabel *)wrongCountTitleLab{
    if (!_wrongCountTitleLab) {
        _wrongCountTitleLab = [UILabel new];
        _wrongCountTitleLab.textAlignment = NSTextAlignmentCenter;
        _wrongCountTitleLab.font = [UIFont systemFontOfSize:14];
        _wrongCountTitleLab.textColor = [UIColor yj_colorWithHex:0x252525];
        _wrongCountTitleLab.text = @"错误题数";
    }
    return _wrongCountTitleLab;
}
- (UILabel *)topicCountLab{
    if (!_topicCountLab) {
        _topicCountLab = [UILabel new];
        _topicCountLab.textAlignment = NSTextAlignmentCenter;
        _topicCountLab.font = [UIFont systemFontOfSize:15];
        _topicCountLab.textColor = [UIColor yj_colorWithHex:0x989898];
    }
    return _topicCountLab;
}
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage yj_imageNamed:@"close" atDir:LGAlertBundle_Answer atBundle:LGAlertBundle()] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
@end
