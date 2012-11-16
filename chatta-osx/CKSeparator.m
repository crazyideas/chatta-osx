//
//  CKInputSeparator.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKSeparator.h"
#import "NSColor+CKAdditions.h"

@implementation CKSeparator

- (id)init
{
    self = [super init];
    if (self) {
        self.hasNotch = NO;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    if (self.backgroundColor != nil) {
        [self.backgroundColor setFill];
        NSRectFill(dirtyRect);
    }

    NSBezierPath *bezierPath = [NSBezierPath bezierPath];
    
    CGFloat arrow_width  = 10.0;
    CGFloat arrow_height = 10.0;
    
    CGFloat w_startpoint = 0.5;
    CGFloat w_midpoint   = dirtyRect.size.width / 2.0;
    CGFloat w_maxpoint   = dirtyRect.size.width;

    CGFloat h_highpoint  = dirtyRect.size.height - 0.5;
    CGFloat h_lowpoint   = h_highpoint - arrow_height;

    [bezierPath moveToPoint:NSMakePoint(w_startpoint,                 h_highpoint)];
    if (self.hasNotch) {
        [bezierPath lineToPoint:NSMakePoint(w_midpoint,                   h_highpoint)];
        [bezierPath lineToPoint:NSMakePoint(w_midpoint + arrow_width,     h_lowpoint) ];
        [bezierPath lineToPoint:NSMakePoint(w_midpoint + 2 * arrow_width, h_highpoint)];
    }
    [bezierPath lineToPoint:NSMakePoint(w_maxpoint,                   h_highpoint)];
    [[NSColor gridSeparatorColor] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];

}

@end
