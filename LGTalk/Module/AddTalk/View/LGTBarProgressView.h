//
//  BarProgressView.h
//  LGTWritting
//
//  Created by 刘亚军 on 16/7/25.
//  Copyright © 2016年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGTBarProgressView : UIView

@property (assign, nonatomic) IBInspectable CGFloat progress;
@property (strong, nonatomic) IBInspectable UIColor* tintColor;
@property (strong, nonatomic) IBInspectable UIColor* bgColor;
@end
