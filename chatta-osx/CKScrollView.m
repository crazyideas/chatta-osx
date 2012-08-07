//
//  CKScrollView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKScrollView.h"

@implementation CKScrollView

- (void)scrollToBottom
{
    NSPoint newScrollOrigin;
    
    if ([[self documentView] isFlipped]) {
        newScrollOrigin = NSMakePoint(0.0, NSMaxY([[self documentView] frame]) -
                                      NSHeight([[self contentView] bounds]));
    } else {
        newScrollOrigin = NSMakePoint(0.0, 0.0);
    }
    
    [[self documentView] scrollPoint:newScrollOrigin];
}

@end
