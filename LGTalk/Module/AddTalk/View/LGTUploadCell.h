//
//  LGTUploadCell.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/8/28.
//  Copyright © 2017年 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -
@interface LGTMoreCell : UICollectionViewCell

@end

#pragma mark -

@interface LGTUploadCell : UICollectionViewCell
@property (nonatomic,assign) BOOL isForbidLongGes;
@property (nonatomic,assign) BOOL isPanUnEndEdit;
@property (nonatomic,assign) BOOL isHideRemoveDeleteView;
@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic,copy) void (^deleteImgBlock) (UIImage *image);
@property (nonatomic,copy) void (^deleteBlock) (void);

@property (nonatomic,copy) void (^panStartBlock) (void);
@property (nonatomic,copy) void (^panEndBlock) (void);

@property (nonatomic,assign) BOOL isCancelPanGes;

- (void)setTaskImage:(UIImage *) taskImage;
@end
