//
//  YJAnswerAlertCell.h
//  YJAnswernowledgeFramework
//
//  Created by 刘亚军 on 2018/11/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellHeight 46
@interface YJAnswerAlertCell : UICollectionViewCell
/** 标题 */
@property (nonatomic,copy) NSString *titleStr;
/** 点击高亮 */
@property (nonatomic,assign) BOOL clickHighlighted;

@property (nonatomic,assign) BOOL isSingle;
@end
