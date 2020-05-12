//
//  LGTMainTableReplyCell.m
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/7.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTMainTableReplyCell.h"
#import "LGTTalkModel.h"
#import "LGTClipView.h"
#import <Masonry/Masonry.h>
#import "LGTConst.h"
#import "LGTExtension.h"
#import "LGTPhotoBrowser.h"

@interface LGTMainTableReplyCell ()
@property (strong, nonatomic) UILabel *msgContentL;
@property (strong, nonatomic) UIView *lineV;
@property (strong, nonatomic) LGTClipView *contentBg;
@property (strong, nonatomic) UIView *imageBgV;
@property (strong,nonatomic)  LGTPhotoBrowser *photoBrowser;
@end
@implementation LGTMainTableReplyCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.contentBg.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.contentBg.backgroundColor = LGT_ColorWithHex(0xEBEBEB);
    }
}
- (void)layoutUI{
     self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.contentBg];
    [self.contentBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(IsIPad ? 74 : 64);
        make.right.equalTo(self.contentView).offset(IsIPad ? -22 : -12);
    }];
    
    [self.contentBg addSubview:self.imageBgV];
    [self.imageBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(80);
        make.left.equalTo(self.contentBg).offset(10);
        make.right.equalTo(self.contentBg);
        make.bottom.equalTo(self.contentBg).offset(-5);
    }];
    
    [self.imageBgV addSubview:self.photoBrowser];
    [self.photoBrowser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(self.imageBgV);
        make.width.mas_equalTo(self.imageBgV.mas_height).multipliedBy(3);
    }];
    
    [self.contentBg addSubview:self.msgContentL];
    [self.msgContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentBg);
        make.left.equalTo(self.contentBg).offset(10);
        make.height.mas_greaterThanOrEqualTo(26);
        make.top.equalTo(self.contentBg).offset(5);
        make.bottom.equalTo(self.imageBgV.mas_top).offset(0);
    }];
    
    [self.contentBg addSubview:self.lineV];
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentBg);
        make.left.equalTo(self.contentBg).offset(10);
        make.bottom.equalTo(self.contentBg);
        make.height.mas_equalTo(1);
    }];
}
- (void)setRowNum:(LGTMainTableReplyCellRowNum)rowNum{
    switch (rowNum) {
        case onlyOne:
        {
            self.contentBg.clipDirections = @[@"TopLeft",@"TopRight",@"BottomLeft",@"BottomRight"];
            self.contentBg.clipRadiu = 5;
            self.lineV.hidden = YES;
        }
            break;
        case first:
        {
            self.contentBg.clipDirections = @[@"TopLeft",@"TopRight"];
            self.contentBg.clipRadiu = 5;
            self.lineV.hidden = NO;
        }
            break;
        case middle:
        {
            
            self.contentBg.clipRadiu = 0;
            self.lineV.hidden = NO;
        }
            break;
        case last:
        {
            
            self.contentBg.clipDirections = @[@"BottomLeft",@"BottomRight"];
            self.contentBg.clipRadiu = 5;
            self.lineV.hidden = YES;
        }
            break;
        default:
            break;
    }
}
- (void)configByQuesModel:(LGTTalkQuesModel *)quesModel{
    if (LGT_IsArrEmpty(quesModel.ImgUrlList)) {
        [self.imageBgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else{
        CGFloat imageBgW = 60 * 3;
        if (IsIPad) {
            imageBgW = 100 * 3;
        }
        [self.imageBgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(imageBgW/3);
        }];
        self.photoBrowser.imageUrls = quesModel.ImgUrlList;
    }
    if (quesModel.IsComment) {
        NSMutableAttributedString *attr = quesModel.UserName.lgt_toMutableAttributedString;
        [attr lgt_setFont:15];
        if ([quesModel.UserType integerValue] != 2) {
            [attr lgt_setColor:[UIColor redColor]];
        }else{
            [attr lgt_setColor:LGT_ColorWithHexA(0x1379EC,0.9)];
        }
        [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@": "]];
        [attr appendAttributedString:quesModel.Content_Attr];
        [attr lgt_addParagraphLineSpacing:5];
        self.msgContentL.attributedText = attr;
    }else{
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"回复"];
         [attr lgt_setFont:15];
        NSMutableAttributedString *userNameAttr = quesModel.UserName.lgt_toMutableAttributedString;
        [userNameAttr lgt_setFont:15];
        if ([quesModel.UserType integerValue] != 2) {
             [userNameAttr lgt_setColor:[UIColor redColor]];
        }else{
            [userNameAttr lgt_setColor:LGT_ColorWithHexA(0x1379EC,0.9)];
        }
        [attr insertAttributedString:userNameAttr atIndex:0];
        NSMutableAttributedString *userNameToAttr = quesModel.UserNameTo.lgt_toMutableAttributedString;
        [userNameToAttr lgt_setFont:15];
         if ([quesModel.UserTypeTo integerValue] != 2) {
             [userNameToAttr lgt_setColor:[UIColor redColor]];
         }else{
             [userNameToAttr lgt_setColor:LGT_ColorWithHexA(0x1379EC,0.9)];
         }
        [attr appendAttributedString:userNameToAttr];
        [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@": "]];
        [attr appendAttributedString:quesModel.Content_Attr];
        [attr lgt_addParagraphLineSpacing:5];
        self.msgContentL.attributedText = attr;
    }
    self.msgContentL.lineBreakMode = NSLineBreakByTruncatingTail;
}
- (UILabel *)msgContentL{
    if (!_msgContentL) {
        _msgContentL = [UILabel new];
        _msgContentL.numberOfLines = 0;
    }
    return _msgContentL;
}
- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] initWithFrame:CGRectZero];
        _lineV.backgroundColor = LGT_ColorWithHex(0xB8B8B8);
    }
    return _lineV;
}
- (LGTClipView *)contentBg{
    if (!_contentBg) {
        _contentBg = [[LGTClipView alloc] initWithFrame:CGRectZero];
        _contentBg.backgroundColor = LGT_ColorWithHex(0xEBEBEB);
    }
    return _contentBg;
}
- (LGTPhotoBrowser *)photoBrowser{
    if (!_photoBrowser) {
        CGFloat imageBgW = 60*3;
        if (IsIPad) {
            imageBgW = 100 * 3;
        }
        _photoBrowser = [[LGTPhotoBrowser alloc] initWithFrame:CGRectZero width:imageBgW];
        _photoBrowser.bgColor = LGT_ColorWithHex(0xEBEBEB);
    }
    return _photoBrowser;
}
- (UIView *)imageBgV{
    if (!_imageBgV) {
        _imageBgV = [UIView new];
    }
    return _imageBgV;
}
@end
