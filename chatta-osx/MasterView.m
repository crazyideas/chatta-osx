//
//  MasterView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "MasterView.h"

#import "CKTableView.h"
#import "CKScrollView.h"
#import "CKTableRowView.h"
#import "CKTableHeaderCell.h"
#import "CKTableCellView.h"

#import "NSFont+CKAdditions.h"
#import "NSColor+CKAdditions.h"
#import "NSSound+CKAdditions.h"
#import "NSButton+CKAdditions.h"

@implementation MasterView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        self.scrollView            = [[CKScrollView alloc] initWithFrame:NSZeroRect];
        self.tableView             = [[CKTableView alloc] initWithFrame:NSZeroRect];
        self.tableColumn           = [[NSTableColumn alloc] initWithIdentifier:@"contactColumn"];
        self.lineSeparator         = [[NSBox alloc] initWithFrame:NSZeroRect];
        self.addContactButton      = [[NSButton alloc] initWithFrame:NSZeroRect];
        
        NSTableHeaderView *tableHeaderView =
            [[NSTableHeaderView alloc] initWithFrame:NSMakeRect(0, 0, 0, 26)];
        
        [self.tableView addTableColumn:self.tableColumn];
        [self.tableView setBackgroundColor:[NSColor lightBackgroundNoiseColor]];
        [self.tableView setBackgroundColor:[NSColor clearColor]];
        [self.tableView setHeaderView:tableHeaderView];
        [self.tableView setAllowsEmptySelection:YES];
        [self.tableView setGridStyleMask:NSTableViewSolidHorizontalGridLineMask];
        
        // replace column header
        for (NSTableColumn *column in self.tableView.tableColumns) {
            [column setHeaderCell:[[CKTableHeaderCell alloc] init]];
            [column.headerCell setStringValue:@"Contacts"];
        }
        
        [self.scrollView setDocumentView:self.tableView];
        [self.scrollView setHasVerticalScroller:YES];
        [self.scrollView setAutohidesScrollers:NO];
        [self.scrollView setAutoresizesSubviews:YES];
        [self.scrollView setDrawsBackground:NO];
        [self.scrollView setBackgroundColor:[NSColor clearColor]];
        
        [self.scrollView setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable |
         NSViewMinXMargin | NSViewMaxXMargin | NSViewMaxYMargin ];
        
        [self.lineSeparator setBorderColor:[NSColor purpleColor]];
        [self.lineSeparator setFrame:NSMakeRect(0, 50, 400, 1.5)];
        [self.lineSeparator setAutoresizesSubviews:NSViewWidthSizable];
        
        [self.addContactButton setTitle:@"+ Add Contact"];
        [self.addContactButton setFont:[NSFont applicationLightLarge]];
        [self.addContactButton setTitleColor:[NSColor darkGrayColor]];
        [self.addContactButton setAutoresizingMask:NSViewWidthSizable | NSViewMaxYMargin | NSViewMinXMargin | NSViewMaxXMargin];
        [self.addContactButton setBordered:NO];

        
        [self addSubview:self.scrollView];
        [self addSubview:self.lineSeparator];
        [self addSubview:self.addContactButton];
    }
    
    return self;
}

@end
