//
//  LGTConst.h
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 日志文件
#ifndef __OPTIMIZE__
#define LGTLog(...) NSLog(@"*************************\n%s\n%d\n%@\n*************************",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define LGTLog(...) {}
#define NSLog(...) {}
#endif


// 屏幕尺寸
#define LGT_ScreenWidth      [UIScreen mainScreen].bounds.size.width
#define LGT_ScreenHeight     [UIScreen mainScreen].bounds.size.height

// 常用颜色
#define LGT_ColorWithHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define LGT_ColorWithHexA(rgbValue,aValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:aValue]

// 是否为空
#define LGT_IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
#define LGT_IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))
#define LGT_IsObjEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
#define LGT_ApiParams(_ref)    (LGT_IsObjEmpty(_ref) ? @"" : _ref)

//弱引用化
#define WeakObj(o)      __weak typeof(o) o##Weak = o
#define StrongObj(o)    __strong typeof(o) o##Strong = o
#define WeakSelf        WeakObj(self)


BOOL LGT_IsIPhoneX(void);
CGFloat LGT_StateBarSpace(void);
CGFloat LGT_TabbarBarSpace(void);
CGFloat LGT_CustomNaviBarHeight(void);
CGFloat LGT_CustomTabbarBarHeight(void);
UIEdgeInsets LGT_TableEdgeInsets(void);

