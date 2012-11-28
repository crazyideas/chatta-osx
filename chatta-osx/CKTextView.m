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

- (BOOL)acceptsFirstResponder
{
    return NO;
}

- (NSArray *)acceptableDragTypes
{
    return nil;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    return NSDragOperationNone;
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
    return NSDragOperationNone;
}

@end
