//
//  LGTPullDownMenu.h
//  LGTPullDownMenuDemo
//
//  Created by 开发者 on 16/5/19.
//  Copyright © 2016年 jinxiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGTBaseTableViewCell.h"
#pragma mark -

@interface LGTPullDownButton : UIButton

@end

#pragma mark -

@protocol LGTPullDownMenuDelegate <NSObject>

@optional
- (void)LGTPullDownMenuDidShow;
- (void)LGTPullDownMenuDidHide;

@end

@interface LGTPullDownMenu : UIView

/* 分别为:选中cell的text、cell的index、cell对应的Button。 */
@property (nonatomic,copy) void (^handleSelectDataBlock) (NSString *selectTitle, NSUInteger selectIndex ,NSUInteger selectButtonTag);
/* 二维数组，存放每个Button对应下的TableView数据。。 */
@property (nonatomic,strong) NSArray *menuDataArray;
/** 行高 */
@property (nonatomic,assign) NSInteger rowHeight;
/** 最大显示行数 */
@property (nonatomic,assign) NSInteger maxDisplayRowNumber;

/** 默认选中 */
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,copy) NSString *currentSelTitle;

@property (nonatomic,assign) id<LGTPullDownMenuDelegate> delegate;
/** 是否可选 */
@property (nonatomic,assign) BOOL  selectable;

/* 数据源如果改变的话需调用此方法刷新数据。 */
-(void)setDefauldSelectedCell;
- (void)setTitle:(NSString *) title;
- (instancetype)initWithFrame:(CGRect)frame menuTitleArray:(NSArray *)titleArray;
-(void)takeBackTableView;
@end

#pragma mark -

@interface LGTdownMenuCell : LGTBaseTableViewCell

@property (nonatomic,strong) UIImageView  *selectImageView;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) BOOL  isSelected;

@end
