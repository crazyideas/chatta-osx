//
//  CKViewAnimationUtility.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKViewAnimationUtility : NSObject

+ (void)startOpacityAnimationOnLayer:(NSView *)layer;
+ (void)stopOpacityAnimationOnLayer:(NSView *)layer;

+ (void)startPulseAnimationOnLayer:(NSView *)layer;
+ (void)stopPulseAnimationOnLayer:(NSView *)layer;

@end
