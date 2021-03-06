//
//  LGTAssetsCollectionViewLayout.m
//  LGTImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "LGTAssetsCollectionViewLayout.h"

@implementation LGTAssetsCollectionViewLayout

+ (instancetype)layout
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.minimumLineSpacing = 2.0;
        self.minimumInteritemSpacing = 2.0;
    }
    
    return self;
}

@end
