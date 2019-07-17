//
//  LGTPhotoManage.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/8/28.
//  Copyright © 2017年 lange. All rights reserved.
//

#import "LGTPhotoManage.h"
#import "LGTImagePickerController.h"
#import <LGAlertHUD/LGAlertHUD.h>

@interface LGTPhotoManage ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,LGTImagePickerControllerDelegate>

@end

@implementation LGTPhotoManage
+ (instancetype)manage{
    static LGTPhotoManage * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[LGTPhotoManage alloc]init];
        [macro configure];
    });
    return macro;
}
- (void)configure{
    _maximumNumberOfSelection = 4;
}
- (void)photoFromCamera{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;//设置类型为相机
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
//        picker.allowsEditing = YES;//设置照片可编辑
        picker.sourceType = sourceType;
        //        picker.showsCameraControls = NO;//默认为YES
        picker.cameraDevice=UIImagePickerControllerCameraDeviceRear;//选择前置摄像头或后置摄像头
        [self.ownController presentViewController:picker animated:YES completion:NULL];
        picker.delegate = self;//设置代理
    }else {
        [LGAlert showInfoWithStatus:@"本设备无相机"];
    }
}

- (void)photoFromAlbum{
    LGTImagePickerController *imagePickerController = [[LGTImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.maximumNumberOfSelection = self.maximumNumberOfSelection;
    imagePickerController.title = @"相册";
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.filterType = LGTImagePickerControllerFilterTypePhotos;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    navigationController.navigationBar.translucent = NO;
    [self.ownController presentViewController:navigationController animated:YES completion:NULL];
}
- (void)dismissImagePickerController
{
    [self.ownController dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - UIImagePickerControllerDelegate
//从相册选择图片后操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    //保存原始图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(LGTPhotoManage:cameraDidSelectImage:)]) {
        [self.delegate LGTPhotoManage:self cameraDidSelectImage:image];
    }
}
//取消操作时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissImagePickerController];
}
#pragma mark - LGTImagePickerControllerDelegate
- (void)imagePickerController:(LGTImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    NSLog(@"imagePickerController:didSelectAsset:%@", asset);
    [self dismissImagePickerController];
}

- (void)imagePickerController:(LGTImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSLog(@"imagePickerController:didSelectAssets:%@", assets);
    [self dismissImagePickerController];
    NSMutableArray*selectimgs = [[NSMutableArray alloc] init];
    for (int i = 0; i < assets.count; i++) {
        ALAsset *asset_sign=[assets objectAtIndex:i];
         UIImage *image =[UIImage imageWithCGImage:asset_sign.defaultRepresentation.fullScreenImage];
        [selectimgs addObject:image];
    }
    NSLog(@"selectimgs==%@",selectimgs);
    if (self.delegate &&[self.delegate respondsToSelector:@selector(LGTPhotoManage:albumDidSelectImage:)]) {
        [self.delegate LGTPhotoManage:self albumDidSelectImage:selectimgs];
    }
}

@end
