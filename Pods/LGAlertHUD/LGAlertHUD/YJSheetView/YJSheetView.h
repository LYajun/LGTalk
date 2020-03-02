//
//  YJSheetView.h
//  LGAlertHUDDemo
//
//  Created by 刘亚军 on 2019/10/11.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJSheetView : UIView
+ (YJSheetView *)sheetViewWithTitle:(NSString *_Nullable)title canceTitle:(NSString *) canceTitle buttonTitles:(NSArray *)buttonTitles buttonBlock:(void (^_Nullable) (NSInteger index)) buttonBlock cancelBlock:(void (^_Nullable)(void)) cancelBlock;
- (void)showOnView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
