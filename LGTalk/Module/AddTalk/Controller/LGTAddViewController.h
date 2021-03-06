//
//  LGTAddViewController.h
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/7.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGTAddViewController : LGTBaseViewController

/** 资料ID */
@property (nonatomic,copy) NSString *resID;
/** 资料名 */
@property (nonatomic,copy) NSString *resName;
/** 来源 */
@property (nonatomic,copy) NSString *talkSource;
/** 发布成功回调 */
@property (nonatomic,copy) void (^addSccessBlock) (void);
@end

NS_ASSUME_NONNULL_END
