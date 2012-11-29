//
//  CKTableRowView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKTableRowView.h"
#import "CKTableCellView.h"
#import "NSColor+CKAdditions.h"
#import "NSFont+CKAdditions.h"

@implementation CKTableRowView

- (NSAttributedString *)etchedStringWithFont:(NSFont *)font andString:(NSString *)string
{
    // line break truncating
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    
    // attributed string with white etched shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor whiteColor]];
    [shadow setShadowOffset:NSMakeSize(-0.0, -1.0)];
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
        font,   NSFontAttributeName,
        shadow, NSShadowAttributeName,
        paragraphStyle, NSParagraphStyleAttributeName,
        nil];
    
    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
}

- (void)drawBackgroundInRect:(NSRect)dirtyRect
{
    [super drawBackgroundInRect:dirtyRect];
    
    CKTableCellView *tableCellView = [self viewAtColumn:0];

    if (self.isSelected) {
        tableCellView.nameLabel.attributedStringValue =
            [self etchedStringWithFont:[NSFont applicationBoldMedium]
                             andString:tableCellView.nameLabel.stringValue];
        
        // this is a hack
        [tableCellView.messageLabel.cell setBackgroundStyle:NSBackgroundStyleRaised];
        //tableCellView.messageLabel.attributedStringValue =
        //    [self etchedStringWithFont:[NSFont applicationLightSmall]
        //                     andString:tableCellView.messageLabel.stringValue];
        
        tableCellView.timestampLabel.attributedStringValue =
            [self etchedStringWithFont:[NSFont applicationLightSmall]
                             andString:tableCellView.timestampLabel.stringValue];
    } else {
        tableCellView.nameLabel.textColor      = [NSColor darkGrayColor];
        tableCellView.messageLabel.textColor   = [NSColor grayColor];
        tableCellView.timestampLabel.textColor = [NSColor alternateSelectedControlColor];
        
        [tableCellView.nameLabel.cell setBackgroundStyle:NSBackgroundStyleLight];
        [tableCellView.messageLabel.cell setBackgroundStyle:NSBackgroundStyleLight];
        [tableCellView.timestampLabel.cell setBackgroundStyle:NSBackgroundStyleLight];
    }
    
    // draw white border
    NSRect borderRect = CKCopyRect(dirtyRect);
    borderRect.origin.x = 14;
    borderRect.origin.y += 0;
    borderRect.size.height -= 1;
    borderRect.size.width -= 14;
    [[NSColor colorWithCalibratedRed:237/255.0 green:246/255.0 blue:244/255.0 alpha:1] set];
    NSRectFill(borderRect);

    // draw background noise body
    CGRect bodyRect = CGRectInset(borderRect, 1, 1);
    [[NSColor mediumBackgroundNoiseColor] set];
    NSRectFill(bodyRect);
}

- (void)drawSelectionInRect:(NSRect)dirtyRect
{
    // draw selection gradient
    NSBezierPath *clipRect = [NSBezierPath bezierPathWithRect:self.bounds];
    
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor selectionGradientStartColor]
        endingColor:[NSColor selectionGradientEndColor]];
    
    [gradient drawInBezierPath:clipRect angle:270.0];
}


@end
