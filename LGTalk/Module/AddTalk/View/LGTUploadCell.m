//
//  LGTUploadCell.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/8/28.
//  Copyright © 2017年 lange. All rights reserved.
//

#import "LGTUploadCell.h"
#import "LGTBarProgressView.h"
#import <Masonry/Masonry.h>
#import "LGTExtension.h"
#import "LGTImageDeleteView.h"
#import "LGTConst.h"

#pragma mark -

@interface LGTMoreCell ()
@property (nonatomic,strong)UIImageView *imageView;
@end
@implementation LGTMoreCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configure];
        [self initUI];
    }
    return self;
}
- (void)configure{
    self.backgroundColor = [UIColor whiteColor];
}
- (void)initUI{
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage lgt_imageNamed:@"add_photo" atDir:@"Main"]];
    }
    return _imageView;
}
@end

#pragma mark -

@interface LGTUploadCell ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic, strong) LGTImageDeleteView *deleteView;
@property (nonatomic, assign) CGPoint oriCenter;
@property (nonatomic, strong) UILongPressGestureRecognizer *longGes;
@property (nonatomic, strong) UIView *panView;
@end
@implementation LGTUploadCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configure];
        [self initUI];
        [self addNotification];
    }
    return self;
}
- (void)configure{

}

- (void)initUI{
    self.imageView.hidden = NO;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.bounds = self.contentView.bounds;
    self.imageView.center = self.contentView.center;
     self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.contentView addSubview:self.imageView];
    
    [self.imageView lgt_clipLayerWithRadius:0 width:1 color:LGT_ColorWithHex(0xe5e5e5)];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.imageView addGestureRecognizer:pan];
    
    self.longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGes:)];
    self.longGes.delegate = self;
    self.longGes.minimumPressDuration = 0.3;
    [self.imageView addGestureRecognizer:self.longGes];
}

- (void)dealloc{
    if (self.panView) {
        [self.panView removeFromSuperview];
    }
    if (self.deleteView) {
        [self.deleteView hide];
        if (self.isHideRemoveDeleteView) {
            self.deleteView = nil;
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight = keyboardF.size.height;
    if (self.keyboardHeight == 0) {
        self.keyboardHeight = 272;
    }
}

-(void)keyboardWillHide:(NSNotification *)notification{
    self.keyboardHeight = 0;
}
- (void)setIsForbidLongGes:(BOOL)isForbidLongGes{
    _isForbidLongGes = isForbidLongGes;
    self.longGes.enabled = !isForbidLongGes;
}
// 代理方法默认返回NO，会阻断继续向下识别手势，如果返回YES则可以继续向下传播识别
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)longGes:(UILongPressGestureRecognizer *)longGes{
    if (longGes.state == UIGestureRecognizerStateBegan) {
        self.deleteView = [LGTImageDeleteView showTalkImageDeleteViewAtBottom:YES];
    }else if (longGes.state == UIGestureRecognizerStateEnded){
        [self.deleteView hide];
        if (self.isHideRemoveDeleteView) {
            self.deleteView = nil;
        }
    }
}
- (void)pan:(UIPanGestureRecognizer *)pan{
    if (!self.isPanUnEndEdit) {
        self.keyboardHeight = 0;
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }
    
    //坐标转换
    CGRect rect = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
    CGPoint transP = [pan translationInView:self];
    UIView *tagButton = pan.view;
    self.panView = tagButton;
    // 开始
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.isCancelPanGes = NO;
        if (self.panStartBlock) {
            self.panStartBlock();
        }
        self.oriCenter = tagButton.center;
        [UIView animateWithDuration:-.25 animations:^{
            tagButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
        if (!self.deleteView || !self.deleteView.superview) {
            self.deleteView = [LGTImageDeleteView showTalkImageDeleteViewAtBottom:YES keyboardHeight:self.keyboardHeight];
        }
        
        [[UIApplication sharedApplication].keyWindow addSubview:tagButton];
        
        tagButton.top = rect.origin.y + tagButton.top;
        tagButton.left = rect.origin.x + tagButton.left;
    }
    CGPoint center = tagButton.center;
    center.x += transP.x;
    center.y += transP.y;
    tagButton.center = center;
    
    // 改变
    BOOL isDelete = NO;
    if ((tagButton.y + tagButton.height)  > (LGT_ScreenHeight - self.deleteView.height-self.keyboardHeight)) {
        isDelete = YES;
    }
    
    if (pan.state == UIGestureRecognizerStateChanged && !self.isCancelPanGes) {
        
        if (isDelete) {
            [self.deleteView setDeleteViewDeleteState];
        }else {
            [self.deleteView setDeleteViewNormalState];
        }
        
    }
    
    // 结束
    if (pan.state == UIGestureRecognizerStateEnded || self.isCancelPanGes) {
        
        if (self.panEndBlock) {
            self.panEndBlock();
        }
        
        if (isDelete) {
            [tagButton removeFromSuperview];
            if (self.deleteBlock) {
                self.deleteBlock();
            }
            if (self.deleteImgBlock) {
                self.deleteImgBlock(self.imageView.image);
            }
        }
        [self.deleteView hide];
        if (self.isHideRemoveDeleteView) {
            self.deleteView = nil;
        }
        [UIView animateWithDuration:0.25 animations:^{
            tagButton.transform = CGAffineTransformIdentity;
            tagButton.center = self.oriCenter;
            tagButton.left = tagButton.left + rect.origin.x;
            tagButton.top = tagButton.top + rect.origin.y;
        } completion:^(BOOL finished) {
            tagButton.center = self.contentView.center;
            [self.contentView addSubview:tagButton];
        }];
        
    }
    
    [pan setTranslation:CGPointZero inView:self];
}

- (void)setTaskImage:(UIImage *)taskImage{
    self.imageView.image = taskImage;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

@end
