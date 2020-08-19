//
//  LGTAssetsCollectionCheckmarkView.m
//  LGTImagePickerController
//
//  Created by Tanaka Katsuma on 2014/01/01.
//  Copyright (c) 2014年 Katsuma Tanaka. All rights reserved.
//

#import "LGTAssetsCollectionCheckmarkView.h"

@interface LGTAssetsCollectionCheckmarkView ()
@property (nonatomic,strong) UILabel *titleLab;
@end
@implementation LGTAssetsCollectionCheckmarkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // View settings
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLab];
        self.titleLab.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    
    return self;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:15];
    }
    return _titleLab;
}
- (void)setIndex:(NSInteger)index{
    _index = index;
    self.titleLab.text = [NSString stringWithFormat:@"%@",@(index)];
}
- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(24.0, 24.0);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Border
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillEllipseInRect(context, self.bounds);
    
    // Body
    CGContextSetRGBFillColor(context, 20.0/255.0, 111.0/255.0, 223.0/255.0, 1.0);
    CGContextFillEllipseInRect(context, CGRectInset(self.bounds, 1.0, 1.0));
    
    // Checkmark
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
//    CGContextSetLineWidth(context, 1.2);
    
//    CGContextMoveToPoint(context, 6.0, 12.0);
//    CGContextAddLineToPoint(context, 10.0, 16.0);
//    CGContextAddLineToPoint(context, 18.0, 8.0);
    
    CGContextStrokePath(context);
}

@end
