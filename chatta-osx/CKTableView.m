//
//  CKTableView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKTableView.h"

@implementation CKTableView

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        // Initialization code here.        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.target = self;
    self.action = @selector(ckTableViewSingleClick:);
    self.doubleAction = @selector(ckTableViewDoubleClick:);
}

- (void)ckTableViewSingleClick:(id)sender
{
    if (self.clickedRow < 0) {
        [self deselectAll:self];
        return;
    }
    
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(tableView:didSingleClickRow:)]) {
            [(id)self.delegate tableView:self didSingleClickRow:self.clickedRow];
        }
    }
}

- (void)ckTableViewDoubleClick:(id)sender
{
    if (self.clickedRow < 0) {
        [self deselectAll:self];
        return;
    }
    
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(tableView:didDoubleClickRow:)]) {
            [(id)self.delegate tableView:self didDoubleClickRow:self.clickedRow];
        }
    }
}

#pragma mark - Overridden Methods

- (void)reloadData
{
    // save previously selected row
    NSInteger previouslySelectedRow = self.selectedRow;

    // reload data
    [super reloadData];
    
    // reselect row
    NSIndexSet *selectedIndexSet = [NSIndexSet indexSetWithIndex:previouslySelectedRow];
    [self selectRowIndexes:selectedIndexSet byExtendingSelection:NO];
}

- (void)drawGridInClipRect:(NSRect)clipRect
{
    NSRect lastRect      = [self rectOfRow:self.numberOfRows - 1];
    NSRect newClipRect   = NSMakeRect(0, 0, lastRect.size.width, NSMaxY(lastRect));
    NSRect clipRectInter = NSIntersectionRect(clipRect, newClipRect);
    [super drawGridInClipRect:clipRectInter];
}

@end
