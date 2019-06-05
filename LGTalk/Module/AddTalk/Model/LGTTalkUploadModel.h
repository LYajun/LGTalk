//
//  LGTTalkUploadModel.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/11/2.
//  Copyright © 2017年 lange. All rights reserved.
//

#import "LGTBaseModel.h"

@interface LGTTalkUploadModel : LGTBaseModel

@property (nonatomic,copy) NSString *ID;
/** 用户ID */
@property (nonatomic,copy) NSString *UserID;
/** 用户头像 */
@property (nonatomic,copy) NSString *UserImg;
/** 用户名 */
@property (nonatomic,copy) NSString *UserName;
/** 主题内容 */
@property (nonatomic,copy) NSString *Content;
/** 任务ID */
@property (nonatomic,copy) NSString *AssignmentID;
/** 任务名 */
@property (nonatomic,copy) NSString *AssignmentName;
/** 学科ID */
@property (nonatomic,copy) NSString *SubjectID;
/** 学科名 */
@property (nonatomic,copy) NSString *SubjectName;
/** 教师ID */
@property (nonatomic,copy) NSString *TeacherID;
/** 教师名 */
@property (nonatomic,copy) NSString *TeacherName;
/** 资料ID */
@property (nonatomic,copy) NSString *ResID;
/** 资料名 */
@property (nonatomic,copy) NSString *ResName;
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

/** 系统ID */
@property (nonatomic,copy) NSString *SysID;
@end
