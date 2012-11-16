//
//  CKButton.m
//  CustomButton
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKButton.h"
#import "CKButtonCell.h"

@implementation CKButton

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTrackingArea];
        self.buttonCell = [[CKButtonCell alloc] init];
        [self setCell:self.buttonCell];
        [self setBezelStyle:NSShadowlessSquareBezelStyle];
    }
    
    return self;
}

+ (Class)cellClass
{
    return [CKButtonCell class];
}
    
- (void)createTrackingArea
{
    NSTrackingAreaOptions trackingAreaOptions = NSTrackingActiveInActiveApp;
    trackingAreaOptions |= NSTrackingMouseEnteredAndExited;
    trackingAreaOptions |= NSTrackingAssumeInside;
    trackingAreaOptions |= NSTrackingInVisibleRect;
    
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
        options:trackingAreaOptions owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

#pragma mark - Overridden Methods

- (void)mouseEntered:(NSEvent *)event
{
    ((CKButtonCell *)self.cell).isHover = YES;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    ((CKButtonCell *)self.cell).isHover = NO;
    [self setNeedsDisplay:YES];
}

@end
