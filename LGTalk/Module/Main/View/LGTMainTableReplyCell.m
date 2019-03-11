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

@interface LGTMainTableReplyCell ()
@property (strong, nonatomic) UILabel *msgContentL;
@property (strong, nonatomic) UIView *lineV;
@property (strong, nonatomic) LGTClipView *contentBg;
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
        make.left.equalTo(self.contentView).offset(56);
        make.right.equalTo(self.contentView).offset(-38);
    }];
    
    [self.contentBg addSubview:self.msgContentL];
    [self.msgContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentBg);
        make.left.equalTo(self.contentBg).offset(10);
        make.height.mas_greaterThanOrEqualTo(26);
        make.top.equalTo(self.contentBg).offset(5);
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
    if (quesModel.IsComment) {
        NSMutableAttributedString *attr = quesModel.UserName.lgt_toMutableAttributedString;
        [attr lgt_setFont:15];
        [attr lgt_setColor:LGT_ColorWithHexA(0x1379EC,0.9)];
        [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@":"]];
        [attr appendAttributedString:quesModel.Content_Attr];
        self.msgContentL.attributedText = attr;
    }else{
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"回复"];
         [attr lgt_setFont:15];
        NSMutableAttributedString *userNameAttr = quesModel.UserName.lgt_toMutableAttributedString;
        [userNameAttr lgt_setFont:15];
        [userNameAttr lgt_setColor:LGT_ColorWithHexA(0x1379EC,0.9)];
        [attr insertAttributedString:userNameAttr atIndex:0];
        NSMutableAttributedString *userNameToAttr = quesModel.UserNameTo.lgt_toMutableAttributedString;
        [userNameToAttr lgt_setFont:15];
        [userNameToAttr lgt_setColor:LGT_ColorWithHexA(0x1379EC,0.9)];
        [attr appendAttributedString:userNameToAttr];
        [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@":"]];
        [attr appendAttributedString:quesModel.Content_Attr];
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
@end
