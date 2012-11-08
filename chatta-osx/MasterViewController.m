//
//  MasterViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "MasterViewController.h"

#import "ChattaKit.h"
#import "CKContact.h"
#import "CKMessage.h"
#import "CKConstants.h"
#import "CKContactList.h"

#import "NSFont+CKAdditions.h"
#import "NSColor+CKAdditions.h"
#import "NSSound+CKAdditions.h"
#import "NSButton+CKAdditions.h"

#import "CKTableView.h"
#import "CKScrollView.h"
#import "CKTableRowView.h"
#import "CKTableHeaderCell.h"
#import "CKTableCellView.h"

#import "PopoverView.h"
#import "PopoverViewController.h"
#import "DetailViewController.h"

@implementation MasterViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.view = [[NSView alloc] initWithFrame:NSZeroRect];
        [self.view setAutoresizesSubviews:YES];
        [self.view setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin |
            NSViewMinYMargin | NSViewMaxYMargin];
        
        self.scrollView            = [[CKScrollView alloc] initWithFrame:NSZeroRect];
        self.tableView             = [[CKTableView alloc] initWithFrame:NSZeroRect];
        self.tableColumn           = [[NSTableColumn alloc] initWithIdentifier:@"contactColumn"];
        self.lineSeparator         = [[NSBox alloc] initWithFrame:NSZeroRect];
        self.addContactButton      = [[NSButton alloc] initWithFrame:NSZeroRect];
        self.popoverViewController = [[PopoverViewController alloc] init];

        NSTableHeaderView *tableHeaderView =
            [[NSTableHeaderView alloc] initWithFrame:NSMakeRect(0, 0, 0, 26)];
        
        [self.tableView addTableColumn:self.tableColumn];
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];        
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
        [self.addContactButton setTarget:self];
        [self.addContactButton setAction:@selector(showPopoverAction:)];
        [self.addContactButton setBordered:NO];
        
        [self.popoverViewController setDelegate:self];
        
        [self.view addSubview:self.scrollView];
        [self.view addSubview:self.lineSeparator];
        [self.view addSubview:self.addContactButton];
        
        self.detailViewController.contact = nil;
        self.detailViewController.enabled =
            (self.chattaKit.chattaState == ChattaStateConnected) ? YES : NO;
        
        [CKContactList sharedInstance].delegate = self;
        self.connectionState = ChattaStateDisconnected;
        self.previouslySelectedRow = -1;
    }
    return self;
}

#pragma mark - Properties

- (void)setConnectionState:(ChattaState)connectionState
{
    self.detailViewController.enabled = (connectionState == ChattaStateConnected) ? YES : NO;
    
    _connectionState = connectionState;
}

#pragma mark - CKContactList Delegates

- (void)addedContact:(CKContact *)contact
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.tableView reloadData];
    });
}

- (void)removedContact:(CKContact *)contact
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.tableView reloadData];
    });
}

- (void)newMessage:(CKMessage *)message forContact:(CKContact *)contact
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        __block MasterViewController *block_self = self;
        NSInteger selectedRow = block_self.tableView.selectedRow;
        CKContact *selectedContact = [[CKContactList sharedInstance] contactWithIndex:selectedRow];
        
        // if new message is not for the selected contact, update unread count
        if (![contact isEqualToContact:selectedContact]) {
            contact.unreadCount += 1;
        }
        
        // if window is not visible, update docktile
        if (!block_self.isVisible) {
            NSDockTile *dockTile = [[NSApplication sharedApplication] dockTile];
            int dockValue = ([dockTile.badgeLabel isEqualToString:@""])
                ? 0 : [dockTile.badgeLabel intValue];
            dockTile.badgeLabel = [NSString stringWithFormat:@"%i", ++dockValue];
            
            [NSSound playNewMessageBackgroundSound];
        } else {
            [NSSound playNewMessageForegroundSound];
        }
        
        // if new message is for selected contact, update detailViewController
        if ([selectedContact isEqualToContact:contact]) {
            [block_self.detailViewController appendNewMessage:message forContact:contact];
        }
        
        //[block_self updateUnreadCount];
        [block_self.tableView reloadData];
    });
}

- (void)contactConnectionStateUpdated:(ContactState)state forContact:(CKContact *)contact
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        __block MasterViewController *block_self = self;
        [block_self.tableView reloadData];
    });
}

#pragma mark - NSTableView delegates

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 82.0;
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return [[CKContactList sharedInstance] count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row
{
    CKTableCellView *cellView = [tableView makeViewWithIdentifier:@"cellView" owner:self];
    if (cellView == nil) {
        cellView = [[CKTableCellView alloc] initWithFrame:NSMakeRect(0, 0, 250, 82)];
        cellView.identifier = @"cellView";
    }
    
    CKContact *contact = [[CKContactList sharedInstance] contactWithIndex:row];
    if (contact == nil) {
        return nil;
    }
    
    // update contact for cell
    CKMessage *lastMessage = contact.messages.lastObject;

    cellView.nameLabel.stringValue = contact.displayName;
    cellView.messageLabel.stringValue = (lastMessage == nil) ? @"" : lastMessage.text;
    cellView.timestampLabel.stringValue = (lastMessage == nil) ? @"" : lastMessage.timestampString;
    cellView.contactState = contact.connectionState;
    
    // set bold if unread messages
    if (contact.unreadCount > 0) {
        cellView.messageLabel.font   = [NSFont fontWithName:@"HelveticaNeue-Bold" size:12];
        cellView.timestampLabel.font = [NSFont fontWithName:@"HelveticaNeue-Bold" size:12];
    } else {
        cellView.messageLabel.font   = [NSFont fontWithName:@"HelveticaNeue-Light" size:12];
        cellView.timestampLabel.font = [NSFont fontWithName:@"HelveticaNeue-Light" size:12];
    }
    
    CKDebug(@"[+] MasterViewController, viewForTableColumn, selectedRow: %li", self.tableView.selectedRow);
    if (row == self.tableView.selectedRow) {
        [self.detailViewController updateTextFieldPlaceholderText:contact];
    }
    
    return cellView;
    
    /*
     NSTextField *result = [tableView makeViewWithIdentifier:@"contactView" owner:self];
     if (result == nil) {
     result = [[NSTextField alloc] init];
     [result setBezeled:NO];
     [result setDrawsBackground:NO];
     [result setEditable:NO];
     [result setSelectable:NO];
     result.identifier = @"contactView";
     }
     
     result.stringValue = [NSString stringWithFormat:@"Row: %ld", row];
     return result;
     */
}


- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    CKTableRowView *tableRowView = [tableView makeViewWithIdentifier:@"ckRow" owner:self];
    if (tableRowView == nil) {
        NSRect rowFrame = [tableView frameOfCellAtColumn:0 row:row];
        tableRowView = [[CKTableRowView alloc] initWithFrame:rowFrame];
        tableRowView.identifier = @"ckRow";
        
        //tableRowView.separatorStyle = CKTableRowSeparatorStyleSingleLine;
    }
    return tableRowView;
}

- (void)tableView:(CKTableView *)tableView didSingleClickRow:(NSInteger)row
{
    
}

- (void)tableView:(CKTableView *)tableView didDoubleClickRow:(NSInteger)row
{
    NSInteger selectedRow = self.tableView.selectedRow;
    id sender = [tableView rowViewAtRow:selectedRow makeIfNecessary:YES];
    
    self.popoverViewController.popoverType = PopoverTypeUpdateContact;
    self.popoverViewController.contact     = [[CKContactList sharedInstance] contactWithIndex:selectedRow];

    [self.popoverViewController.popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxXEdge];
}

- (void)tableView:(CKTableView *)tableView didRequestDeleteRow:(NSInteger)row
{
    CKDebug(@"[+] MasterViewController: tableView:didRequestDeleteRow: %li", row);

    if (row < 0) {
        return;
    }
    
    CKContact *rmContact = [[CKContactList sharedInstance] contactWithIndex:row];
    [[CKContactList sharedInstance] removeContact:rmContact];
    
    [self.tableView deselectAll:self];
    [self.tableView reloadData];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger selectedRow = self.tableView.selectedRow;
        
    if (selectedRow == self.previouslySelectedRow) {
        return;
    }
    
    // update selected contact
    CKContact *selectedContact = [[CKContactList sharedInstance] contactWithIndex:selectedRow];
    self.detailViewController.enabled = (self.chattaKit.chattaState == ChattaStateConnected) ? YES : NO;
    self.detailViewController.contact = (selectedRow < 0) ? nil : selectedContact;
    CKDebug(@"[+] tableViewSelectionDidChange: %li", self.tableView.selectedRow);
    
    self.previouslySelectedRow = selectedRow;
}

#pragma mark - Popover delegates

- (void)addContactWithName:(NSString *)name email:(NSString *)address phone:(NSString *)number
{
    CKDebug(@"[+] MasterViewController: addContactWithName");
    CKContact *contact = [[CKContact alloc] initWithJabberIdentifier:address
        andDisplayName:name andPhoneNumber:number andContactState:ContactStateIndeterminate];
    [[CKContactList sharedInstance] addContact:contact];
    
    if (self.chattaKit.chattaState == ChattaStateConnected) {
        [self.chattaKit requestContactStatus:contact];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.tableView reloadData];
    });
}

- (void)updateContact:(CKContact *)contact withName:(NSString *)name email:(NSString *)address phone:(NSString *)number
{
    CKDebug(@"[+] MasterViewController: updateContact");
    contact.displayName      = name;
    contact.jabberIdentifier = address;
    contact.phoneNumber      = number;
    
    // force a update of the detail view controller
    NSInteger selectedRow = self.tableView.selectedRow;
    CKContact *selectedContact = [[CKContactList sharedInstance] contactWithIndex:selectedRow];
    self.detailViewController.contact = (selectedRow < 0) ? nil : selectedContact;
    self.detailViewController.enabled = (self.chattaKit.chattaState == ChattaStateConnected) ? YES : NO;
    
    [self.chattaKit requestContactStatus:contact];
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void)showPopoverAction:(id)sender
{
    self.popoverViewController.popoverType =
        ([sender isKindOfClass:[NSButton class]]) ? PopoverTypeAddContact : PopoverTypeUpdateContact;
    [self.popoverViewController.popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
}

@end
