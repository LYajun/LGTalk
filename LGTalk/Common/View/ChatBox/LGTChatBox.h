//
//  LGTChatBox.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/11/1.
//  Copyright © 2017年 lange. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IsIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define HEIGHT_TABBAR       (49 + (IsIPad ? 80 : 60))
@class LGTChatBox;
@protocol LGTChatBoxDelegate <NSObject>

@optional
- (void)LGTChatBox:(LGTChatBox *) chatBox didChangeOffsetY:(CGFloat) offsetY;
- (void)LGTChatBox:(LGTChatBox *) chatBox didClickSend:(NSString *) sendContent selectImgs:(NSArray *)imgs;
- (void)LGTChatBox:(LGTChatBox *) chatBox didEndEditWithContent:(NSString *)content;
- (void)LGTChatBox:(LGTChatBox *) chatBox didSelectImgs:(NSArray *)imgs;
- (void)LGTChatBoxKeyboardWillHide;
- (void)LGTChatBoxDidRemoved;
@end
@interface LGTChatBox : UIView
@property(nonatomic,assign)NSInteger maxVisibleLine;
@property(nonatomic,assign)CGFloat superViewHight;
@property(nonatomic,weak)id<LGTChatBoxDelegate>delegate;
@property (nonatomic,weak) UIViewController *ownController;
/** 占位符 */
@property (nonatomic,copy) NSString *placehold;

@property (nonatomic,copy) NSString *currentMsg;
@property (nonatomic,strong) NSArray *currentImgs;

@end
