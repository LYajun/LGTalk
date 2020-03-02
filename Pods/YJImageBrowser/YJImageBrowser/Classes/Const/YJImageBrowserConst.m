//
//  YJImageBrowser.m
//
//  Created by 刘亚军 on 2019/6/20.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJImageBrowserConst.h"


@interface YJImageBrowserBundleModel : NSObject

@end
@implementation YJImageBrowserBundleModel

@end

NSBundle *YJImageBrowserBundle(void){
   return [NSBundle yj_bundleWithCustomClass:YJImageBrowserBundleModel.class bundleName:@"YJImageBrowser"];
}

