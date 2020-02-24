//
//  LGTMainTableHeaderView.m
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/7.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTMainTableHeaderView.h"
#import "LGTTalkModel.h"
#import "LGTTalkItemView.h"
#import <Masonry/Masonry.h>
#import "LGTExtension.h"
#import "LGTPhotoBrowser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LGTalkManager.h"

@interface LGTMainTableHeaderView ()<LGTTalkItemViewDelegate>
@property (strong, nonatomic) UIImageView *IconImageV;
@property (strong, nonatomic) UIImageView *sanjiaoImageV;
@property (strong, nonatomic) UILabel *msgSourceL;
@property (strong, nonatomic) UILabel *peopleNameL;
@property (strong, nonatomic) UILabel *msgTimeL;
@property (strong, nonatomic) UILabel *msgContentL;
@property (strong, nonatomic) UIView *imageBgV;
@property (strong,nonatomic)  LGTPhotoBrowser *photoBrowser;
@property (strong, nonatomic) UIButton *replyBtn;
@property (strong, nonatomic) UIButton *themeDeleteBtn;
@property (strong, nonatomic) UIButton *setTopBtn;
@property (strong, nonatomic) UIButton *setTopFlagBtn;
@property (strong, nonatomic) UIButton *foldBtn;
@property (strong, nonatomic) UIButton *allContentBtn;

@end
@implementation LGTMainTableHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
     self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.IconImageV];
    [self.IconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(IsIPad ? 20 : 10);
        make.top.equalTo(self.contentView).offset(IsIPad ? 20 : 10);
        make.width.height.mas_equalTo(44);
    }];
    [self.IconImageV lgt_clipLayerWithRadius:22 width:0 color:nil];
    [self.contentView addSubview:self.setTopFlagBtn];
    [self.setTopFlagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(IsIPad ? -20 : -10);
        make.centerY.equalTo(self.IconImageV);
        make.height.mas_equalTo(26);
        make.width.equalTo(self.setTopFlagBtn.mas_height).multipliedBy(3);
    }];
    
    [self.contentView addSubview:self.msgTimeL];
    [self.msgTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.IconImageV);
        make.left.equalTo(self.IconImageV.mas_right).offset(10);
        make.right.equalTo(self.setTopFlagBtn.mas_left).offset(-15);
    }];
    [self.contentView addSubview:self.peopleNameL];
    [self.peopleNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.msgTimeL);
        make.bottom.equalTo(self.msgTimeL.mas_top).offset(-5);
    }];
    
    [self.contentView addSubview:self.replyBtn];
    [self.replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.setTopFlagBtn).offset(IsIPad ? -8 : 0);
        make.height.mas_equalTo(IsIPad ? 26 : 23);
        make.width.equalTo(self.replyBtn.mas_height).multipliedBy(1.17);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.contentView addSubview:self.foldBtn];
    [self.foldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.replyBtn);
        make.right.equalTo(self.replyBtn.mas_left).offset(IsIPad ? -40 : -15);
        make.width.mas_equalTo(82);
    }];
    if (IsIPad && CGAffineTransformIsIdentity(self.foldBtn.transform)) {
        self.foldBtn.transform = CGAffineTransformMakeScale(1.3, 1.3);
    }
    [self.contentView addSubview:self.msgSourceL];
    [self.msgSourceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.replyBtn);
        make.right.equalTo(self.foldBtn.mas_left).offset(-15);
        make.left.equalTo(self.msgTimeL);
    }];
    
    [self.contentView addSubview:self.sanjiaoImageV];
    [self.sanjiaoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.msgSourceL).offset(30);
        make.bottom.equalTo(self.contentView).offset(1);
        make.width.mas_equalTo(16);
        make.height.equalTo(self.sanjiaoImageV.mas_width).multipliedBy(1/1.6);
    }];
    
    [self.contentView addSubview:self.imageBgV];
    [self.imageBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(120);
        make.left.equalTo(self.msgSourceL);
        make.right.equalTo(self.setTopFlagBtn);
        make.bottom.equalTo(self.msgSourceL.mas_top).offset(-3);
    }];
    
    [self.imageBgV addSubview:self.photoBrowser];
    [self.photoBrowser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(self.imageBgV);
        make.width.mas_equalTo(self.imageBgV.mas_height).multipliedBy(3);
    }];
    [self.contentView addSubview:self.allContentBtn];
    [self.allContentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.msgSourceL).offset(-5);
        make.bottom.equalTo(self.imageBgV.mas_top).offset(-3);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(26);
    }];

    
    [self.contentView addSubview:self.msgContentL];
    [self.msgContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.msgSourceL);
        make.right.equalTo(self.setTopFlagBtn);
        make.top.equalTo(self.msgTimeL.mas_bottom).offset(3);
        make.bottom.equalTo(self.allContentBtn.mas_top);
    }];
}
- (void)configByTalkModel:(LGTTalkModel *)talkModel{
    self.msgContentL.numberOfLines =
    self.allContentBtn.hidden = !talkModel.tableHeaderShowAllContentEnbale;
    self.allContentBtn.selected = talkModel.isAllContent;
    [self.allContentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        if (talkModel.tableHeaderShowAllContentEnbale) {
            make.height.mas_equalTo(26);
        }else{
            make.height.mas_equalTo(0);
        }
    }];

    if (LGT_IsArrEmpty(talkModel.ImgUrlList)) {
        [self.imageBgV mas_updateConstraints:^(MASConstraintMaker *make) {
              make.height.mas_equalTo(0);
        }];
    }else{
        CGFloat imageBgW = LGT_ScreenWidth - 44 - 10 - 10 - 10;
        if (LGT_IsIPad()) {
            imageBgW = 120 * 3;
        }
        [self.imageBgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(imageBgW/3);
        }];
        self.photoBrowser.imageUrls = talkModel.ImgUrlList;
    }
    [self.IconImageV sd_setImageWithURL:[NSURL URLWithString:talkModel.UserImg] placeholderImage:[UIImage lgt_imageNamed:@"chatHead" atDir:@"Main"]];
    self.peopleNameL.text = talkModel.UserName;
    self.msgTimeL.text = [NSString lgt_displayTimeWithCurrentTime:[NSDate date].lgt_string referTime:talkModel.CreateTime];
    
    self.sanjiaoImageV.hidden = LGT_IsArrEmpty(talkModel.CommentList) || talkModel.isFold;
    self.msgContentL.attributedText = talkModel.Content_Attr;
    self.msgContentL.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *sourceAttr = [[NSMutableAttributedString alloc] initWithString:@"来自"];
    [sourceAttr lgt_setColor:LGT_ColorWithHex(0x989898)];
    [sourceAttr lgt_setFont:13];
  
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:talkModel.FromTopicInfo];
    [textAttr lgt_setColor:LGT_ColorWithHex(0x47A9EA)];
    [textAttr lgt_setFont:14];
    [sourceAttr appendAttributedString:textAttr];
    self.msgSourceL.attributedText = sourceAttr;
    self.setTopFlagBtn.hidden = !talkModel.IsTop;
    self.setTopBtn.selected = talkModel.IsTop;
    self.setTopBtn.hidden = NO;
    if (talkModel.TopUserType == 1) {
        if ([LGTalkManager defaultManager].userType == 2) {
            self.setTopBtn.hidden = YES;
        }
        self.setTopFlagBtn.selected = NO;
    }else{
        self.setTopFlagBtn.selected = YES;
    }
    if (LGT_IsArrEmpty(talkModel.CommentList)) {
        self.foldBtn.hidden = YES;
        [self.foldBtn setTitle:@"回复(0)" forState:UIControlStateNormal];
    }else{
        [self.foldBtn setTitle:[NSString stringWithFormat:@"回复(%li)",talkModel.CommentList.count] forState:UIControlStateNormal];
        self.foldBtn.hidden = NO;
    }
    if (talkModel.isFold) {
        self.foldBtn.imageView.transform = CGAffineTransformIdentity;
    }else{
        self.foldBtn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
    }
}
#pragma mark - Action
- (void)replyAction{
    if (self.MsgClickBlock) {
        self.MsgClickBlock();
    }
    CGPoint relativePoint = [self.replyBtn convertRect: self.replyBtn.bounds toView: [UIApplication sharedApplication].keyWindow].origin;
    CGSize relativeSize = [self.replyBtn convertRect: self.replyBtn.bounds toView: [UIApplication sharedApplication].keyWindow].size;
    NSArray *itemTitles;
    if (self.setTopBtn.hidden) {
        if (self.themeDeleteBtn.hidden) {
            itemTitles = @[@"回复"];
        }else{
            itemTitles = @[@"删除",@"回复"];
        }
    }else{
        if (self.setTopBtn.selected) {
            if (self.themeDeleteBtn.hidden) {
                itemTitles = @[@"取消置顶",@"回复"];
            }else{
                itemTitles = @[@"删除",@"取消置顶",@"回复"];
            }
        }else{
            if (self.themeDeleteBtn.hidden) {
                itemTitles = @[@"置顶",@"回复"];
            }else{
                itemTitles = @[@"删除",@"置顶",@"回复"];
            }
        }
    }
    CGFloat itemViewW = itemTitles.count * 80 + (itemTitles.count-1);
    CGFloat itemViewH = 44;
    CGFloat itemViewX = relativePoint.x - itemViewW - 20;
    CGFloat itemViewY = relativePoint.y - (itemViewH - relativeSize.height)/2;
    LGTTalkItemView *itemView = [LGTTalkItemView showOnView:[UIApplication sharedApplication].keyWindow frame:CGRectMake(itemViewX, itemViewY, itemViewW,itemViewH) itemTitles:itemTitles];
    itemView.delegate = self;
}
- (void)foldAction{
    if (self.FoldBlock) {
        self.FoldBlock();
    }
}
- (void)allContentAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (self.AllContentBlock) {
        self.AllContentBlock();
    }
}

#pragma mark - LGTTalkItemViewDelegate
- (void)LGTTalkItemView:(LGTTalkItemView *)itemView didSelectedItemAtIndex:(NSInteger)index itemTitle:(NSString *)itemTitle{
    if ([itemTitle containsString:@"删除"]) {
        if (self.ThemeDeleteBlock) {
            self.ThemeDeleteBlock();
        }
    }else if ([itemTitle containsString:@"置顶"]){
        if (self.SetTopBlock) {
            self.SetTopBlock(self.setTopBtn.selected);
        }
    }else if ([itemTitle containsString:@"回复"]){
        if (self.ReplyBlock) {
            self.ReplyBlock();
        }
    }
}
#pragma mark - Setter
- (void)setIsTop:(BOOL)isTop{
    _isTop = isTop;
    self.setTopBtn.selected = isTop;
}
- (void)setThemeDeleteEnable:(BOOL)themeDeleteEnable{
    _themeDeleteEnable = themeDeleteEnable;
    self.themeDeleteBtn.hidden = !themeDeleteEnable;
}
#pragma mark - Getter
- (UIImageView *)IconImageV{
    if (!_IconImageV) {
        _IconImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _IconImageV;
}
- (UIImageView *)sanjiaoImageV{
    if (!_sanjiaoImageV) {
         _sanjiaoImageV = [[UIImageView alloc] initWithImage:[UIImage lgt_imageNamed:@"chatSanjiao" atDir:@"Main"]];
    }
   return _sanjiaoImageV;
}
- (UILabel *)peopleNameL{
    if (!_peopleNameL) {
        _peopleNameL = [UILabel new];
        _peopleNameL.textColor = LGT_ColorWithHex(0x1379EC);
        _peopleNameL.font = [UIFont systemFontOfSize:15];
    }
    return _peopleNameL;
}
- (UILabel *)msgContentL{
    if (!_msgContentL) {
        _msgContentL = [UILabel new];
        _msgContentL.textColor = [UIColor darkGrayColor];
        _msgContentL.font = [UIFont systemFontOfSize:17];
        _msgContentL.numberOfLines = 0;
    }
    return _msgContentL;
}
- (UILabel *)msgTimeL{
    if (!_msgTimeL) {
        _msgTimeL = [UILabel new];
        _msgTimeL.textColor = LGT_ColorWithHex(0x989898);
        _msgTimeL.font = [UIFont systemFontOfSize:13];
    }
    return _msgTimeL;
}
- (UILabel *)msgSourceL{
    if (!_msgSourceL) {
        _msgSourceL = [UILabel new];
        _msgSourceL.textColor = LGT_ColorWithHex(0x555555);
        _msgSourceL.font = [UIFont systemFontOfSize:13];
    }
    return _msgSourceL;
}
- (LGTPhotoBrowser *)photoBrowser{
    if (!_photoBrowser) {
        CGFloat imageBgW = LGT_ScreenWidth - 44 - 10 - 10 - 10;
        if (LGT_IsIPad()) {
            imageBgW = 120 * 3;
        }
        _photoBrowser = [[LGTPhotoBrowser alloc] initWithFrame:CGRectZero width:imageBgW];
    }
    return _photoBrowser;
}
- (UIView *)imageBgV{
    if (!_imageBgV) {
        _imageBgV = [UIView new];
    }
    return _imageBgV;
}
- (UIButton *)allContentBtn{
    if (!_allContentBtn) {
        _allContentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allContentBtn setTitle:@"全文" forState:UIControlStateNormal];
        [_allContentBtn setTitle:@"收起" forState:UIControlStateSelected];
        [_allContentBtn setTitleColor:LGT_ColorWithHex(0x47A9EA) forState:UIControlStateNormal];
        _allContentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_allContentBtn addTarget:self action:@selector(allContentAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allContentBtn;
}

- (UIButton *)foldBtn{
    if (!_foldBtn) {
        _foldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_foldBtn setTitle:@"回复" forState:UIControlStateNormal];
        [_foldBtn setTitleColor:LGT_ColorWithHex(0x47A9EA) forState:UIControlStateNormal];
        [_foldBtn setImage:[UIImage lgt_imageNamed:@"reply_fold" atDir:@"Main"] forState:UIControlStateNormal];
        _foldBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_foldBtn addTarget:self action:@selector(foldAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _foldBtn;
}
- (UIButton *)replyBtn{
    if (!_replyBtn) {
        _replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         [_replyBtn setImage:[UIImage lgt_imageNamed:@"reply" atDir:@"Main"] forState:UIControlStateNormal];
         [_replyBtn addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyBtn;
}
- (UIButton *)setTopFlagBtn{
    if (!_setTopFlagBtn) {
        _setTopFlagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         _setTopFlagBtn.titleLabel.font = [UIFont systemFontOfSize:15];
         [_setTopFlagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_setTopFlagBtn setTitle:@"教师置顶" forState:UIControlStateNormal];
        [_setTopFlagBtn setBackgroundImage:[UIImage lgt_imageNamed:@"top_flag_tea" atDir:@"Main"] forState:UIControlStateNormal];
        [_setTopFlagBtn setTitle:@"我置顶的" forState:UIControlStateSelected];
        [_setTopFlagBtn setBackgroundImage:[UIImage lgt_imageNamed:@"top_flag_user" atDir:@"Main"] forState:UIControlStateSelected];
    }
    return _setTopFlagBtn;
}
- (UIButton *)themeDeleteBtn{
    if (!_themeDeleteBtn) {
        _themeDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _themeDeleteBtn;
}
- (UIButton *)setTopBtn{
    if (!_setTopBtn) {
        _setTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _setTopBtn;
}
@end
