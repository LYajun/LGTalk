//
//  LGTPhotoBrowserAnimator.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/9/14.
//  Copyright © 2017年 lange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#pragma mark 图片开始浏览协议
@protocol LGTPhotoBrowserAnimatorPresentDelegate <NSObject>
/**
 获取图片浏览前的位置
 
 @param index 图片的下标
 @return 图片相对于window的位置
 */
- (CGRect)startRect:(NSInteger)index;

/**
 获取图片浏览中的位置
 
 @param index 图片的下标
 @return 图片在图片查看控制器中位置
 */
- (CGRect)endRect:(NSInteger)index;

/**
 获取当前要浏览的图片
 
 @param index 图片的下标
 @return 当前要浏览的图片
 */
- (UIImageView *)currentBrowseImageView:(NSInteger)index;

@end

#pragma mark 图片结束浏览协议
@protocol LGTPhotoBrowserAnimatorDismissDelegate <NSObject>
/**
 获取当前浏览的图片的下标
 
 @return 当前浏览图片的下标
 */
- (NSInteger)currentIndexForDismissView;

/**
 获取当前浏览的图片
 
 @return 当前浏览的图片
 */
- (UIImageView *)currentImageViewForDismissView;

@end
@interface LGTPhotoBrowserAnimator : NSObject<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
@property (nonatomic,assign) id<LGTPhotoBrowserAnimatorPresentDelegate> animationPresentDelegate;
@property (nonatomic,assign) id<LGTPhotoBrowserAnimatorDismissDelegate> animationDismissDelegate;
/**当前所要查看的图片*/
@property (nonatomic, assign) NSInteger index;
@end
