//
//  LGTPhotoManage.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/8/28.
//  Copyright © 2017年 lange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class LGTPhotoManage;
@protocol LGTPhotoManageDelegate <NSObject>
@optional
/** 拍照照片 */
- (void)LGTPhotoManage:(LGTPhotoManage *) manage cameraDidSelectImage:(UIImage *) selectImage;
/** 从相册中选取的照片 */
- (void)LGTPhotoManage:(LGTPhotoManage *) manage albumDidSelectImage:(NSArray *) selectImages;
@end
@interface LGTPhotoManage : NSObject
@property (nonatomic,weak) UIViewController *ownController;
/** 最大可选照片数 */
@property (nonatomic,assign) NSInteger maximumNumberOfSelection;
@property (nonatomic,assign) id<LGTPhotoManageDelegate> delegate;
+ (instancetype)manage;
/** 拍照 */
- (void)photoFromCamera;
/** 从相册中选取照片 */
- (void)photoFromAlbum;
@end
