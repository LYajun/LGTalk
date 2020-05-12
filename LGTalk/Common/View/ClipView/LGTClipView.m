//
//  LGTClipView.m
//
//
//  Created by 刘亚军 on 2018/12/29.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGTClipView.h"
#import "LGTConst.h"

@implementation LGTClipView

- (void)drawRect:(CGRect)rect {
    UIRectCorner corners = UIRectCornerAllCorners;
    if (!LGT_IsArrEmpty(self.clipDirections)) {
        for (NSString *direction in self.clipDirections) {
            if ([direction isEqualToString:@"TopLeft"]) {
                corners = UIRectCornerTopLeft;
            }else if ([direction isEqualToString:@"BottomLeft"]){
                if (corners == UIRectCornerAllCorners) {
                    corners = UIRectCornerBottomLeft;
                }else{
                    corners = corners|UIRectCornerBottomLeft;
                }
            } else if ([direction isEqualToString:@"BottomRight"]){
                if (corners == UIRectCornerAllCorners) {
                    corners = UIRectCornerBottomRight;
                }else{
                    corners = corners|UIRectCornerBottomRight;
                }
            } else if ([direction isEqualToString:@"TopRight"]){
                if (corners == UIRectCornerAllCorners) {
                    corners = UIRectCornerTopRight;
                }else{
                    corners = corners|UIRectCornerTopRight;
                }
            }
        }
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(self.clipRadiu, self.clipRadiu)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)setClipRadiu:(CGFloat)clipRadiu{
    _clipRadiu = clipRadiu;
    [self setNeedsDisplay];
}
- (void)setClipDirections:(NSArray<NSString *> *)clipDirections{
    _clipDirections = clipDirections;
    [self setNeedsDisplay];
}

@end
