//
//  LGTConst.m
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGTConst.h"
BOOL LGT_IsIPad(void){
    BOOL isIpad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    return isIpad;
}
BOOL LGT_IsIPhoneX(void){
    BOOL iPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneX;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    return iPhoneX;
}
CGFloat LGT_StateBarSpace(void){
    return (LGT_IsIPhoneX() ? 24 : 0);
}
CGFloat LGT_TabbarBarSpace(void){
    return (LGT_IsIPhoneX() ? 34 : 0);
}
CGFloat LGT_CustomNaviBarHeight(void){
    return (LGT_IsIPhoneX() ? 88 : 64);
}
CGFloat LGT_CustomTabbarBarHeight(void){
    return (LGT_IsIPhoneX() ? 83 : 49);
}
UIEdgeInsets LGT_TableEdgeInsets(void){
    if (LGT_IsIPhoneX()) {
        return UIEdgeInsetsMake(0, 0, 34, 0);
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

