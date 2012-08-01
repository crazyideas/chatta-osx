//
//  CKViewAnimationUtility.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKViewAnimationUtility : NSObject

+ (void)startOpacityAnimationOnLayer:(CALayer *)layer;
+ (void)stopOpacityAnimationOnLayer:(CALayer *)layer;

+ (void)startPulseAnimationOnLayer:(CALayer *)layer;
+ (void)stopPulseAnimationOnLayer:(CALayer *)layer;

@end
