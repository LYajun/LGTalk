//
//  LGTTalkModel.h
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/6.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface LGTTalkQuesModel : LGTBaseModel
@property (nonatomic,copy) NSString *ID;
/** 主题ID */
@property (nonatomic,copy) NSString *QuesThemeID;
/** 用户ID */
@property (nonatomic,copy) NSString *UserID;
/** 用户头像 */
@property (nonatomic,copy) NSString *UserImg;
/** 用户名 */
@property (nonatomic,copy) NSString *UserName;
/** 用户类型 */
@property (nonatomic,copy) NSString *UserType;
/** 回复用户ID */
@property (nonatomic,copy) NSString *UserIDTo;
/** 回复用户头像 */
@property (nonatomic,copy) NSString *UserNameTo;
/** 回复用户类型 */
@property (nonatomic,copy) NSString *UserTypeTo;
/** 回复用户名 */
@property (nonatomic,copy) NSString *UserImgTo;
/** 主题内容 */
@property (nonatomic,copy) NSString *Content;
@property (nonatomic,strong) NSMutableAttributedString *Content_Attr;
/** 是否针对发布人回复 */
@property (nonatomic,assign) BOOL IsComment;
/** 创建时间 */
@property (nonatomic,copy) NSString *CreateTime;
/** 上传图片数组 */
@property (nonatomic,strong) NSArray *ImgUrlList;

- (CGFloat)tableCellHeight;

@end

@interface LGTTalkModel : LGTBaseModel
/** 是否置顶 */
@property (nonatomic,assign) BOOL IsTop;
/** 置顶类型(老师置顶为1、学生置顶为2) */
@property (nonatomic,assign) NSInteger TopUserType;

@property (nonatomic,copy) NSString *ID;
/** 用户ID */
@property (nonatomic,copy) NSString *UserID;
/** 用户头像 */
@property (nonatomic,copy) NSString *UserImg;
/** 用户名 */
@property (nonatomic,copy) NSString *UserName;
/** 主题内容 */
@property (nonatomic,copy) NSString *Content;
@property (nonatomic,strong) NSMutableAttributedString *Content_Attr;
@property (nonatomic,assign) CGFloat contentHeight;
/** 任务ID */
@property (nonatomic,copy) NSString *AssignmentID;
/** 资料ID */
@property (nonatomic,copy) NSString *ResID;
/** 大题ID */
@property (nonatomic,copy) NSString *TopicID;

/** 来源哪个题 */
@property (nonatomic,copy) NSString *FromTopicInfo;
/** 来源 */
@property (nonatomic,assign) NSInteger FromTopicIndex;
/** 创建时间 */
@property (nonatomic,copy) NSString *CreateTime;
/** 上传图片数组 */
@property (nonatomic,strong) NSArray *ImgUrlList;

/** 新增是否折叠属性 */
@property (nonatomic,assign) BOOL isFold;
/** 问题回复数组 */
@property (nonatomic,strong) NSArray<LGTTalkQuesModel *> *CommentList;

- (CGFloat)tableHeaderHeight;
@end

NS_ASSUME_NONNULL_END
