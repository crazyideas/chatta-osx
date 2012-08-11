//
//  CKTextView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKTextView.h"

@implementation CKTextView

- (void)setEnabled:(BOOL)enabled
{
    [self setSelectable:enabled];
    [self setEditable:enabled];
    
    self.textColor = (enabled == YES) ?
        [NSColor controlTextColor] : [NSColor disabledControlTextColor];
    
    _enabled = enabled;
}

- (BOOL)shouldDrawInsertionPoint
{
    return NO;
}

- (NSRange)rangeForUserTextChange
{
    return NSMakeRange(NSNotFound, 0);
}

@end
