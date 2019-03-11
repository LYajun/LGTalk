//
//  LGTActivityIndicatorView.h
//
//
//  Created by Danil Gontovnik on 5/23/15.
//  Copyright (c) 2015 Danil Gontovnik. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LGTActivityIndicatorAnimationType) {
    LGTActivityIndicatorAnimationTypeNineDots,
    LGTActivityIndicatorAnimationTypeTriplePulse,
    LGTActivityIndicatorAnimationTypeFiveDots,
    LGTActivityIndicatorAnimationTypeRotatingSquares,
    LGTActivityIndicatorAnimationTypeDoubleBounce,
    LGTActivityIndicatorAnimationTypeTwoDots,
    LGTActivityIndicatorAnimationTypeThreeDots,
    LGTActivityIndicatorAnimationTypeBallPulse,
    LGTActivityIndicatorAnimationTypeBallClipRotate,
    LGTActivityIndicatorAnimationTypeBallClipRotatePulse,
    LGTActivityIndicatorAnimationTypeBallClipRotateMultiple,
    LGTActivityIndicatorAnimationTypeBallRotate,
    LGTActivityIndicatorAnimationTypeBallZigZag,
    LGTActivityIndicatorAnimationTypeBallZigZagDeflect,
    LGTActivityIndicatorAnimationTypeBallTrianglePath,
    LGTActivityIndicatorAnimationTypeBallScale,
    LGTActivityIndicatorAnimationTypeLineScale,
    LGTActivityIndicatorAnimationTypeLineScaleParty,
    LGTActivityIndicatorAnimationTypeBallScaleMultiple,
    LGTActivityIndicatorAnimationTypeBallPulseSync,
    LGTActivityIndicatorAnimationTypeBallBeat,
    LGTActivityIndicatorAnimationTypeLineScalePulseOut,
    LGTActivityIndicatorAnimationTypeLineScalePulseOutRapid,
    LGTActivityIndicatorAnimationTypeBallScaleRipple,
    LGTActivityIndicatorAnimationTypeBallScaleRippleMultiple,
    LGTActivityIndicatorAnimationTypeTriangleSkewSpin,
    LGTActivityIndicatorAnimationTypeBalLGTridBeat,
    LGTActivityIndicatorAnimationTypeBalLGTridPulse,
    LGTActivityIndicatorAnimationTypeRotatingSandglass,
    LGTActivityIndicatorAnimationTypeRotatingTrigons,
    LGTActivityIndicatorAnimationTypeTripleRings,
    LGTActivityIndicatorAnimationTypeCookieTerminator,
    LGTActivityIndicatorAnimationTypeBallSpinFadeLoader
};

@interface LGTActivityIndicatorView : UIView

- (id)initWithType:(LGTActivityIndicatorAnimationType)type;
- (id)initWithType:(LGTActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor;
- (id)initWithType:(LGTActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor size:(CGFloat)size;

@property (nonatomic) LGTActivityIndicatorAnimationType type;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic) CGFloat size;

@property (nonatomic, readonly) BOOL animating;

- (void)startAnimating;
- (void)stopAnimating;

@end
