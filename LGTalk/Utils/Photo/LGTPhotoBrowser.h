//
//  LGTPhotoBrowser.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/9/14.
//  Copyright © 2017年 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGTPhotoBrowser : UIView
/**图片名信息*/
@property (nonatomic, strong) NSArray<NSString *> *imageNames;
/**图片地址信息*/
@property (nonatomic, strong) NSArray<NSString *> *imageUrls;
/** 背景颜色 */
@property (nonatomic,strong) UIColor *bgColor;
- (instancetype)initWithFrame:(CGRect)frame width:(CGFloat)width;
@end
