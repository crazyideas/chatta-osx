//
//  CKTableRowView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKTableRowView.h"

@implementation CKTableRowView

@synthesize separatorStyle = _separatorStyle;
@synthesize primaryColor   = _primaryColor;
@synthesize secondaryColor = _secondaryColor;

- (void)setSeparatorStyle:(CKTableRowSeparatorStyle)separatorStyle
{
    _separatorStyle = separatorStyle;
}

+ (NSColor *)defaultPrimaryColor
{
    return [NSColor colorWithCalibratedRed:208/255.0 green:211/255.0 blue:212/255.0 alpha:1.0];
}

+ (NSColor *)defaultSecondaryColor
{
    return [NSColor colorWithCalibratedRed:235/255.0 green:236/255.0 blue:235/255.0 alpha:1.0];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.primaryColor   = [CKTableRowView defaultPrimaryColor];
        self.secondaryColor = [CKTableRowView defaultSecondaryColor];
    }
    
    return self;
}

- (NSRect)separatorRectWithOffset:(CGFloat)offset
{
    NSRect separatorRect = self.bounds;
    separatorRect.origin.y = NSMaxY(separatorRect) + offset;
    separatorRect.size.height = 1;
    return separatorRect;
}

- (void)drawSeparatorInRect:(NSRect)dirtyRect
{
    // strokes are draw centered on the path, so a one pixel line will be 0.5 above
    // and 0.5 below the path, offsetting by 0.5 will give a one pixel line
    CGFloat strokeOffset = 0.5;
    
    // if the none line style is selected, draw nothing
    if (self.separatorStyle == CKTableRowSeparatorStyleNone) {
        return;
    }
    
    // if the single line style is selected, draw the primary colored line
    if (self.separatorStyle == CKTableRowSeparatorStyleSingleLine) {
        // the rectange, start and end points, we will be drawing in
        NSRect  drawRect  = [self separatorRectWithOffset:(-1 + strokeOffset)];
        NSPoint lineStart = NSMakePoint(drawRect.origin.x, drawRect.origin.y);
        NSPoint lineEnd   = NSMakePoint(drawRect.origin.x + drawRect.size.width, drawRect.origin.y);
        
        // draw a dark line
        [NSBezierPath setDefaultLineWidth:0.0];
        [self.primaryColor setStroke];
        [NSBezierPath strokeLineFromPoint:lineStart toPoint:lineEnd];
        
        return;
    }
    
    // if the etched line style is selected, draw the primary and secondary colored lines
    if (self.separatorStyle == CKTableRowSeparatorStyleSingleLineEtched) {
        // the rectange, start and end points, we will be drawing in
        NSRect  drawRect  = [self separatorRectWithOffset:(-2 + strokeOffset)];
        NSPoint lineStart = NSMakePoint(drawRect.origin.x, drawRect.origin.y);
        NSPoint lineEnd   = NSMakePoint(drawRect.origin.x + drawRect.size.width, drawRect.origin.y);
        
        // draw a dark line
        [NSBezierPath setDefaultLineWidth:0.0];
        [self.primaryColor setStroke];
        [NSBezierPath strokeLineFromPoint:lineStart toPoint:lineEnd];
        
        
        // the rectange, start and end points, we will be drawing in
        drawRect  = [self separatorRectWithOffset:(-1 + strokeOffset)];
        lineStart = NSMakePoint(drawRect.origin.x, drawRect.origin.y);
        lineEnd   = NSMakePoint(drawRect.origin.x + drawRect.size.width, drawRect.origin.y);
        
        // draw a light line
        [NSBezierPath setDefaultLineWidth:0.0];
        [self.secondaryColor setStroke];
        [NSBezierPath strokeLineFromPoint:lineStart toPoint:lineEnd];
        
        return;
    }
}


- (void)drawSelectionInRect:(NSRect)dirtyRect
{
    CGFloat strokeOffset = 0.5;

    // draw selection gradient
    NSBezierPath *clipRect = [NSBezierPath bezierPathWithRect:self.bounds];
    
    NSColor *gradientStart = [NSColor colorWithCalibratedRed:44/255.0 green:113/255.0 blue:200/255.0 alpha:1.0];
    NSColor *gradientEnd   = [NSColor colorWithCalibratedRed:88/255.0 green:159/255.0 blue:222/255.0 alpha:1.0];
    
    NSGradient *gradient   = [[NSGradient alloc] initWithStartingColor:gradientStart endingColor:gradientEnd];
    
    [gradient drawInBezierPath:clipRect angle:270.0];
    
    // draw selection etching
    CGFloat primaryEtchingOffset   = self.bounds.size.height + 0;
    CGFloat secondaryEtchingOffset = self.bounds.size.height - 1;

    NSColor *primarySelectionEtchingColor =
        [NSColor colorWithCalibratedRed:76/255.0 green:146/255.0 blue:215/255.0 alpha:1.0];
    NSColor *secondarySelectionEtchingColor =
        [NSColor colorWithCalibratedRed:96/255.0 green:169/255.0 blue:228/255.0 alpha:1.0];

    // draw a primary selection etching
    NSRect  drawRect  = [self separatorRectWithOffset:(-primaryEtchingOffset + strokeOffset)];
    NSPoint lineStart = NSMakePoint(drawRect.origin.x, drawRect.origin.y);
    NSPoint lineEnd   = NSMakePoint(drawRect.origin.x + drawRect.size.width, drawRect.origin.y);
    [NSBezierPath setDefaultLineWidth:0.0];
    [primarySelectionEtchingColor setStroke];
    [NSBezierPath strokeLineFromPoint:lineStart toPoint:lineEnd];
        
    // draw a secondary selection etching
    drawRect  = [self separatorRectWithOffset:(-secondaryEtchingOffset + strokeOffset)];
    lineStart = NSMakePoint(drawRect.origin.x, drawRect.origin.y);
    lineEnd   = NSMakePoint(drawRect.origin.x + drawRect.size.width, drawRect.origin.y);
    [NSBezierPath setDefaultLineWidth:0.0];
    [secondarySelectionEtchingColor setStroke];
    [NSBezierPath strokeLineFromPoint:lineStart toPoint:lineEnd];
}

@end
