//
//  YJTaskMarLabel.m
//  LGMultimediaFramework
//
//  Created by 刘亚军 on 2019/3/4.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJTaskMarLabel.h"
@interface YJTaskMarLabel ()<UIScrollViewDelegate>{
    NSTimer *_timer;
    UIScrollView *_scrollV;
    UILabel *_label1;
    CGSize _scrollViewCcontentSize;
    CGFloat x;
    UILabel *_label2;
    BOOL _isRight;
}

@end
@implementation YJTaskMarLabel

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    self.marqueeLabelType = YJTaskMarLabelTypeLeft;
    self.secondLabelInterval = 44;
    self.speed = 0.3f;
    self.stopTime = 1.5f;
}

-(UILabel *)comnInitLabel:(UILabel *)label {
    label = [[UILabel alloc]initWithFrame:self.bounds];
    label.text = self.text;
    label.font = self.font;
    label.textColor = self.textColor;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

-(void)drawTextInRect:(CGRect)rect {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    
    x = 0;
    _label1 = [self comnInitLabel:_label1];
    if (self.marqueeLabelType == YJTaskMarLabelTypeLeft) {
        _label2 = [self comnInitLabel:_label2];
    }
    
    CGSize size = [_label1 sizeThatFits:CGSizeMake(MAXFLOAT,height)];
    
    //如果字符串的宽度小于或等于自身的宽度
    if (size.width <= width) {
        _label1 = nil;
        _label2 = nil;
        [super drawTextInRect:rect];
        return;
    }
    
    _scrollV = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollV.delegate = self;
    if (self.marqueeLabelType == YJTaskMarLabelTypeLeft) {
        _scrollViewCcontentSize = CGSizeMake(size.width+width+self.secondLabelInterval, size.height);
    }else {
        _scrollViewCcontentSize = CGSizeMake(size.width, size.height);
    }
    _scrollV.contentSize = _scrollViewCcontentSize;
    
    [self addSubview:_scrollV];
    
    CGRect rect1 =  _label1.frame;
    rect1.size.width = size.width;
    _label1.frame = rect1;
    [_scrollV addSubview:_label1];
    
    if (self.marqueeLabelType == YJTaskMarLabelTypeLeft) {
        CGRect rect2 =  _label2.frame;
        rect2.size.width = width;
        rect2.origin.x = size.width + self.secondLabelInterval;
        _label2.frame = rect2;
        [_scrollV addSubview:_label2];
    }
    
    [self Timer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    x = scrollView.contentOffset.x;
    [self Timer];
}

-(void)Timer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(refreshMarqueeLabelFrame) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)FistTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.stopTime target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
}
- (void)invalidateTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}


-(void)delayMethod {
    [self Timer];
}

- (void)refreshMarqueeLabelFrame {
    
    if (self.marqueeLabelType == YJTaskMarLabelTypeLeft) {
        
        x += self.speed;
        if (x > _scrollViewCcontentSize.width - _scrollV.bounds.size.width) {
            [self FistTimer];
            x = 0;
        }
        [_scrollV setContentOffset:CGPointMake(x, 0)];
        
    }else {
        if (_isRight) {
            x -= self.speed;
        }else {
            x += self.speed;
        }
        
        if (x > _scrollViewCcontentSize.width - _scrollV.bounds.size.width) {
            [self FistTimer];
            _isRight = YES;
            return;
        }
        
        if (x <= 0) {
            [self FistTimer];
            _isRight = NO;
        }
        
        [_scrollV setContentOffset:CGPointMake(x, 0)];
    }
}

@end
