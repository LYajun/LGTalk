//
//  LGTClipView.h
//
//
//  Created by 刘亚军 on 2018/12/29.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGTClipView : UIView
/** 倒角位置 */
@property (nonatomic,strong) NSArray<NSString *> *clipDirections;
/** 倒角半径 */
@property (nonatomic,assign) CGFloat clipRadiu;
@end
