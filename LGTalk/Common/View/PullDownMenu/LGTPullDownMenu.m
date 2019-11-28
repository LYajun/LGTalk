//
//  LGTPullDownMenu.m
//  LGTPullDownMenuDemo
//
//  Created by 开发者 on 16/5/19.
//  Copyright © 2016年 jinxiansen. All rights reserved.
//

#import "LGTPullDownMenu.h"
#import <objc/runtime.h>
#import "LGTExtension.h"
#import "LGTConst.h"

#define Kscreen_width  [UIScreen mainScreen].bounds.size.width
#define Kscreen_height [UIScreen mainScreen].bounds.size.height

#define KmaskBackGroundViewColor  [UIColor colorWithRed:40/255 green:40/255 blue:40/255 alpha:.2]
#define kCellBgColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:.7]
#define KTitleButtonTag 1000
#define KOBJCSetObject(object,value)  objc_setAssociatedObject(object,@"title" , value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
#define KOBJCGetObject(object) objc_getAssociatedObject(object, @"title")


@implementation LGTPullDownButton
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
         [self configure];
    }
    return self;
}
- (void)configure{
    //设置图片的显示样式
    self.imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    //设置文字过长时的省略方式为结尾
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
}
// 在此方法，UIButton的子控件都是空，不能在此地设置图片的显示样式
//设置标题的位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleW = contentRect.size.width - contentRect.size.height;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(5, 0, titleW+10, titleH);
}
// 在此方法，UIButton的子控件都是空，不能在此地设置图片的显示样式
//设置图片的位置
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = contentRect.size.height;
    CGFloat imageH = contentRect.size.height;
    CGFloat imageX = contentRect.size.width - contentRect.size.height;
    return CGRectMake(imageX+15, 10, imageW-20, imageH-20);
    
}
// 去除按钮的高亮状态
-(void)setHighlighted:(BOOL)highlighted{}


@end



@interface LGTPullDownMenu () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *titleArray ;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic)NSMutableArray *tableDataArray;

@property (nonatomic,assign) CGFloat selfOriginalHeight ;
@property (nonatomic,assign) CGFloat tableViewMaxHeight ;

@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) NSMutableArray *lineArray;
@property (nonatomic,strong) UIView  *maskBackGroundView;
@property (nonatomic,strong) UIButton  *tempButton;
@end

@implementation LGTPullDownMenu


- (instancetype)initWithFrame:(CGRect)frame menuTitleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
        
        self.selfOriginalHeight =frame.size.height;
        self.titleArray =titleArray;
        
        [self addSubview:self.maskBackGroundView];
        [self addSubview:self.tableView];
        
        [self configBaseInfo];
    }
    return self;
}
- (void)configure{
    _rowHeight = IsIPad ? 50 : 40;
    _maxDisplayRowNumber = 5;
    _tableViewMaxHeight = _rowHeight * _maxDisplayRowNumber;
}
-(void)configBaseInfo
{
    UIView *itemBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LGT_ScreenWidth, self.frame.size.height)];
    [self addSubview:itemBgView];
    itemBgView.backgroundColor = [UIColor whiteColor];
    [itemBgView lgt_shadowWithWidth:0.8 borderColor:LGT_ColorWithHex(0xe6e6e6) opacity:0.2 radius:0.1 offset:CGSizeMake(0, 0)];
    
    [self.lineArray removeAllObjects];
    CGFloat leftSpace = 10;
    CGFloat width = (self.width-leftSpace - 64)/3;
    if (IsIPad) {
        width = 100;
    }
    CGFloat titleW = width+(self.titleArray.count-1)*5;
    CGFloat btnW = width - 5;

    for (int index=0; index<self.titleArray.count; index++) {
        
        if (index == 0) {
            UILabel  *countLab = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, 0, titleW, self.height)];
            countLab.textAlignment = NSTextAlignmentCenter;
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.titleArray[index]];
            [attr lgt_setColor:LGT_ColorWithHex(0x21a4fa)];
            [attr lgt_setFont:(LGT_ScreenWidth > 320 ? 16:14)];
            [attr lgt_setChineseForegroundColor:LGT_ColorWithHex(0x989898) font:(LGT_ScreenWidth > 320 ? 13:11)];
            countLab.attributedText = attr;
            countLab.tag =KTitleButtonTag + index;
            [itemBgView addSubview:countLab];
            [self.buttonArray addObject:countLab];
        }else{
            LGTPullDownButton *titleButton=[LGTPullDownButton buttonWithType:UIButtonTypeCustom];
            titleButton.frame= CGRectMake(btnW * (index-1)+leftSpace+titleW, 0, btnW, self.height);
            [titleButton setTitle:self.titleArray[index] forState:UIControlStateNormal];
            [titleButton setTitleColor:LGT_ColorWithHex(0x989898) forState:UIControlStateNormal];
            [titleButton setTitleColor:LGT_ColorWithHex(0x2FB7FC) forState:UIControlStateSelected];
            titleButton.tag = KTitleButtonTag + index ;
            [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            if (Kscreen_width > 320) {
                titleButton.titleLabel.font = [UIFont systemFontOfSize:13];
            }else{
                titleButton.titleLabel.font = [UIFont systemFontOfSize:11];
            }
            titleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [titleButton setImage:[UIImage lgt_imageNamed:@"lgt_filter_fold" atDir:@"Main"] forState:UIControlStateNormal];
            [titleButton setImage:[UIImage lgt_imageNamed:@"lgt_filter_expand" atDir:@"Main"] forState:UIControlStateSelected];
            
            [itemBgView addSubview:titleButton];
            [self.buttonArray addObject:titleButton];
            
            UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(btnW * (index-1)+leftSpace+titleW, 8, 0.8, self.height-16)];
            lineImage.tag = index;
            lineImage.image = [UIImage lgt_imageNamed:@"lgt_filter_line" atDir:@"Main"];
            [itemBgView addSubview:lineImage];
            [self.lineArray addObject:lineImage];
        }
        
    }
    
}

-(UITableView *)tableView
{
    if (_tableView) {
        return _tableView;
    }
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, Kscreen_width, 0) style:UITableViewStylePlain];
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.rowHeight= self.rowHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self.tableView;
}


#pragma mark  --  <代理方法>
#pragma mark  --  <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LGTdownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell =[[LGTdownMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.content = self.tableDataArray[indexPath.row];
    NSString *objcTitle = KOBJCGetObject(self.tempButton);
    cell.isShowSeparator = YES;
    if (indexPath.row == self.tableDataArray.count-1) {
        cell.isShowSeparator = NO;
    }
    cell.separatorOffset = IsIPad ? 20 : 10;
    if (self.currentIndex > 0) {
        if (indexPath.row == self.currentIndex) {
            cell.isSelected = YES;
            cell.sepColor = LGT_ColorWithHex(0x2FB7FC);
        }else{
            cell.isSelected=NO;
            cell.sepColor = LGT_ColorWithHex(0xE0E0E0);
        }
    }else{
        if ([cell.content isEqualToString:objcTitle]) {
            cell.isSelected = YES;
            cell.sepColor = LGT_ColorWithHex(0x2FB7FC);
        }else{
            cell.isSelected=NO;
            cell.sepColor = LGT_ColorWithHex(0xE0E0E0);
        }
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndex = 0;
    
    LGTdownMenuCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected = YES;
    
    [self.tempButton setTitle:cell.content forState:UIControlStateNormal];
    
    KOBJCSetObject(self.tempButton, cell.content);
    
    if (self.handleSelectDataBlock) {
        self.handleSelectDataBlock(cell.content,indexPath.row,self.tempButton.tag - KTitleButtonTag);
    }
    
    [self takeBackTableView];
    
}


- (void)setTitle:(NSString *)title{
    UILabel *countLab = self.buttonArray.firstObject;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
    [attr lgt_setColor:LGT_ColorWithHex(0x21a4fa)];
    [attr lgt_setFont:(LGT_ScreenWidth > 320 ? 16:14)];
    [attr lgt_setChineseForegroundColor:LGT_ColorWithHex(0xb0b0b0) font:(LGT_ScreenWidth > 320 ? 13:11)];
    countLab.attributedText = attr;
}
- (void)setCurrentSelTitle:(NSString *)currentSelTitle{
    _currentSelTitle = currentSelTitle;
    UIButton *btn = [self.buttonArray lastObject];
    [btn setTitle:currentSelTitle forState:UIControlStateNormal];
    
    if (!self.tempButton) {
        self.tempButton = btn;
    }
    [self.tempButton setTitle:currentSelTitle forState:UIControlStateNormal];
    KOBJCSetObject(self.tempButton, currentSelTitle);
    
    [self.tableView reloadData];
}
-(void)setDefauldSelectedCell{
    
    for (int index=0; index<self.buttonArray.count; index++) {
        
        self.tableDataArray = self.menuDataArray[index];
    }
    
    [self takeBackTableView];
    
}
- (void)setSelectable:(BOOL)selectable{
    _selectable = selectable;
    for (UIButton *button in self.buttonArray) {
        if ([button isKindOfClass:[UIButton class]]) {
            button.enabled = selectable;
        }
    }
}
-(void)titleButtonClick:(UIButton *)titleButton{
    NSUInteger index =  titleButton.tag - KTitleButtonTag;
    
    for (UIButton *button in self.buttonArray) {
        if ([button isKindOfClass:[UIButton class]]) {
            if (button == titleButton) {
                button.selected=!button.selected;
                self.tempButton =button;
            }else{
                button.selected=NO;
            }
        }
    }
    
    for (UIView *line in self.lineArray) {
        if (index == 1) {
            line.hidden = YES;
        }else{
            if (line.tag == index) {
                line.hidden = YES;
            }else{
                line.hidden = NO;
            }
        }
    }
    
    if (titleButton.selected) {
        
        self.tableDataArray = self.menuDataArray[index];
        
        //设置默认选中第一项。
        if ([KOBJCGetObject(self.tempButton) length]<1) {
            
            NSString *title = self.tableDataArray.firstObject;
            KOBJCSetObject(self.tempButton, title);
            
        }

        [self.tableView reloadData];
       
        CGFloat tableViewHeight =  self.tableDataArray.count * self.rowHeight < self.tableViewMaxHeight ?
        self.tableDataArray.count * self.rowHeight : self.tableViewMaxHeight;
        
        
        [self expandWithTableViewHeight:tableViewHeight];
        
    }else
    {
        [self takeBackTableView];
    }
}



//展开。
-(void)expandWithTableViewHeight:(CGFloat )tableViewHeight
{
    self.maskBackGroundView.hidden=NO;
    
    CGRect rect = self.frame;
    rect.size.height = Kscreen_height - self.frame.origin.y;
    self.frame= rect;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LGTPullDownMenuDidShow)]) {
        [self.delegate LGTPullDownMenuDidShow];
    }
    
    [self showSpringAnimationWithDuration:0.3 animations:^{
        
        self.tableView.frame = CGRectMake(0, self.selfOriginalHeight, Kscreen_width, tableViewHeight);
        self.maskBackGroundView.alpha =1;
        
    } completion:^{
        [UIView animateWithDuration:0.1 animations:^{
            self.tableView.contentOffset = CGPointZero;
        }];
    }];
    
}

//收起。
-(void)takeBackTableView{
    for (UIView *line in self.lineArray) {
        line.hidden = NO;
    }
    for (UIButton *button in self.buttonArray) {
        if ([button isKindOfClass:[UIButton class]]) {
            button.selected=NO;
        }
    }
    
    CGRect rect = self.frame;
    rect.size.height = self.selfOriginalHeight;
    self.frame = rect;
    if (self.delegate && [self.delegate respondsToSelector:@selector(LGTPullDownMenuDidHide)]) {
        [self.delegate LGTPullDownMenuDidHide];
    }
    
    [self showSpringAnimationWithDuration:.3 animations:^{
        
        self.tableView.frame = CGRectMake(0, self.selfOriginalHeight, Kscreen_width,0);
        self.maskBackGroundView.alpha =0;
        
    } completion:^{
        self.maskBackGroundView.hidden=YES;
    }];
}
-(void)showSpringAnimationWithDuration:(CGFloat)duration
                            animations:(void (^)(void))animations
                            completion:(void (^)(void))completion{
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        if (animations) {
            animations();
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}
-(void)maskBackGroundViewTapClick
{
    [self takeBackTableView];
}
-(NSMutableArray *)tableDataArray
{
    if (_tableDataArray) {
        return _tableDataArray;
    }
    self.tableDataArray = [[NSMutableArray alloc]init];
    
    return self.tableDataArray;
}
-(NSMutableArray *)buttonArray
{
    if (_buttonArray) {
        return _buttonArray;
    }
    self.buttonArray =[[NSMutableArray alloc]init];
    
    return self.buttonArray;
}
- (NSMutableArray *)lineArray{
    if (!_lineArray) {
        _lineArray = [NSMutableArray array];
    }
    return _lineArray;
}
-(UIView *)maskBackGroundView
{
    if (_maskBackGroundView) {
        return _maskBackGroundView;
    }
    self.maskBackGroundView=[[UIView alloc]initWithFrame:CGRectMake(0,self.frame.size.height,self.frame.size.width, Kscreen_height - self.frame.origin.y)];
    self.maskBackGroundView.backgroundColor=[UIColor colorWithWhite:0.2 alpha:0.6];
    self.maskBackGroundView.hidden=YES;
    self.maskBackGroundView.userInteractionEnabled=YES;
    NSLog(@"%@",NSStringFromCGRect(self.frame));
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskBackGroundViewTapClick)];
    [self.maskBackGroundView addGestureRecognizer:tap];
    
    return self.maskBackGroundView;
}

@end




@interface LGTdownMenuCell ()
@property (strong,nonatomic) UILabel *contentL;
@end
@implementation LGTdownMenuCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configCellView];
    }
    
    return self;
}

-(void)configCellView
{
    self.textLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.selectImageView];
    [self addSubview:self.contentL];
}

-(UIImageView *)selectImageView
{
    if (_selectImageView) {
        return _selectImageView;
    }
    
    UIImage *image = [UIImage lgt_imageNamed:@"lgt_filter_select" atDir:@"Main"];
    self.selectImageView = [[UIImageView alloc]init];
    self.selectImageView.image=image;
    
    self.selectImageView.frame = CGRectMake(0,0,24,16);
    self.selectImageView.center = CGPointMake(Kscreen_width-30, self.frame.size.height/2);
    
    return self.selectImageView;
}
- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel alloc] initWithFrame:CGRectMake(IsIPad ? 25 : 10, 3, Kscreen_width-80, self.frame.size.height-6)];
        _contentL.font = [UIFont systemFontOfSize:IsIPad ? 16 : 14];
        _contentL.textColor = [UIColor darkGrayColor];
    }
    return _contentL;
}
- (void)setContent:(NSString *)content{
    _content = content;
    self.contentL.text = content;
}
- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        self.contentL.textColor = LGT_ColorWithHex(0x2FB7FC);
    }else{
        self.contentL.textColor = [UIColor darkGrayColor];
    }
    self.selectImageView.hidden = !isSelected;
}

@end











