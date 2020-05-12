//
//  LGTBaseTableViewCell.h
//
//
//  Created by 刘亚军 on 2018/11/5.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGTConst.h"

@interface LGTBaseTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL isShowSeparator;
@property (nonatomic, assign) CGFloat separatorOffset;
@property (nonatomic,strong) UIColor *sepColor;
@end
