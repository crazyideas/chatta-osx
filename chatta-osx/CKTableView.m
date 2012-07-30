//
//  CKTableView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKTableView.h"

@implementation CKTableView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawGridInClipRect:(NSRect)clipRect
{
    NSRect lastRect      = [self rectOfRow:self.numberOfRows - 1];
    NSRect newClipRect   = NSMakeRect(0, 0, lastRect.size.width, NSMaxY(lastRect));
    NSRect clipRectInter = NSIntersectionRect(clipRect, newClipRect);
    [super drawGridInClipRect:clipRectInter];
}

@end
