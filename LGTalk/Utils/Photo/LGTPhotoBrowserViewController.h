//
//  LGTPhotoBrowserViewController.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/9/14.
//  Copyright © 2017年 lange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGTPhotoBrowserAnimator.h"

@interface LGTPhotoBrowserViewController : UIViewController<LGTPhotoBrowserAnimatorDismissDelegate>
/**图片名信息*/
@property (nonatomic, strong) NSArray<NSString *> *imageNames;
/**图片地址信息*/
@property (nonatomic, strong) NSArray<NSString *> *imageUrls;

@property (nonatomic, assign) NSInteger imageIndex;
@end
