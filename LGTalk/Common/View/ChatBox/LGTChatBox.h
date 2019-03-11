//
//  LGTChatBox.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/11/1.
//  Copyright © 2017年 lange. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HEIGHT_TABBAR       49
@class LGTChatBox;
@protocol LGTChatBoxDelegate <NSObject>

@optional
- (void)LGTChatBox:(LGTChatBox *) chatBox didChangeOffsetY:(CGFloat) offsetY;
- (void)LGTChatBox:(LGTChatBox *) chatBox didClickSend:(NSString *) sendContent;
- (void)LGTChatBoxDidRemoved;
@end
@interface LGTChatBox : UIView
@property(nonatomic,assign)NSInteger maxVisibleLine;
@property(nonatomic,assign)CGFloat superViewHight;
@property(nonatomic,weak)id<LGTChatBoxDelegate>delegate;
/** 占位符 */
@property (nonatomic,copy) NSString *placehold;
@end
