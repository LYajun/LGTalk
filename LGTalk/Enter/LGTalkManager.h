//
//  LGTalkManager.h
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/6.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGTalkManager : NSObject
/** 服务器地址（登录的服务器设置地址） */
@property (nonatomic,copy) NSString *apiUrl;

/** 主页标题 默认：在线讨论*/
@property (nonatomic,copy) NSString *homeTitle;
/** 是否静止新建讨论功能 默认：NO*/
@property (nonatomic,assign) BOOL forbidAddTalk;

/** 用户ID */
@property (nonatomic,copy) NSString *userID;
/** 用户名 */
@property (nonatomic,copy) NSString *userName;
/** 用户类型 */
@property (nonatomic,assign) NSInteger userType;
/** 用户头像路径 */
@property (nonatomic,copy) NSString *photoPath;
/** 学校ID */
@property (nonatomic,copy) NSString *schoolID;

/** 任务ID */
@property (nonatomic,copy) NSString *assignmentID;
/** 任务名 */
@property (nonatomic,copy) NSString *assignmentName;
/** 资料ID */
@property (nonatomic,copy) NSString *resID;
/** 资料名 */
@property (nonatomic,copy) NSString *resName;

/** 教师ID */
@property (nonatomic,copy) NSString *teacherID;
/** 教师名 */
@property (nonatomic,copy) NSString *teachertName;
/** 学科ID */
@property (nonatomic,copy) NSString *subjectID;
/** 学科名 */
@property (nonatomic,copy) NSString *subjectName;
/** 系统ID */
@property (nonatomic,copy) NSString *systemID;

/** 在线讨论版本号 */
@property (nonatomic,copy) NSString *talkServiceVersion;
@property (nonatomic,strong) NSArray *talkClassIDArr1;
@property (nonatomic,strong) NSArray *talkTchIDArr1;
@property (nonatomic,strong) NSArray *talkClassIDArr2;
@property (nonatomic,strong) NSArray *talkTchIDArr2;
/** AI教材 */
/** 教材筛选Url */
@property (nonatomic,copy) NSString *mutiFilterUrl;
/** 当前第几课，0-全部，1-第1课 */
@property (nonatomic,assign) NSInteger mutiFilterIndex;

/** 传统教材 */
/** 传统教材信息 */
@property (nonatomic,strong,nullable) NSDictionary *traditionInfo;
/** 当前第几单元第几课，空0全部 */
@property (nonatomic,strong,nullable) NSIndexPath *mutiFilterIndexPath;

+ (LGTalkManager *)defaultManager;
- (void)resetParams;
- (void)presentKnowledgeControllerBy:(UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
