//
//  YJImageBrowserScrollView.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2019/4/30.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJImageBrowserScrollView : UIScrollView
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,strong) UIImage *scrollImg;
@property (nonatomic,copy) void (^ClickBlock) (void);
@end

NS_ASSUME_NONNULL_END
