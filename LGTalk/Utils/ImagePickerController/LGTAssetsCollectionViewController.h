//
//  LGTAssetsCollectionViewController.h
//  LGTImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

// ViewControllers
#import "LGTImagePickerController.h"

@class LGTAssetsCollectionViewController;

@protocol LGTAssetsCollectionViewControllerDelegate <NSObject>

@optional
- (void)assetsCollectionViewController:(LGTAssetsCollectionViewController *)assetsCollectionViewController didSelectAsset:(ALAsset *)asset;
- (void)assetsCollectionViewController:(LGTAssetsCollectionViewController *)assetsCollectionViewController didDeselectAsset:(ALAsset *)asset;
- (void)assetsCollectionViewControllerDidFinishSelection:(LGTAssetsCollectionViewController *)assetsCollectionViewController;

@end

@interface LGTAssetsCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) LGTImagePickerController *imagePickerController;

@property (nonatomic, weak) id<LGTAssetsCollectionViewControllerDelegate> delegate;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, assign) LGTImagePickerControllerFilterType filterType;
@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;

- (void)selectAssetHavingURL:(NSURL *)URL;

@end
