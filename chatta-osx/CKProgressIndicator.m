//
//  CKProgressIndicator.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKProgressIndicator.h"

@implementation CKProgressIndicator

- (void)startAnimation:(id)sender
{
    _inProgress = YES;
    [super startAnimation:sender];
}

- (void)stopAnimation:(id)sender
{
    _inProgress = NO;
    [super stopAnimation:sender];
}

@end
