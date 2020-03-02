//
//  YJAnswerConst.m
//  LGAlertHUDDemo
//
//  Created by 刘亚军 on 2020/1/8.
//  Copyright © 2020 刘亚军. All rights reserved.
//

#import "YJAnswerConst.h"

@interface LGAlertBundleModel : NSObject

@end
@implementation LGAlertBundleModel

@end


NSBundle *LGAlertBundle(void){
    return [NSBundle yj_bundleWithCustomClass:LGAlertBundleModel.class bundleName:@"LGAlertHUD"];
}
