//
//  LGTImageDeleteView.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2019/4/28.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGTImageDeleteView : UIView
+ (LGTImageDeleteView *)showTalkImageDeleteViewAtBottom:(BOOL)isBottom;
+ (LGTImageDeleteView *)showTalkImageDeleteViewAtBottom:(BOOL)isBottom keyboardHeight:(CGFloat)keyboardHeight;
- (void)setDeleteViewDeleteState;
- (void)setDeleteViewNormalState;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
