//
//  LGTAssetsCollectionOverlayView.m
//  LGTImagePickerController
//
//  Created by Tanaka Katsuma on 2014/01/01.
//  Copyright (c) 2014年 Katsuma Tanaka. All rights reserved.
//

#import "LGTAssetsCollectionOverlayView.h"
#import <QuartzCore/QuartzCore.h>

// Views
#import "LGTAssetsCollectionCheckmarkView.h"

@interface LGTAssetsCollectionOverlayView ()

@property (nonatomic, strong) LGTAssetsCollectionCheckmarkView *checkmarkView;

@end

@implementation LGTAssetsCollectionOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // View settings
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        
        // Create a checkmark view
        LGTAssetsCollectionCheckmarkView *checkmarkView = [[LGTAssetsCollectionCheckmarkView alloc] initWithFrame:CGRectMake(self.bounds.size.width - (4.0 + 24.0), self.bounds.size.height - (4.0 + 24.0), 24.0, 24.0)];
        checkmarkView.autoresizingMask = UIViewAutoresizingNone;
        
        checkmarkView.layer.shadowColor = [[UIColor grayColor] CGColor];
        checkmarkView.layer.shadowOffset = CGSizeMake(0, 0);
        checkmarkView.layer.shadowOpacity = 0.6;
        checkmarkView.layer.shadowRadius = 2.0;
        
        [self addSubview:checkmarkView];
        self.checkmarkView = checkmarkView;
    }
    
    return self;
}

@end
