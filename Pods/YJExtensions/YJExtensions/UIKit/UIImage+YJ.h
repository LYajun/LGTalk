//
//  UIImage+YJ.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (YJ)

#pragma mark - Bundle资源
+ (UIImage *)yj_imageNamed:(NSString *)name atBundle:(NSBundle *)bundle;
+ (UIImage *)yj_imageNamed:(NSString *)name atDir:(nullable NSString *)dir atBundle:(NSBundle *)bundle;
+ (UIImage *)yj_animatedImageNamed:(NSString *)name atDir:(nullable NSString *)dir duration:(NSInteger)duration atBundle:(NSBundle *)bundle;
+ (UIImage *)yj_imagePathName:(NSString *)name atBundle:(NSBundle *)bundle;
+ (UIImage *)yj_imagePathName:(NSString *)name atDir:(nullable NSString *)dir atBundle:(NSBundle *)bundle;
+ (UIImage *)yj_animatedGIFNamed:(NSString *)name atDir:(nonnull NSString *)dir atBundle:(nonnull NSBundle *)bundle;
+ (NSArray *)yj_animationImagesWithImageName:(NSString *)name atDir:(NSString *)dir atBundle:(NSBundle *)bundle;
#pragma mark - UIView转UIImage
+ (UIImage *)yj_imageWithView:(UIView*)view;
+ (UIImage *)yj_imageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark - UIImage处理
- (UIImage *)yj_transformtoSize:(CGSize)Newsize;
+ (UIImage *)yj_fixOrientation:(UIImage *)aImage;

@end

NS_ASSUME_NONNULL_END
