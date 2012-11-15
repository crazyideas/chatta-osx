//
//  MasterView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "MasterView.h"

#import "CKButton.h"
#import "CKSeparator.h"
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
        self.scrollView          = [[CKScrollView alloc] initWithFrame:NSZeroRect];
        self.tableView           = [[CKTableView alloc] initWithFrame:NSZeroRect];
        self.tableColumn         = [[NSTableColumn alloc] initWithIdentifier:@"contactColumn"];
        self.horizontalSeparator = [[CKSeparator alloc] initWithFrame:NSZeroRect];
        self.verticalSeparator   = [[CKSeparator alloc] initWithFrame:NSZeroRect];
        self.addContactButton    = [[CKButton alloc] initWithFrame:NSZeroRect];
        self.addMessageButton    = [[CKButton alloc] initWithFrame:NSZeroRect];
        self.placeholderString   = [[CKLabel alloc] initWithFrame:NSZeroRect];
        
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
        
        [self.horizontalSeparator setBackgroundColor:[NSColor mediumBackgroundNoiseColor]];
        [self.horizontalSeparator setFrame:NSMakeRect(0, 50.5, 400, 1.5)];
        [self.horizontalSeparator setAutoresizesSubviews:NSViewWidthSizable];
        [self.horizontalSeparator setAutoresizingMask:NSViewWidthSizable | NSViewMaxYMargin];
        [self.horizontalSeparator setHasNotch:NO];
        [self.verticalSeparator setWantsLayer:YES];
        
        [self.verticalSeparator setBackgroundColor:[NSColor darkBackgroundNoiseColor]];
        [self.verticalSeparator setFrame:NSMakeRect(self.frame.size.width/2.0, 0, 1.5, 50)];
        [self.verticalSeparator setAutoresizesSubviews:NSViewWidthSizable];
        [self.verticalSeparator setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin];
        [self.verticalSeparator setHasNotch:NO];
        [self.verticalSeparator setWantsLayer:YES];

        [self.addContactButton setTitle:@"ADD CONTACT"];
        [self.addContactButton setFont:[NSFont applicationRegularSmall]];
        [self.addContactButton setTitleColor:[NSColor darkGrayColor]];
        [self.addContactButton setBezelStyle:NSRoundedBezelStyle];
        [self.addContactButton setAutoresizingMask:NSViewWidthSizable | NSViewMaxYMargin | NSViewMinXMargin | NSViewMaxXMargin];
        
        [self.addMessageButton setTitle:@"NEW MESSAGE"];
        [self.addMessageButton setFont:[NSFont applicationRegularSmall]];
        [self.addMessageButton setTitleColor:[NSColor darkGrayColor]];
        [self.addMessageButton setBezelStyle:NSRoundedBezelStyle];
        [self.addMessageButton setAutoresizingMask:NSViewWidthSizable | NSViewMaxYMargin | NSViewMinXMargin | NSViewMaxXMargin];

        // adjust add button
        CGFloat masterAddButtonW = frame.size.width / 2.0;
        CGFloat masterAddButtonH = 50;
        CGFloat masterAddButtonX = 0;
        CGFloat masterAddButtonY = 0;
        self.addContactButton.frame =
            NSMakeRect(masterAddButtonX, masterAddButtonY, masterAddButtonW, masterAddButtonH);
        
        CGFloat masterNewButtonW = frame.size.width / 2.0;
        CGFloat masterNewButtonH = 50;
        CGFloat masterNewButtonX = masterAddButtonW;
        CGFloat masterNewButtonY = 0;
        self.addMessageButton.frame =
        NSMakeRect(masterNewButtonX, masterNewButtonY, masterNewButtonW, masterNewButtonH);
        
        // adjust scroll view
        CGFloat masterScrollW = frame.size.width;
        CGFloat masterScrollH = frame.size.height - masterAddButtonH;
        CGFloat masterScrollX = 0;
        CGFloat masterScrollY = 50;
        self.scrollView.frame =
            NSMakeRect(masterScrollX, masterScrollY, masterScrollW, masterScrollH);
        
        // config no contacts placeholder
        CGFloat placeholderX = (frame.size.width - 157) / 2.0;
        NSRect placeholderRect = NSMakeRect(placeholderX, frame.size.height/2, 157, 22);
        [self.placeholderString setFrame:placeholderRect];
        [self.placeholderString setTextColor:[NSColor darkGrayColor]];
        [self.placeholderString setAttributedStringValue:[NSFont etchedString:@"No Contacts Found" withFont:[NSFont applicationLightLarge]]];
        [self.placeholderString setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin];
        
        [self addSubview:self.scrollView];
        [self addSubview:self.horizontalSeparator];
        [self addSubview:self.verticalSeparator];
        [self addSubview:self.addContactButton];
        [self addSubview:self.addMessageButton];
    }
    
    return self;
}

- (void)changeViewState:(MasterViewState)newMasterViewState
{
    switch (newMasterViewState) {
        case MasterViewStateNormal:
        {
            [self.placeholderString removeFromSuperview];
            break;
        }
        case MasterViewStateNoContacts:
        {
            [self addSubview:self.placeholderString];
            break;
        }
        default:
        {
            break;
        }
    }
}

@end
