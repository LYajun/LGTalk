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
            h = [attr boundingRectWithSize:CGSizeMake((LGT_ScreenWidth-(56+38) - 20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 10+6;
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
   
        h = [attr boundingRectWithSize:CGSizeMake((LGT_ScreenWidth-(56+38) - 20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 10+6;
    }
    
    return h;
}
@end
@implementation LGTTalkModel
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
    if (LGT_IsStrEmpty(Content)) {
        _contentHeight = 0;
    }else{
        _contentHeight = [_Content_Attr boundingRectWithSize:CGSizeMake((LGT_ScreenWidth-(54+2) -10), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 6;
    }
}
- (CGFloat)tableHeaderHeight{
    CGFloat imageBgHeight = 0;
    if (!LGT_IsArrEmpty(self.ImgUrlList)) {
        CGFloat imageBgW = LGT_ScreenWidth - 44 - 10 - 2  - 10;
        imageBgHeight = imageBgW/3;
    }
    return 54 + 3 + self.contentHeight + 3 + imageBgHeight + 5 + 20 + 10;
}
@end
