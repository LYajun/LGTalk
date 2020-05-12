//
//  LGTMainTableFooterView.m
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/7.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTMainTableFooterView.h"
#import <Masonry/Masonry.h>
#import "LGTConst.h"

@implementation LGTMainTableFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *bgView = [UIView new];
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
            make.height.mas_greaterThanOrEqualTo(5);
        }];
        UIView *line = [UIView new];
        line.backgroundColor = LGT_ColorWithHex(0xEAEAEA);
        [bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.left.bottom.equalTo(bgView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

@end
