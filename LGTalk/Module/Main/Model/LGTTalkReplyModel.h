//
//  LGTTalkReplyModel.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/11/2.
//  Copyright © 2017年 lange. All rights reserved.
//

#import "LGTBaseModel.h"

@interface LGTTalkReplyModel : LGTBaseModel

@property (nonatomic,copy) NSString *ID;
/** 用户ID */
@property (nonatomic,copy) NSString *UserID;
/** 用户头像 */
@property (nonatomic,copy) NSString *UserImg;
/** 用户名 */
@property (nonatomic,copy) NSString *UserName;

/** 回复用户ID */
@property (nonatomic,copy) NSString *UserIDTo;
/** 回复用户头像 */
@property (nonatomic,copy) NSString *UserNameTo;
/** 回复用户名 */
@property (nonatomic,copy) NSString *UserImgTo;
/** 主题内容 */
@property (nonatomic,copy) NSString *Content;
/** 创建时间 */
@property (nonatomic,copy) NSString *CreateTime;
/** 上传图片数组 */
@property (nonatomic,strong) NSArray *ImgUrlList;

/** 是否针对发布人回复 */
@property (nonatomic,assign) BOOL IsComment;
/** 主题ID */
@property (nonatomic,copy) NSString *QuesThemeID;
@end
