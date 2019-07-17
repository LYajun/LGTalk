//
//  LGTAddViewController.m
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/7.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTAddViewController.h"
#import "LGTUploadCell.h"
#import "LGTBaseTextView.h"
#import "LGTTalkUploadModel.h"
#import "LGTPhotoManage.h"
#import <Masonry/Masonry.h>
#import "LGTConst.h"
#import "LGTExtension.h"
#import <LGAlertHUD/LGAlertHUD.h>
#import "LGTalkManager.h"
#import "LGTNetworking.h"
#import "LGTWrittingImageViewer.h"

static NSInteger maxUploadCount = 3;
@interface LGTAddViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,LGTPhotoManageDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)LGTBaseTextView *textView;
@property (nonatomic,strong)NSMutableArray *imageArr;
@property (nonatomic,strong)NSArray *imageArr_copy;

@property (nonatomic,assign)BOOL isMore;

@property (nonatomic,assign)NSInteger currentIndex;

@end

@implementation LGTAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaviBar];
    [self initUI];
}
- (void)initNaviBar{
    self.marqueeTitle = @"新建讨论内容";
    [self setNavBar_rightItemTitles:@[@"发布"]];
    [LGTPhotoManage manage].ownController = self;
    [LGTPhotoManage manage].maximumNumberOfSelection = 3;
    [LGTPhotoManage manage].delegate = self;
}
- (void)initUI{
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.centerX.equalTo(self.view);
        make.height.mas_equalTo(LGT_ScreenHeight*0.3);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.textView.mas_bottom);
    }];
}
- (void)navBar_rightItemPressed:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
    self.imageArr_copy = self.imageArr.copy;
    if (LGT_IsStrEmpty(self.textView.text) && [self isEmptyImageUrls]) {
        [LGAlert showInfoWithStatus:@"发布内容不能为空!"];
    }else if (LGT_IsStrEmpty(self.textView.text) && ![self isEmptyImageUrls]) {
        if ([self.imageArr.lastObject isKindOfClass:NSString.class]) {
            [self.imageArr removeObjectAtIndex:self.imageArr.count-1];
            [self.collectionView reloadData];
        }
        [self uploadImageAction];
    }else if (!LGT_IsStrEmpty(self.textView.text) && [self isEmptyImageUrls]){
        [self uploadTalkContentWithImageUrls:@[]];
    }else{
        if ([self.imageArr.lastObject isKindOfClass:NSString.class]) {
            [self.imageArr removeObjectAtIndex:self.imageArr.count-1];
            [self.collectionView reloadData];
        }
        [self uploadImageAction];
    }
}
- (BOOL)isEmptyImageUrls{
    BOOL isEmpty = YES;
    if ([self.imageArr.lastObject isKindOfClass:NSString.class]) {
        if (self.imageArr.count > 1) {
            isEmpty = NO;
        }
    }else{
        isEmpty = NO;
    }
    return isEmpty;
}
- (void)uploadTalkContentWithImageUrls:(NSArray *) imagesUrls{
    LGTTalkUploadModel *model = [[LGTTalkUploadModel alloc] init];
    model.UserID = [LGTalkManager defaultManager].userID;
    model.UserImg = [LGTalkManager defaultManager].photoPath;
    model.UserName = [LGTalkManager defaultManager].userName;
    model.Content = self.textView.text;
    model.AssignmentID = [LGTalkManager defaultManager].assignmentID;
    model.AssignmentName = [LGTalkManager defaultManager].assignmentName;
    model.ResID = [LGTalkManager defaultManager].resID;
    model.ResName = [LGTalkManager defaultManager].resName;
    
    model.TeacherID = [LGTalkManager defaultManager].teacherID;
    model.TeacherName = [LGTalkManager defaultManager].teachertName;
    model.SubjectID = [LGTalkManager defaultManager].subjectID;
    model.SubjectName = [LGTalkManager defaultManager].subjectName;
    model.SysID = [LGTalkManager defaultManager].systemID;
    
    model.FromTopicInfo = [LGTalkManager defaultManager].resName;
    model.FromTopicIndex = -1;
   
    model.CreateTime = [NSDate date].lgt_string;
    model.ImgUrlList = imagesUrls;
    NSDictionary *params = model.lgt_JsonModel;
        NSString *urlStr = [LGTNet.apiUrl stringByAppendingFormat:@"/api/Tutor/AddTutorQuesTheme?context=%@&userID=%@",@"CONTEXT04",[LGTalkManager defaultManager].userID];
    WeakSelf;
    [LGAlert showIndeterminateWithStatus:@"发布中..."];
    [LGTNet.setRequest(urlStr).setRequestType(LGTRequestTypePOST).setParameters(params).setResponseType(LGTResponseTypeModel) startRequestWithSuccess:^(LGTResponseModel *response)  {
        if (response.Code.integerValue == 0) {
            [LGAlert showSuccessWithStatus:@"发布成功"];
            if (selfWeak.addSccessBlock) {
                selfWeak.addSccessBlock();
            }
            [selfWeak.navigationController popViewControllerAnimated:YES];
        }else{
            [LGAlert showErrorWithStatus:response.Msg];
        }
    } failure:^(NSError *error) {
        [LGAlert showErrorWithError:error];
    }];
    
}
- (void)uploadImageAction{
    LGTUploadModel *uploadModel = [[LGTUploadModel alloc] init];
    NSMutableArray *imageDatas = [NSMutableArray array];
    NSMutableArray *fileNames = [NSMutableArray array];
    for (UIImage *image in self.imageArr) {
        [fileNames addObject:[NSString stringWithFormat:@"%.f-%li.png",[[NSDate date] timeIntervalSince1970],imageDatas.count]];
        [imageDatas addObject:UIImageJPEGRepresentation([UIImage lgt_fixOrientation:image], 0.5)];
    }
    uploadModel.uploadDatas = imageDatas;;
    uploadModel.name = @"file";
    uploadModel.fileNames = fileNames;
    uploadModel.fileType = @"image/png";
    NSString *url = [LGTNet.apiUrl stringByAppendingString:@"/api/Common/UploadImg"];
    WeakSelf;
    [LGAlert showIndeterminateWithStatus:@"上传图片..."];
    [LGTNet.setRequest(url).setRequestType(LGTRequestTypeUploadPhoto).setUploadModel(uploadModel) startRequestWithProgress:^(NSProgress *progress) {
        NSLog(@"%f",progress.fractionCompleted);
    } success:^(id response) {
        [selfWeak uploadTalkContentWithImageUrls:[response objectForKey:@"Data"]];
    } failure:^(NSError *error) {
        [LGAlert showErrorWithError:error];
    }];
}
- (void)selectImagesAction{
    [LGAlert alertSheetWithTitle:@"作业图片" message:nil canceTitle:@"取消" buttonTitles:@[@"拍摄照片",@"从手机相册中选取"] buttonBlock:^(NSInteger index) {
        if (index == 0) {
            [[LGTPhotoManage manage] photoFromCamera];
        }else{
            [[LGTPhotoManage manage] photoFromAlbum];
        }
    } cancelBlock:^{
        
    } atController:self];
}

- (void)deleteCellImgAtIndex:(NSInteger)index{
    [self.imageArr removeObjectAtIndex:index];
    if (self.imageArr.count < maxUploadCount && ![self.imageArr.lastObject isKindOfClass:[NSString class]]) {
        [self.imageArr addObject:@""];
    }
    [self.collectionView reloadData];
}
#pragma mark - YJPhotoManageDelegate
- (void)LGTPhotoManage:(LGTPhotoManage *)manage cameraDidSelectImage:(UIImage *)selectImage{
    [self photoManageDidSelectImage:@[selectImage]];
}
- (void)LGTPhotoManage:(LGTPhotoManage *)manage albumDidSelectImage:(NSArray *)selectImages{
    [self photoManageDidSelectImage:selectImages];
}
- (void)photoManageDidSelectImage:(NSArray *)selectImages{
    if (LGT_IsArrEmpty(selectImages)) {
        return;
    }
    if (self.isMore) {
        for (UIImage *image in selectImages) {
            [self.imageArr insertObject:image atIndex:self.imageArr.count-1];
        }
    }else{
        if (self.imageArr.count > 1) {
            [self.imageArr replaceObjectAtIndex:self.currentIndex withObject:selectImages.lastObject];
        }else{
            for (UIImage *image in selectImages) {
                [self.imageArr insertObject:image atIndex:self.imageArr.count-1];
            }
        }
    }
    if (self.imageArr.count == maxUploadCount+1) {
        [self.imageArr removeObjectAtIndex:self.imageArr.count-1];
    }
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id image = self.imageArr[indexPath.row];
    if ([image isKindOfClass:[NSString class]]) {
        LGTMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LGTMoreCell class]) forIndexPath:indexPath];
        return cell;
    }else{
        LGTUploadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LGTUploadCell class]) forIndexPath:indexPath];
        [cell setTaskImage:image];
        __weak typeof(self) weakSelf = self;
        cell.deleteBlock = ^{
            [weakSelf deleteCellImgAtIndex:indexPath.row];
        };
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    self.currentIndex = indexPath.row;
    id image = self.imageArr[indexPath.row];
//    if ([image isKindOfClass:[NSString class]]) {
//        self.isMore = YES;
//        NSInteger count = maxUploadCount - (self.imageArr.count-1);
//        [LGTPhotoManage manage].maximumNumberOfSelection = count > 3 ? 3:count;
//    }else{
//        self.isMore = NO;
//        [LGTPhotoManage manage].maximumNumberOfSelection = 1;
//    }
//    [self selectImagesAction];
    if ([image isKindOfClass:[NSString class]]) {
        self.isMore = YES;
        NSInteger count = maxUploadCount - (self.imageArr.count-1);
        [LGTPhotoManage manage].maximumNumberOfSelection = count > 3 ? 3:count;
        [self selectImagesAction];
    }else{
        self.isMore = NO;
        NSMutableArray *imgs = self.imageArr.mutableCopy;
        if ([imgs.lastObject isKindOfClass:NSString.class]) {
            [imgs removeObjectAtIndex:imgs.count-1];
        }
        [LGTWrittingImageViewer showWithImages:imgs atIndex:indexPath.row];
    }
}
#pragma mark - Property init
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 20;
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        CGFloat itemW = (LGT_ScreenWidth-20*5)/4;
        layout.itemSize = CGSizeMake(itemW, itemW);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = LGT_ColorWithHex(0xF4F4F4);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[LGTMoreCell class] forCellWithReuseIdentifier:NSStringFromClass([LGTMoreCell class])];
        [_collectionView registerClass:[LGTUploadCell class] forCellWithReuseIdentifier:NSStringFromClass([LGTUploadCell class])];
    }
    return _collectionView;
}
- (LGTBaseTextView *)textView{
    if (!_textView) {
        _textView = [[LGTBaseTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.placeholder = @"  这一刻想说的话";
        _textView.limitType = LGTBaseTextViewLimitTypeEmojiLimit;
        _textView.maxLength = 500;
        _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _textView;
}
- (NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [NSMutableArray arrayWithObjects:@"", nil];
    }
    return _imageArr;
}
@end
