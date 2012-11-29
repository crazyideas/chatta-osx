//
//  CKStatus.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKStatusView.h"
#import "NSColor+CKAdditions.h"

@implementation CKStatusView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contactState = ContactStateIndeterminate;
    }
    
    return self;
}

#pragma mark - Properties

- (void)setContactState:(ContactState)contactState
{
    _contactState = contactState;
    [self setNeedsDisplay:YES];
}

- (BOOL)wantsDefaultClipping
{
    return NO;
}

#pragma mark - Overridden Methods


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

    NSColor *outlineRectColor;
    NSColor *bodyRectColor;
    NSColor *separatorRectColor;
 
    switch (self.contactState) {
        case ContactStateOnline:
        {
            outlineRectColor = [NSColor greenStatusOutlineColor];
            bodyRectColor = [NSColor greenStatusColor];
            separatorRectColor = [NSColor gridSeparatorColor];
            break;
        }
        //case ContactStateAway:
        //    outlineRectColor = [NSColor yellowStatusOutlineColor];
        //    bodyRectColor = [NSColor yellowStatusColor];
        //    separatorRectColor = [NSColor gridSeparatorColor];
        //    break;
        case ContactStateOffline:
        {
            outlineRectColor = [NSColor blueStatusOutlineColor];
            bodyRectColor = [NSColor blueStatusColor];
            separatorRectColor = [NSColor gridSeparatorColor];
            break;
        }
        case ContactStateIndeterminate:
        {
            outlineRectColor = [NSColor mediumBackgroundNoiseColor];
            bodyRectColor = [NSColor mediumBackgroundNoiseColor];
            separatorRectColor = [NSColor mediumBackgroundNoiseColor];
            break;
        }
        default:
        {
            outlineRectColor = [NSColor mediumBackgroundNoiseColor];
            bodyRectColor = [NSColor mediumBackgroundNoiseColor];
            separatorRectColor = [NSColor mediumBackgroundNoiseColor];
            break;
        }
    }
 
    // draw status indicator, should eventually move to its own class
    NSRect borderRect = CKCopyRect(dirtyRect);
    borderRect.origin.x -= 1;
    borderRect.origin.y += 0;
    borderRect.size.width = 13;
    borderRect.size.height += 1;
    [bodyRectColor set];
    NSRectFill(borderRect);
 
    CGRect separatorRect = NSMakeRect(borderRect.size.width - 1, 0, 1, self.frame.size.height + 1);
    [separatorRectColor set];
    NSRectFill(separatorRect);
}
 
@end
