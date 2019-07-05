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
@property (nonatomic,copy) void (^deleteBlock) (void);
- (void)setTaskImage:(UIImage *) taskImage;
@end
