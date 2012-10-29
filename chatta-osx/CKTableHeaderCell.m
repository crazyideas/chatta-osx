//
//  CKTableHeaderCell.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKTableHeaderCell.h"
#import "NSColor+CKAdditions.h"

@implementation CKTableHeaderCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    static CGFloat startColorRGB = 252.0/255.0;
    static CGFloat endColorRGB   = 232.0/255.0;
    static CGFloat fontColorRGB  = 90.0 /255.0;
    
    CGRect fillRect, borderRect;
    CGRectDivide(cellFrame, &borderRect, &fillRect, 1.0, CGRectMaxYEdge);
    
    // background gradient
    NSColor *startingColor = [NSColor colorWithCalibratedRed:startColorRGB
        green:startColorRGB blue:startColorRGB alpha:1.0];
    NSColor *endingColor = [NSColor colorWithCalibratedRed:endColorRGB
        green:endColorRGB blue:endColorRGB alpha:1.0];
    
    NSGradient *gradient =
        [[NSGradient alloc] initWithStartingColor:startingColor endingColor:endingColor];
    [gradient drawInRect:fillRect angle:90.0];
    [[NSColor gridSeparatorColor] set];
    NSRectFill(borderRect);
    
    // font attributes
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor colorWithDeviceWhite:1.0 alpha:0.5]];
    [shadow setShadowOffset:NSMakeSize(0.0, -1.0)];
    [shadow setShadowBlurRadius:0.0];
    NSColor *fontColor = [NSColor colorWithCalibratedRed:fontColorRGB
        green:fontColorRGB blue:fontColorRGB alpha:1.0];
    NSFont *fontFace = [NSFont fontWithName:@"HelveticaNeue-Light" size:14];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSCenterTextAlignment];
    
    // attribute dictionary
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        paragraphStyle, NSParagraphStyleAttributeName,
        shadow,         NSShadowAttributeName,
        fontColor,      NSForegroundColorAttributeName,
        fontFace,       NSFontAttributeName,
        nil];

    [self.stringValue drawInRect:cellFrame withAttributes:attributes];
}

@end
