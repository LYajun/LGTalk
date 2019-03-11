//
//  LGTImagePickerController.h
//  LGTImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/30.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSUInteger, LGTImagePickerControllerFilterType) {
    LGTImagePickerControllerFilterTypeNone,
    LGTImagePickerControllerFilterTypePhotos,
    LGTImagePickerControllerFilterTypeVideos
};

UIKIT_EXTERN ALAssetsFilter * ALAssetsFilterFromLGTImagePickerControllerFilterType(LGTImagePickerControllerFilterType type);

@class LGTImagePickerController;

@protocol LGTImagePickerControllerDelegate <NSObject>

@optional
- (void)imagePickerController:(LGTImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset;
- (void)imagePickerController:(LGTImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets;
- (void)imagePickerControllerDidCancel:(LGTImagePickerController *)imagePickerController;

@end

@interface LGTImagePickerController : UITableViewController

@property (nonatomic, strong, readonly) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, copy, readonly) NSArray *assetsGroups;
@property (nonatomic, strong, readonly) NSMutableSet *selectedAssetURLs;

@property (nonatomic, weak) id<LGTImagePickerControllerDelegate> delegate;
@property (nonatomic, copy) NSArray *groupTypes;
@property (nonatomic, assign) LGTImagePickerControllerFilterType filterType;
@property (nonatomic, assign) BOOL showsCancelButton;
@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;

+ (BOOL)isAccessible;

@end
