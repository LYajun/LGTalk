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
#import <LGAlertHUD/YJAnswerAlertView.h>
#import "LGTalkManager.h"
#import "LGTNetworking.h"
#import "LGTWrittingImageViewer.h"

static NSInteger maxUploadCount = 3;
@interface LGTAddViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,LGTPhotoManageDelegate,LGTBaseTextViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)LGTBaseTextView *textView;
@property (nonatomic,strong)NSMutableArray *imageArr;

@property (nonatomic,assign)BOOL isMore;
@property (nonatomic,assign) BOOL isUpdate;
@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,strong) UILabel *sourceLab;
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
    
    [self.view addSubview:self.sourceLab];
    [self.sourceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom);
        make.centerX.equalTo(self.view);
        make.right.equalTo(self.view).offset(-20);
        if ([[LGTalkManager defaultManager].systemID isEqualToString:@"930"]) {
             make.height.mas_equalTo(35);
        }else{
            make.height.mas_equalTo(0);
        }
    }];
    self.sourceLab.hidden = ![[LGTalkManager defaultManager].systemID isEqualToString:@"930"];
    if ([[LGTalkManager defaultManager].systemID isEqualToString:@"930"]) {
        NSMutableAttributedString *topicTitleAttr = [[NSMutableAttributedString alloc] initWithString:@"来自"];
        [topicTitleAttr lgt_setColor:LGT_ColorWithHex(0x636363)];
        [topicTitleAttr lgt_setFont:16];
        NSMutableAttributedString *topicSourceAttr = [[NSMutableAttributedString alloc] initWithString:self.talkSource];
        [topicSourceAttr lgt_setColor:LGT_ColorWithHex(0x47A9EA)];
        [topicSourceAttr lgt_setFont:16];
        [topicTitleAttr appendAttributedString:topicSourceAttr];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentRight;
        [topicTitleAttr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, topicTitleAttr.length)];
        self.sourceLab.attributedText = topicTitleAttr;
    }
    
    
    UIView *collectionBgView = [UIView new];
    collectionBgView.backgroundColor = LGT_ColorWithHex(0xF4F4F4);
    [self.view addSubview:collectionBgView];
    [collectionBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sourceLab.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [collectionBgView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([self collectionViewWidth]);
        make.top.left.bottom.equalTo(collectionBgView);
    }];
}
- (void)navBar_leftItemPressed:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
    if (self.isUpdate) {
        __weak typeof(self) weakSelf = self;
        [[YJAnswerAlertView alertWithTitle:@"提示" normalMsg:@"是否放弃此次编辑内容？" highLightMsg:@"" cancelTitle:@"放弃" destructiveTitle:@"我再想想" cancelBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } destructiveBlock:^{
        }] show] ;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)navBar_rightItemPressed:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
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
    NSString *content = self.textView.text;
    if (!LGT_IsStrEmpty(content)) {
        content = [NSString lgt_HTML:content];
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    }
    model.Content = content;
    model.AssignmentID = [LGTalkManager defaultManager].assignmentID;
    model.AssignmentName = [LGTalkManager defaultManager].assignmentName;
    model.ResID = self.resID;
    model.ResName = self.resName;
//    model.classID = [LGTalkManager defaultManager].classID;
    model.TeacherID = [LGTalkManager defaultManager].teacherID;
    model.TeacherName = [LGTalkManager defaultManager].teachertName;
    model.SubjectID = [LGTalkManager defaultManager].subjectID;
    model.SubjectName = [LGTalkManager defaultManager].subjectName;
    model.SysID = [LGTalkManager defaultManager].systemID;
    
    model.FromTopicInfo = self.talkSource;
    model.FromTopicIndex = -1;
   
    model.CreateTime = [NSDate date].lgt_string;
    model.ImgUrlList = imagesUrls;
    NSDictionary *params = model.lgt_JsonModel;
        NSString *urlStr = [LGTNet.apiUrl stringByAppendingFormat:@"/api/Tutor/AddTutorQuesTheme?context=%@&userID=%@",@"CONTEXT04",[LGTalkManager defaultManager].userID];
    WeakSelf;
    [LGAlert showIndeterminateWithStatus:@"发布中..."];
    [LGTNet.setRequest(urlStr).setRequestType(LGTRequestTypePOST).setParameters(params).setResponseType(LGTResponseTypeModel) startRequestWithSuccess:^(LGTResponseModel *response)  {
        if (response.Code.integerValue == 0) {
            selfWeak.isUpdate = NO;
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
        if (LGT_IsArrEmpty([response objectForKey:@"Data"])) {
            [LGAlert showInfoWithStatus:@"上传图片失败"];
        }else{
            [selfWeak uploadTalkContentWithImageUrls:[response objectForKey:@"Data"]];
        }
    } failure:^(NSError *error) {
        [LGAlert showErrorWithError:error];
    }];
}
- (void)selectImagesAction{
    [LGAlert alertSheetWithTitle:nil message:nil canceTitle:@"取消" buttonTitles:@[@"拍摄照片",@"从本地相册中选取"] buttonBlock:^(NSInteger index) {
        if (index == 0) {
            [[LGTPhotoManage manage] photoFromCamera];
        }else{
            [[LGTPhotoManage manage] photoFromAlbum];
        }
    } cancelBlock:^{
        
    } atController:self];
}

- (void)deleteCellImgAtImage:(UIImage *)image{
    [self.imageArr removeObject:image];
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
    self.isUpdate = YES;
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
#pragma mark - LGTBaseTextViewDelegate
- (void)lgt_textViewDidEndEditing:(LGTBaseTextView *)textView{
    NSString *text = textView.text;
    if (!LGT_IsStrEmpty(text) && LGT_IsStrEmpty(text.lgt_deleteWhitespaceAndNewlineCharacter)) {
        textView.text = @"";
    }
    if (!LGT_IsStrEmpty(textView.text.lgt_deleteWhitespaceCharacter)) {
        self.isUpdate = YES;
    }else{
        self.isUpdate = NO;
    }
}
#pragma mark - 长按手势方法
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)longPressMethod:(UILongPressGestureRecognizer *)longPressGes {
    // 判断手势落点位置是否在路径上(长按cell时,显示对应cell的位置,如path = 1 - 0,即表示长按的是第1组第0个cell). 点击除了cell的其他地方皆显示为null
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longPressGes locationInView:self.collectionView]];
    NSLog(@"%@",indexPath);
    
    // 判断手势状态
    switch (longPressGes.state) {
            
        case UIGestureRecognizerStateBegan: {
            
            // 如果点击的位置不是cell,break
            if (!indexPath || ([self.imageArr.lastObject isKindOfClass:NSString.class] && indexPath.row == self.imageArr.count-1)) {
                break;
            }
            // 在路径上则开始移动该路径上的cell
            if (@available(iOS 9.0, *)) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            if (indexPath && [self.imageArr.lastObject isKindOfClass:NSString.class] && indexPath.row == self.imageArr.count-1) {
                if (@available(iOS 9.0, *)) {
                    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
                        if ([cell isKindOfClass:LGTUploadCell.class]) {
                            [(LGTUploadCell *)cell setIsCancelPanGes:YES];
                        }
                    }
                    [self.collectionView cancelInteractiveMovement];
                }
                break;
            }
            // 移动过程当中随时更新cell位置
            if (@available(iOS 9.0, *)) {
                [self.collectionView updateInteractiveMovementTargetPosition:[longPressGes locationInView:self.collectionView]];
            }
            
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            // 移动结束后关闭cell移动
            if (@available(iOS 9.0, *)) {
                [self.collectionView endInteractiveMovement];
            }
        }
            break;
        default:
        {
            if (@available(iOS 9.0, *)) {
                [self.collectionView cancelInteractiveMovement];
            }
        }
            break;
    }
}
- (void)handleDatasourceExchangeWithSourceIndexPath:(NSIndexPath *)sourceIndexPath destinationIndexPath:(NSIndexPath *)destinationIndexPath{
    
    NSMutableArray *tempArr = [self.imageArr mutableCopy];
    NSInteger activeRange = destinationIndexPath.item - sourceIndexPath.item;
    BOOL moveForward = activeRange > 0;
    NSInteger originIndex = 0;
    NSInteger targetIndex = 0;
    
    for (NSInteger i = 1; i <= labs(activeRange); i ++) {
        
        NSInteger moveDirection = moveForward?1:-1;
        originIndex = sourceIndexPath.item + i*moveDirection;
        targetIndex = originIndex  - 1*moveDirection;
        
        [tempArr exchangeObjectAtIndex:originIndex withObjectAtIndex:targetIndex];
        
    }
    self.imageArr = [tempArr mutableCopy];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if ([self.imageArr.lastObject isKindOfClass:NSString.class] && destinationIndexPath.row == self.imageArr.count-1) {
        return;
    }
    [self handleDatasourceExchangeWithSourceIndexPath:sourceIndexPath destinationIndexPath:destinationIndexPath];
}
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
        cell.isForbidLongGes = YES;
        [cell setTaskImage:image];
        __weak typeof(self) weakSelf = self;
        cell.deleteImgBlock = ^(UIImage *image) {
            [weakSelf deleteCellImgAtImage:image];
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
- (CGFloat)collectionViewWidth{
    if (LGT_IsIPad()) {
        return 120*3 + 10*3 + 20*2;
    }else{
        return ((LGT_ScreenWidth-20*2 - 10*3)/4)*3 + 10*3 + 20*2;
    }
}
#pragma mark - Property init
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        CGFloat itemW = (LGT_ScreenWidth-20*2 - 10*3)/4;
        if (LGT_IsIPad()) {
            itemW = 120;
        }
        layout.itemSize = CGSizeMake(itemW, itemW);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = LGT_ColorWithHex(0xF4F4F4);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[LGTMoreCell class] forCellWithReuseIdentifier:NSStringFromClass([LGTMoreCell class])];
        [_collectionView registerClass:[LGTUploadCell class] forCellWithReuseIdentifier:NSStringFromClass([LGTUploadCell class])];
        UILongPressGestureRecognizer *longPresssGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
        longPresssGes.minimumPressDuration = 0.3;
        longPresssGes.delegate  = self;
        [_collectionView addGestureRecognizer:longPresssGes];
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
        _textView.lgtDelegate = self;
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
- (UILabel *)sourceLab{
    if (!_sourceLab) {
        _sourceLab = [UILabel new];
    }
    return _sourceLab;
}
@end
