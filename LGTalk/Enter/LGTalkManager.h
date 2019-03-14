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
/** 资料ID */
@property (nonatomic,copy) NSString *resID;
/** 资料名 */
@property (nonatomic,copy) NSString *resName;

+ (LGTalkManager *)defaultManager;

- (void)presentKnowledgeControllerBy:(UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
