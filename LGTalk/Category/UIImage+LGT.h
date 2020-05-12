//
//  UIImage+LGT.h
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LGT)
+ (UIImage *)lgt_imageWithView:(UIView*)view;
+ (UIImage *)lgt_imageNamed:(NSString *)name;
+ (UIImage *)lgt_imageNamed:(NSString *)name atDir:(NSString *)dir;
+ (UIImage *)lgt_animatedImageNamed:(NSString *)name atDir:(NSString *)dir duration:(NSInteger)duration;
+ (UIImage *)lgt_imagePathName:(NSString *)name;
+ (UIImage *)lgt_imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)lgt_fixOrientation:(UIImage *)aImage;
@end
