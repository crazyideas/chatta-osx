//
//  CKViewAnimationUtility.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKViewAnimationUtility.h"
#import <QuartzCore/QuartzCore.h>

@implementation CKViewAnimationUtility

+ (void)startOpacityAnimationOnLayer:(CALayer *)layer
{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animation];
    opacityAnimation.keyPath      = @"opacity";
    opacityAnimation.duration     = 0.75;
    opacityAnimation.repeatCount  = HUGE_VALF;
    opacityAnimation.autoreverses = YES;
    opacityAnimation.fromValue    = @(1.0);
    opacityAnimation.toValue      = @(0.0);
    opacityAnimation.removedOnCompletion     = NO;

    
    [layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
}

+ (void)stopOpacityAnimationOnLayer:(CALayer *)layer
{
    [layer removeAnimationForKey:@"animateOpacity"];
}

+ (void)startPulseAnimationOnLayer:(CALayer *)layer
{
    CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:2.0] forKey:@"inputRadius"];
    [filter setName:@"pulseFilter"];
    [layer setFilters:[NSArray arrayWithObject:filter]];
    
    CABasicAnimation *pulseAnimation = [CABasicAnimation animation];
    pulseAnimation.keyPath        = @"filters.pulseFilter.inputIntensity";
    pulseAnimation.duration       = 0.75;
    pulseAnimation.repeatCount    = HUGE_VALF;
    pulseAnimation.fromValue      = @(0.0);
    pulseAnimation.toValue        = @(2.0);
    pulseAnimation.autoreverses   = YES;
    pulseAnimation.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [layer addAnimation:pulseAnimation forKey:@"pulseAnimation"];
}

+ (void)stopPulseAnimationOnLayer:(CALayer *)layer
{
    [layer removeAnimationForKey:@"pulseAnimation"];
}

@end
