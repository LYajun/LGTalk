//
//  LGTTalkItemView.h
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/7.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LGTTalkItemView;
@protocol LGTTalkItemViewDelegate <NSObject>

@optional
- (void)LGTTalkItemView:(LGTTalkItemView *)itemView didSelectedItemAtIndex:(NSInteger)index itemTitle:(NSString *)itemTitle;

@end
@interface LGTTalkItemView : UIView
@property (nonatomic,assign) id<LGTTalkItemViewDelegate> delegate;
+ (LGTTalkItemView *)showOnView:(UIView *)view frame:(CGRect)frame itemTitles:(NSArray *)itemTitles;
@end

NS_ASSUME_NONNULL_END
