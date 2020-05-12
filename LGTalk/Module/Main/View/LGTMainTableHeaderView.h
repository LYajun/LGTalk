//
//  LGTMainTableHeaderView.h
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/7.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LGTTalkModel;
@interface LGTMainTableHeaderView : UITableViewHeaderFooterView
/** 回复Block */
@property (nonatomic,copy) void (^FoldBlock) (void);
@property (nonatomic,copy) void (^ReplyBlock) (void);
@property (nonatomic,copy) void (^SetTopBlock) (BOOL isTop);
@property (nonatomic,copy) void (^ThemeDeleteBlock) (void);
@property (nonatomic,copy) void (^MsgClickBlock) (void);
@property (nonatomic,copy) void (^AllContentBlock) (void);

/** 是否置顶 */
@property (nonatomic,assign) BOOL isTop;
/** 主题删除按钮可见性 */
@property (nonatomic,assign) BOOL themeDeleteEnable;
- (void)configByTalkModel:(LGTTalkModel *)talkModel;
@end

NS_ASSUME_NONNULL_END
