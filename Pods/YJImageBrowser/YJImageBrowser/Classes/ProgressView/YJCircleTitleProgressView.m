//
//  YJCircleTitleProgressView.m
//  Pods
//
//  Created by 刘亚军 on 2019/12/5.
//

#import "YJCircleTitleProgressView.h"

@implementation YJCircleTitleProgressView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeLabel];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeLabel];
    }
    return self;
}

- (void)setTitleProgress:(float)titleProgress{
    _titleProgress = titleProgress;
    self.progress = titleProgress;
    self.progressLabel.text = [NSString stringWithFormat:@"%.f%%",titleProgress * 100];
}
- (void)initializeLabel{
    self.progressLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.progressLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.progressLabel];
}

@end
