//
//  CKButtonCell.m
//  CustomButton
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKButtonCell.h"
#import "NSFont+CKAdditions.h"

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
    if (self.isHover) {
        CGContextSetRGBFillColor(context, 0.65, 0.65, 0.65, 1);
        CGContextFillRect(context, underlineRect);
    }

    // detect if pressed
    if (self.acceptsFirstResponder && self.state == NSOnState) {
        CGContextSetRGBFillColor(context, 0.60, 0.80, 0.95, 1);
        CGContextFillRect(context, underlineRect);
    }
}

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor whiteColor]];
    [shadow setShadowOffset:NSMakeSize(-0.0, -2.0)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSCenterTextAlignment];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       self.font,               NSFontAttributeName,
                                       [NSColor darkGrayColor], NSForegroundColorAttributeName,
                                       shadow,                  NSShadowAttributeName,
                                       paragraphStyle,          NSParagraphStyleAttributeName,
                                       nil];
    
    NSRect newFrame = CKCopyRect(frame);
    newFrame.origin.y -= 3;
    
    [self.title drawInRect:newFrame withAttributes:[attributes copy]];
    
    return frame;
}

@end
