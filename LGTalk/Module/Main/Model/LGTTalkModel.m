//
//  LGTTalkModel.m
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/6.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTTalkModel.h"
#import "LGTConst.h"
#import "LGTExtension.h"

@implementation LGTTalkQuesModel
- (NSString *)UserType{
    if (!_UserType) {
        return @"2";
    }
    return _UserType;
}
- (NSString *)UserTypeTo{
    if (!_UserTypeTo) {
        return @"2";
    }
    return _UserTypeTo;
}
- (void)setContent:(NSString *)Content{
    if (!LGT_IsStrEmpty(Content)) {
        Content = [Content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    }
    _Content = Content;
    _Content_Attr = Content.lgt_htmlImgFrameAdjust.lgt_toHtmlMutableAttributedString;
    [_Content_Attr lgt_setFont:15];
}
- (CGFloat)tableCellHeight{
    CGFloat h = 0;
    if (self.IsComment) {
        if (!LGT_IsStrEmpty(self.Content)) {
            NSMutableAttributedString *attr = self.UserName.lgt_toMutableAttributedString;
            [attr lgt_setFont:15];
            [attr lgt_setColor:LGT_ColorWithHexA(0x1379EC,0.9)];
            [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@":"]];
            [attr appendAttributedString:self.Content_Attr];
            [attr lgt_addParagraphLineSpacing:5];
            if (IsIPad) {
                h = [attr boundingRectWithSize:CGSizeMake((LGT_ScreenWidth-(74+22) - 20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 10+6;
            }else{
                h = [attr boundingRectWithSize:CGSizeMake((LGT_ScreenWidth-(64+12) - 20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 10+6;
            }

        }
    }else{
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"回复"];
        [attr lgt_setFont:15];
        NSMutableAttributedString *userNameAttr = self.UserName.lgt_toMutableAttributedString;
        [userNameAttr lgt_setFont:15];
        [userNameAttr lgt_setColor:LGT_ColorWithHexA(0x1379EC,0.9)];
        [attr insertAttributedString:userNameAttr atIndex:0];
        NSMutableAttributedString *userNameToAttr = self.UserNameTo.lgt_toMutableAttributedString;
        [userNameToAttr lgt_setFont:15];
        [userNameToAttr lgt_setColor:LGT_ColorWithHexA(0x1379EC,0.9)];
        [attr appendAttributedString:userNameToAttr];
        [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@":"]];
        [attr appendAttributedString:self.Content_Attr];
   
        [attr lgt_addParagraphLineSpacing:5];
        if (IsIPad) {
            h = [attr boundingRectWithSize:CGSizeMake((LGT_ScreenWidth-(74+22) - 20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 10+6;
        }else{
            
            h = [attr boundingRectWithSize:CGSizeMake((LGT_ScreenWidth-(64+12) - 20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 10+6;
        }

    }
    
    return h;
}
@end
@implementation LGTTalkModel
- (instancetype)initWithDictionary:(NSDictionary *)aDictionary{
    if (self = [super initWithDictionary:aDictionary]) {
        _isFold = YES;
    }
    return self;
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"CommentList":[LGTTalkQuesModel class]};
}
- (void)setContent:(NSString *)Content{
    if (!LGT_IsStrEmpty(Content)) {
        Content = [Content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    }
    _Content = Content;
    _Content_Attr = Content.lgt_htmlImgFrameAdjust.lgt_toHtmlMutableAttributedString;
    [_Content_Attr lgt_setFont:17];
    [_Content_Attr lgt_addParagraphLineSpacing:5];
    if (LGT_IsStrEmpty(Content)) {
        _contentHeight = 0;
    }else{
        if (IsIPad) {
            _contentHeight = [_Content_Attr boundingRectWithSize:CGSizeMake((LGT_ScreenWidth-(44 + 20 + 10) -20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 6;
        }else{
            _contentHeight = [_Content_Attr boundingRectWithSize:CGSizeMake((LGT_ScreenWidth-(44 + 10 + 10) -10), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 6;
        }

    }
}
- (CGFloat)tableHeaderHeight{
    CGFloat imageBgHeight = 0;
    if (!LGT_IsArrEmpty(self.ImgUrlList)) {
        CGFloat imageBgW = LGT_ScreenWidth - 44 - 10 - 10 - 10;
        if (LGT_IsIPad()) {
            imageBgW = 120 * 3;
        }
        imageBgHeight = imageBgW/3;
    }
    if (IsIPad) {
        return 44 + 20 + 3 + self.contentHeight + 3 + imageBgHeight + 5 + 26 + 10;
    }
    return 44 + 10 + 3 + self.contentHeight + 3 + imageBgHeight + 5 + 23 + 10;

}
@end
