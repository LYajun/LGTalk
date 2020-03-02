//
//  UIImage+YJ.m
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "UIImage+YJ.h"
#import "NSBundle+YJ.h"

@implementation UIImage (YJ)
#pragma mark - Bundle资源
+ (UIImage *)yj_imageNamed:(NSString *)name atBundle:(nonnull NSBundle *)bundle{
    return [self yj_imageNamed:name atDir:nil atBundle:bundle];
}
+ (UIImage *)yj_imageNamed:(NSString *)name atDir:(NSString *)dir atBundle:(nonnull NSBundle *)bundle{
    NSString *namePath = name;
    if (dir && dir.length > 0) {
        namePath = [dir stringByAppendingPathComponent:namePath];
    }
    return [UIImage imageNamed:[bundle yj_bundlePathWithName:namePath]];
}
+ (UIImage *)yj_imagePathName:(NSString *)name atDir:(NSString *)dir atBundle:(NSBundle *)bundle{
    NSString *namePath = name;
    if (dir && dir.length > 0) {
        namePath = [dir stringByAppendingPathComponent:namePath];
    }
    return [UIImage yj_imagePathName:namePath atBundle:bundle];
}
+ (UIImage *)yj_imagePathName:(NSString *)name atBundle:(nonnull NSBundle *)bundle{
    return [UIImage imageWithContentsOfFile:[bundle yj_bundlePathWithName:name]];
}
+ (UIImage *)yj_animatedImageNamed:(NSString *)name atDir:(NSString *)dir duration:(NSInteger)duration atBundle:(nonnull NSBundle *)bundle{
    NSString *namePath = name;
    if (dir && dir.length > 0) {
        namePath = [dir stringByAppendingPathComponent:namePath];
    }
    return [UIImage animatedImageNamed:[bundle yj_bundlePathWithName:namePath] duration:duration];
}

+ (NSArray *)yj_animationImagesWithImageName:(NSString *)name atDir:(NSString *)dir atBundle:(NSBundle *)bundle{
    NSFileManager *fielM = [NSFileManager defaultManager];
    NSArray *arrays = [fielM contentsOfDirectoryAtPath:[bundle yj_bundlePathWithName:dir] error:nil];
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 0; i < arrays.count; i++) {
        UIImage *image = [UIImage yj_imageNamed:[NSString stringWithFormat:@"%@%li",name,i] atDir:dir atBundle:bundle];
        if (image) {
            [imageArr addObject:image];
        }
    }
    return imageArr;
}
+ (UIImage *)yj_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
            
            duration += [self yj_frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}

+ (float)yj_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

+ (UIImage *)yj_animatedGIFNamed:(NSString *)name atDir:(nonnull NSString *)dir atBundle:(nonnull NSBundle *)bundle{
    name = [dir stringByAppendingPathComponent:name];
    CGFloat scale = [UIScreen mainScreen].scale;
    
    if (scale > 1.0f) {
        NSString *retinaPath = [bundle pathForResource:[name stringByAppendingFormat:@"@%.fx",scale] ofType:@"gif"];
        
        NSData *data = [NSData dataWithContentsOfFile:retinaPath];
        
        if (data) {
            return [UIImage yj_animatedGIFWithData:data];
        }
        
        NSString *path = [bundle pathForResource:name ofType:@"gif"];
        
        data = [NSData dataWithContentsOfFile:path];
        
        if (data) {
            return [UIImage yj_animatedGIFWithData:data];
        }
        
        return [UIImage yj_imageNamed:name atBundle:bundle];
    }
    else {
        NSString *path = [bundle pathForResource:name ofType:@"gif"];
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        if (data) {
            return [UIImage yj_animatedGIFWithData:data];
        }
        
        return [UIImage yj_imageNamed:name atBundle:bundle];
    }
}

#pragma mark - UIView转UIImage
+ (UIImage *)yj_imageWithView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)yj_imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
#pragma mark - UIImage处理
-(UIImage *)yj_transformtoSize:(CGSize)Newsize{
    // 创建一个bitmap的context
    UIGraphicsBeginImageContext(Newsize);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, Newsize.width, Newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *TransformedImg=UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return TransformedImg;
}
+ (UIImage *)yj_fixOrientation:(UIImage *)aImage{
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
