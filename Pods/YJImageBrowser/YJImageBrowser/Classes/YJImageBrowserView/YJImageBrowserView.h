//
//  YJImageBrowserView.h
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/7/3.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJImageBrowserView : UIView

+ (void)showWithImageUrls:(NSArray *)imageUrls atIndex:(NSInteger)index;
+ (void)showWithImages:(NSArray *)images atIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
