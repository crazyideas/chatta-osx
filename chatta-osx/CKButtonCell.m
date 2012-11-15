//
//  CKButtonCell.m
//  CustomButton
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKButtonCell.h"

@implementation CKButtonCell

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];

    NSRect underlineRect = CKCopyRect(frame);
    underlineRect.size.height = 5;
    underlineRect.origin.y = frame.size.height - underlineRect.size.height - 0; // -5?
    
    // normal
    CGContextSetRGBFillColor(context, 0.80, 0.80, 0.80, 1);
    CGContextFillRect(context, underlineRect);
    
    // detect if hovered
    if (self.isEnabled && self.isHover) {
        CGContextSetRGBFillColor(context, 0.65, 0.65, 0.65, 1);
        CGContextFillRect(context, underlineRect);
    }

    // detect if pressed
    if (self.isEnabled && self.state == NSOnState) {
        CGContextSetRGBFillColor(context, 0.80, 0.85, 0.92, 1);
        CGContextFillRect(context, underlineRect);
    }
}

@end
