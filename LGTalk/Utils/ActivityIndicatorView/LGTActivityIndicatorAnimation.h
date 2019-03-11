//
//  LGTActivityIndicatorAnimation.h
//
//
//  Created by Danil Gontovnik on 8/10/16.
//  Copyright © 2016 Danil Gontovnik. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LGTActivityIndicatorAnimationProtocol.h"

@interface LGTActivityIndicatorAnimation : NSObject <LGTActivityIndicatorAnimationProtocol>

- (CABasicAnimation *)createBasicAnimationWithKeyPath:(NSString *)keyPath;
- (CAKeyframeAnimation *)createKeyframeAnimationWithKeyPath:(NSString *)keyPath;
- (CAAnimationGroup *)createAnimationGroup;

@end
