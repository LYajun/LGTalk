//
//  LGTChatBox.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/11/1.
//  Copyright © 2017年 lange. All rights reserved.
//

#import "LGTChatBox.h"
#import "LGTBaseTextView.h"
#import "LGTExtension.h"
#import "LGTUploadCell.h"
#import "LGTWrittingImageViewer.h"
#import "LGTPhotoManage.h"
#import <LGAlertHUD/LGAlertHUD.h>
#define HEIGHT_TEXTVIEW      30
#define SPAES_TEXTVIEW       5

#define LGTMaxUploadCount  3
@interface LGTChatBox ()<LGTBaseTextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,LGTPhotoManageDelegate,UIGestureRecognizerDelegate>
{
    CGFloat keyboardY;
}
@property(nonatomic,strong)  LGTBaseTextView *textView;
@property(nonatomic,strong) UIButton *sendButton;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *imageArr;
@property (nonatomic,assign) BOOL isTouchSelectImg;
@property (nonatomic,assign) CGFloat keyboardHeight;
@end
@implementation LGTChatBox
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = LGT_ColorWithHex(0xF4F4F4);
        [self lgt_makeInsetShadowWithRadius:1 Color:LGT_ColorWithHex(0xF0F8FF) Directions:@[@"top"]];
        [self layoutUI];
        [self addNotification];
    }
    return self;
}
- (void)layoutUI{

    [self addSubview:self.textView];
    [self addSubview:self.collectionView];
    [self addSubview:self.sendButton];
    [self.textView deleteAccessoryView];
    [self.textView becomeFirstResponder];
}

- (void)changeFrame:(CGFloat)height{
    CGFloat maxH = 0;
    if (self.maxVisibleLine) {
        maxH = ceil(self.textView.font.lineHeight * (self.maxVisibleLine - 1) + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom);
    }
    self.textView.scrollEnabled = height >maxH && maxH >0;
    if (self.textView.scrollEnabled) {
        height = 5+maxH;
    }
    CGFloat totalH = height + SPAES_TEXTVIEW *2 + self.collectionView.height;
    self.y = keyboardY - totalH - self.contentOffsetHeight;
    self.height = totalH;
    self.textView.y = SPAES_TEXTVIEW;
    self.textView.height = height;
    self.sendButton.y = SPAES_TEXTVIEW + self.textView.height - self.sendButton.height;
    self.collectionView.y = self.textView.height + SPAES_TEXTVIEW;
    if (self.delegate && [self.delegate respondsToSelector:@selector(LGTChatBox:didChangeOffsetY:)]) {
        [self.delegate LGTChatBox:self didChangeOffsetY:self.y];
    }
    [self.textView scrollRangeToVisible:NSMakeRange(0, self.textView.text.length)];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)setOwnController:(UIViewController *)ownController{
    _ownController = ownController;
    [LGTPhotoManage manage].ownController = ownController;
    [LGTPhotoManage manage].maximumNumberOfSelection = 3;
    [LGTPhotoManage manage].delegate = self;
}
- (void)setPlacehold:(NSString *)placehold{
    _placehold = placehold;
    if (![self.textView isFirstResponder]) {
        [self.textView becomeFirstResponder];
    }
    self.textView.placeholder = placehold;
}
- (void)setCurrentMsg:(NSString *)currentMsg{
    _currentMsg = currentMsg;
    self.textView.text = currentMsg;
    [self setSendBtnEnableState];
}
- (void)setCurrentImgs:(NSArray *)currentImgs{
    _currentImgs = currentImgs;
    if (!LGT_IsArrEmpty(currentImgs)) {
        self.imageArr = currentImgs.mutableCopy;
        [self.collectionView reloadData];
        [self setSendBtnEnableState];
    }
}
- (void)sendAction{
    if (self.sendButton.selected) {
        [self ClickSendAction];
    }
}
- (void)ClickSendAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LGTChatBox:didClickSend:selectImgs:)]) {
        NSString *html = self.textView.text;
        NSMutableArray *imgs = self.imageArr.mutableCopy;
        if ([imgs.lastObject isKindOfClass:NSString.class]) {
            [imgs removeObjectAtIndex:imgs.count-1];
        }
        [self.delegate LGTChatBox:self didClickSend:html selectImgs:imgs];
    }
    
}
#pragma mark UITextViewDelegate
- (void)lgt_textViewDidBeginEditing:(LGTBaseTextView *)textView{
    [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
}
-(void)lgt_textViewDidChange:(LGTBaseTextView *)textView{
   
    [self setSendBtnEnableState];
    [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
}
- (void)lgt_textViewDidEndEditing:(LGTBaseTextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LGTChatBox:didEndEditWithContent:)]) {
        NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.delegate LGTChatBox:self didEndEditWithContent:text];
    }
}
- (void)setSendBtnEnableState{
    NSString *text = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!LGT_IsStrEmpty(text) || [self.imageArr.firstObject isKindOfClass:UIImage.class]) {
        self.sendButton.selected = YES;
        self.sendButton.backgroundColor = LGT_ColorWithHex(0x47A9EA);
    }else{
        self.sendButton.selected = NO;
        self.sendButton.backgroundColor = LGT_ColorWithHex(0xdcdcdc);
    }
}
#pragma mark - 长按手势方法
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

- (void)tapGesMethod:(UITapGestureRecognizer *)tapGes {
     NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[tapGes locationInView:self.collectionView]];
    if (indexPath) {
        self.isTouchSelectImg = YES;
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
    }
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(LGTChatBox:didSelectImgs:)]) {
        [self.delegate LGTChatBox:self didSelectImgs:self.imageArr];
    }
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
        cell.isPanUnEndEdit = YES;
        cell.isHideRemoveDeleteView = YES;
        [cell setTaskImage:image];
        __weak typeof(self) weakSelf = self;
        cell.deleteImgBlock = ^(UIImage *image) {
            [weakSelf deleteCellImgAtImage:image];
        };
        cell.panStartBlock = ^{
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.transform = CGAffineTransformMakeTranslation(0, -70);
            }];
        };
        cell.panEndBlock = ^{
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.transform = CGAffineTransformIdentity;
            }];
        };
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
    id image = self.imageArr[indexPath.row];
    if ([image isKindOfClass:[NSString class]]) {
        NSInteger count = LGTMaxUploadCount - (self.imageArr.count-1);
        [LGTPhotoManage manage].maximumNumberOfSelection = count > 3 ? 3:count;
        [self selectImagesAction];
    }else{
        NSMutableArray *imgs = self.imageArr.mutableCopy;
        if ([imgs.lastObject isKindOfClass:NSString.class]) {
            [imgs removeObjectAtIndex:imgs.count-1];
        }
        [LGTWrittingImageViewer showWithImages:imgs atIndex:indexPath.row];
    }
}
- (void)deleteCellImgAtImage:(UIImage *)image{
    [self.imageArr removeObject:image];
    if (self.imageArr.count < LGTMaxUploadCount && ![self.imageArr.lastObject isKindOfClass:[NSString class]]) {
        [self.imageArr addObject:@""];
    }
    [self.collectionView reloadData];
    
    [self setSendBtnEnableState];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LGTChatBox:didSelectImgs:)]) {
        [self.delegate LGTChatBox:self didSelectImgs:self.imageArr];
    }
}
- (void)selectImagesAction{
    [LGAlert alertSheetWithTitle:nil message:nil canceTitle:@"取消" buttonTitles:@[@"拍摄照片",@"从本地相册中选取"] buttonBlock:^(NSInteger index) {
        if (index == 0) {
            [[LGTPhotoManage manage] photoFromCamera];
        }else{
            [[LGTPhotoManage manage] photoFromAlbum];
        }
    } cancelBlock:^{
        
    } atController:self.ownController];
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
    for (UIImage *image in selectImages) {
        [self.imageArr insertObject:image atIndex:self.imageArr.count-1];
    }
    if (self.imageArr.count == LGTMaxUploadCount+1) {
        [self.imageArr removeObjectAtIndex:self.imageArr.count-1];
    }
    [self.collectionView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(LGTChatBox:didSelectImgs:)]) {
        [self.delegate LGTChatBox:self didSelectImgs:self.imageArr];
    }
    [self setSendBtnEnableState];
}
#pragma mark NSNotification
-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardY = keyboardF.origin.y;
    self.keyboardHeight = keyboardF.size.height;
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        self.y = keyboardF.origin.y - self.height - self.contentOffsetHeight;
    }];
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(LGTChatBox:didChangeOffsetY:)]) {
        [self.delegate LGTChatBox:self didChangeOffsetY:self.y];
    }
}
- (CGFloat)contentOffsetHeight{
    return LGT_ScreenHeight - self.superview.height;
}
-(void)keyboardDidChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
     self.keyboardHeight = keyboardF.size.height;
    self.y = keyboardF.origin.y - self.height - self.contentOffsetHeight;
}
-(void)keyboardWillHide:(NSNotification *)notification{
    if (self.isTouchSelectImg) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(LGTChatBoxKeyboardWillHide)]) {
            [self.delegate LGTChatBoxKeyboardWillHide];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(LGTChatBoxDidRemoved)]) {
            [self.delegate LGTChatBoxDidRemoved];
        }
    }
     self.isTouchSelectImg = NO;
}

#pragma Property init
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGFloat w = LGT_ScreenWidth - 20;
        CGFloat y = HEIGHT_TEXTVIEW + SPAES_TEXTVIEW;
        CGFloat h = HEIGHT_TABBAR - y;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        CGFloat itemW = h-20;
        layout.itemSize = CGSizeMake(itemW, itemW);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, w, h) collectionViewLayout:layout];
        _collectionView.backgroundColor = LGT_ColorWithHex(0xF4F4F4);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[LGTMoreCell class] forCellWithReuseIdentifier:NSStringFromClass([LGTMoreCell class])];
        [_collectionView registerClass:[LGTUploadCell class] forCellWithReuseIdentifier:NSStringFromClass([LGTUploadCell class])];
        UILongPressGestureRecognizer *longPresssGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
        longPresssGes.minimumPressDuration = 0.3;
        longPresssGes.delegate = self;
        [_collectionView addGestureRecognizer:longPresssGes];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesMethod:)];
        [_collectionView addGestureRecognizer:tapGes];

    }
    return _collectionView;
}

- (NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [NSMutableArray arrayWithObjects:@"", nil];
    }
    return _imageArr;
}
- (LGTBaseTextView *)textView{
    if (!_textView) {
        CGFloat w = LGT_ScreenWidth - 20 - 4 - 50;
        CGFloat h = HEIGHT_TEXTVIEW;
        CGFloat x = 10;
        CGFloat y = SPAES_TEXTVIEW;
        _textView = [[LGTBaseTextView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _textView.font = [UIFont systemFontOfSize:16];
//        _textView.returnKeyType = UIReturnKeySend;
        _textView.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
        _textView.placeholder = @"回复:";
        _textView.maxLength = 300;
        _textView.limitType = LGTBaseTextViewLimitTypeEmojiLimit;
        [_textView lgt_clipLayerWithRadius:4 width:0.5 color:LGT_ColorWithHex(0xEDEDED)];
        _textView.lgtDelegate = self;
    }
    return _textView;
}
- (UIButton *)sendButton{
    if (!_sendButton) {
        CGFloat w = 50;
        CGFloat h = HEIGHT_TEXTVIEW;
        CGFloat x = CGRectGetMaxX(self.textView.frame) + 4;
        CGFloat y = SPAES_TEXTVIEW;
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.backgroundColor = LGT_ColorWithHex(0xdcdcdc);
        [_sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        [_sendButton lgt_clipLayerWithRadius:3 width:0 color:nil];
    }
    return _sendButton;
}
@end
