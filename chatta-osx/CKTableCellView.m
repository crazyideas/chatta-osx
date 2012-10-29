//
//  CKTableCellView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKTableCellView.h"
#import "NSColor+CKAdditions.h"

#define CKCopyRect(r) NSMakeRect(r.origin.x, r.origin.y, r.size.width, r.size.height)

@implementation CKTableCellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.nameLabel      = [[CKLabel alloc] initWithFrame:NSMakeRect(30,  58, 148,  20)];
        self.messageLabel   = [[CKLabel alloc] initWithFrame:NSMakeRect(30,  12, 210,  40)];
        self.timestampLabel = [[CKLabel alloc] initWithFrame:NSMakeRect(190, 58, 70,   19)];
        
        self.nameLabel.font                  = [NSFont fontWithName:@"HelveticaNeue-Bold" size:14];
        self.nameLabel.textColor             = [NSColor darkGrayColor];
        self.nameLabel.autoresizingMask      = NSViewWidthSizable | NSViewMaxXMargin;

        self.timestampLabel.font             = [NSFont fontWithName:@"HelveticaNeue-Light" size:12];
        self.timestampLabel.textColor        = [NSColor alternateSelectedControlColor];
        self.timestampLabel.autoresizingMask = NSViewMinXMargin;
        
        self.messageLabel.font               = [NSFont fontWithName:@"HelveticaNeue-Light" size:12];
        self.messageLabel.textColor          = [NSColor darkGrayColor];
        self.messageLabel.autoresizingMask   = NSViewWidthSizable;

        [self.nameLabel.cell setLineBreakMode:NSLineBreakByTruncatingTail];

        [self addSubview:self.nameLabel];
        [self addSubview:self.messageLabel];
        [self addSubview:self.timestampLabel];
    }
    
    return self;
}

- (BOOL)wantsDefaultClipping
{
    return NO;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    NSColor *outlineRectColor;
    NSColor *bodyRectColor;
    NSColor *separatorRectColor;
    
    switch (self.contactState) {
        case ContactStateOnline:
            outlineRectColor = [NSColor greenStatusOutlineColor];
            bodyRectColor = [NSColor greenStatusColor];
            separatorRectColor = [NSColor gridSeparatorColor];
            break;
            /*
        case ContactStateAway:
            outlineRectColor = [NSColor yellowStatusOutlineColor];
            bodyRectColor = [NSColor yellowStatusColor];
            separatorRectColor = [NSColor gridSeparatorColor];
            break;
             */
        case ContactStateOffline:
            outlineRectColor = [NSColor blueStatusOutlineColor];
            bodyRectColor = [NSColor blueStatusColor];
            separatorRectColor = [NSColor gridSeparatorColor];
            break;
        case ContactStateIndeterminate:
            outlineRectColor = [NSColor mediumBackgroundNoiseColor];
            bodyRectColor = [NSColor mediumBackgroundNoiseColor];
            separatorRectColor = [NSColor mediumBackgroundNoiseColor];
            break;
        default:
            outlineRectColor = [NSColor mediumBackgroundNoiseColor];
            bodyRectColor = [NSColor mediumBackgroundNoiseColor];
            separatorRectColor = [NSColor mediumBackgroundNoiseColor];
            break;
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
