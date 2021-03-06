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

#import "CKButton.h"
#import "CKTableView.h"
#import "CKScrollView.h"
#import "CKTableRowView.h"
#import "CKTableHeaderCell.h"
#import "CKTableCellView.h"

#import "MasterView.h"
#import "ContactView.h"
#import "ContactViewController.h"
#import "DetailViewController.h"

@implementation MasterViewController

- (id)initWithFrame:(NSRect)frame
{
    self = [super init];
    if (self) {
        self.masterView = [[MasterView alloc] initWithFrame:frame];
        [self.masterView setAutoresizesSubviews:YES];
        [self.masterView setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin |
         NSViewMinYMargin | NSViewMaxYMargin];
        
        [self.masterView.tableView setDelegate:self];
        [self.masterView.tableView setDataSource:self];
        [self.masterView.tableView registerForDraggedTypes:[NSArray arrayWithObjects:(id)kUTTypeText, nil]];
        [self.masterView.tableView setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];
        
        [self.masterView.addContactButton setTarget:self];
        [self.masterView.addContactButton setAction:@selector(showContactAction:)];
        
        [self.masterView.addMessageButton setTarget:self];
        [self.masterView.addMessageButton setAction:@selector(showMessageAction:)];
        
        self.contactViewController = [[ContactViewController alloc] init];
        [self.contactViewController setDelegate:self];
        
        self.messageViewController = [[MessageViewController alloc] init];
        [self.messageViewController setDelegate:self];
        
        self.detailViewController.contact = nil;
        self.detailViewController.enabled =
        (self.chattaKit.chattaState == ChattaStateConnected) ? YES : NO;
        
        [CKContactList sharedInstance].delegate = self;
        self.connectionState = ChattaStateDisconnected;
        self.previouslySelectedRow = -1;
        
        self.view = self.masterView;
    }
    return self;
}

- (void)updateSelectedContact:(id)sender
{
    self.contactViewController.contactViewType =
        ([sender isKindOfClass:[NSButton class]]) ? ContactViewTypeAddContact : ContactViewTypeUpdateContact;
    
    if ([sender isKindOfClass:[NSButton class]]) {
        [self.contactViewController.popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
    } else {
        NSInteger selectedRow = self.masterView.tableView.selectedRow;
        sender = [self.masterView.tableView rowViewAtRow:selectedRow makeIfNecessary:YES];
        self.contactViewController.contact = [[CKContactList sharedInstance] contactWithIndex:selectedRow];
        [self.contactViewController.popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxXEdge];
    }
}

- (void)removeSelectedContact:(id)sender
{
    NSInteger selectedRow = self.masterView.tableView.selectedRow;
    CKDebug(@"[+] MasterViewController: removeSelectedContact: %li", selectedRow);

    if (selectedRow < 0) {
        return;
    }
    
    CKContact *rmContact = [[CKContactList sharedInstance] contactWithIndex:selectedRow];
    
    // flush detail views cache of the conversation
    [self.detailViewController flushCacheForContact:rmContact];

    // remove contact from contact list
    [[CKContactList sharedInstance] removeContact:rmContact];
    
    // update master view interface
    [self.masterView.tableView deselectAll:self];
    [self.masterView.tableView reloadData];
}

- (void)keyDown:(NSEvent *)event
{
    [super keyDown:event];
}

#pragma mark - Properties

- (void)setConnectionState:(ChattaState)connectionState
{
    BOOL newState = (connectionState == ChattaStateConnected) ? YES : NO;
    
    //[self.detailViewController setEnabled:newState];
    [self.masterView.addMessageButton setEnabled:newState];
    //[self.masterView.addMessageButton setNeedsDisplay:YES];
    
    _connectionState = connectionState;
}

#pragma mark - CKContactList Delegates

- (void)addedContact:(CKContact *)contact
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.masterView.tableView reloadData];
    });
}

- (void)removedContact:(CKContact *)contact
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.masterView.tableView reloadData];
    });
}

- (void)newMessage:(CKMessage *)message forContact:(CKContact *)contact
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        __block MasterViewController *block_self = self;
        NSInteger selectedRow = block_self.masterView.tableView.selectedRow;
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
        [block_self.masterView.tableView reloadData];
    });
}

- (void)contactConnectionStateUpdated:(ContactState)state forContact:(CKContact *)contact
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        __block MasterViewController *block_self = self;
        [block_self.masterView.tableView reloadData];
    });
}

#pragma mark - NSTableView delegates

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 82.0;
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    NSUInteger rows = [[CKContactList sharedInstance] count];
    
    // add placeholder if there are not contacts
    if (rows <= 0) {
        [self.masterView changeViewState:MasterViewStateNoContacts];
    } else {
        [self.masterView changeViewState:MasterViewStateNormal];
    }
    
    return rows;
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
    
    if (row == self.masterView.tableView.selectedRow) {
        [self.detailViewController updateTextFieldPlaceholderText:contact];
    }
    
    return cellView;
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
    CKContact *selectedContact = [[CKContactList sharedInstance] contactWithIndex:row];
    
    // update unread count
    selectedContact.unreadCount = 0;
    [self.masterView.tableView reloadData];
}

- (void)tableView:(CKTableView *)tableView didDoubleClickRow:(NSInteger)row
{
    NSInteger selectedRow = self.masterView.tableView.selectedRow;
    id sender = [tableView rowViewAtRow:selectedRow makeIfNecessary:YES];
    
    [self updateSelectedContact:sender];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger selectedRow = self.masterView.tableView.selectedRow;
        
    if (selectedRow == self.previouslySelectedRow) {
        return;
    }
    
    // update selected contact
    CKContact *selectedContact = [[CKContactList sharedInstance] contactWithIndex:selectedRow];
    self.detailViewController.enabled = (self.chattaKit.chattaState == ChattaStateConnected) ? YES : NO;
    self.detailViewController.contact = (selectedRow < 0) ? nil : selectedContact;
    CKDebug(@"[+] tableViewSelectionDidChange: %li", self.masterView.tableView.selectedRow);
    
    if (self.delegate != nil) {
        [self.delegate selectedContactDidChange:(selectedRow < 0) ? nil : selectedContact];
    }
    
    self.previouslySelectedRow = selectedRow;
}

#pragma mark - TableView dragging delegates

- (id <NSPasteboardWriting>)tableView:(NSTableView *)tableView pasteboardWriterForRow:(NSInteger)row
{
    return [[CKContactList sharedInstance] contactWithIndex:row];

}

- (void)tableView:(NSTableView *)tableView updateDraggingItemsForDrag:(id<NSDraggingInfo>)draggingInfo
{
    NSTableColumn *tableColumn = tableView.tableColumns[0];
    
    CKTableCellView *tableCellView = [tableView makeViewWithIdentifier:@"ckRow" owner:self];
    NSArray *classes = [NSArray arrayWithObject:[CKContact class]];
    NSRect cellFrame = NSMakeRect(0, 0, tableColumn.width, tableView.rowHeight);

    [draggingInfo enumerateDraggingItemsWithOptions:0 forView:tableView classes:classes searchOptions:nil usingBlock:
        ^(NSDraggingItem *draggingItem, NSInteger index, BOOL *stop) {
            draggingItem.draggingFrame = cellFrame;
            draggingItem.imageComponentsProvider =
                ^(void) {
                    tableCellView.objectValue = draggingItem.item;
                    tableCellView.frame = cellFrame;
                    return [tableCellView draggingImageComponents];
                };
        }
    ];
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info
    proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
    info.animatesToDestination = YES;
    
    if (dropOperation == NSTableViewDropOn) {
        return NSDragOperationNone;
    }
    
    return NSDragOperationMove;
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row
    dropOperation:(NSTableViewDropOperation)dropOperation
{
    __block NSInteger destinationRow = row;
    __block MasterViewController *block_self = self;
    NSArray *classes = [NSArray arrayWithObject:[CKContact class]];
    
    [info enumerateDraggingItemsWithOptions:0 forView:tableView classes:classes searchOptions:nil usingBlock:
        ^(NSDraggingItem *draggingItem, NSInteger index, BOOL *stop) {
        
            CKContact *dragContact = (CKContact *)draggingItem.item;
            CKContact *contactInList = [[CKContactList sharedInstance] contactWithName:dragContact.displayName];
            NSInteger sourceRow = [[CKContactList sharedInstance] indexOfContact:contactInList];
        
            NSLog(@"[+] MasterViewController, source row: %lu", sourceRow);

            if (sourceRow < 0) {
                return;
            }
            
            if (sourceRow == destinationRow) {
                return;
            }
        
            [block_self.masterView.tableView beginUpdates];
        
            NSUInteger fromRow = sourceRow;
            NSUInteger toRow   = (fromRow > destinationRow) ? destinationRow + 0 : destinationRow - 1;
        
            NSLog(@"[+] MasterViewController, swapping row: %lu and %lu", fromRow, toRow);
            
            [block_self.masterView.tableView moveRowAtIndex:fromRow toIndex:toRow];
            [[CKContactList sharedInstance] swapContactsFrom:fromRow to:toRow];
                        
            [block_self.masterView.tableView endUpdates];
            [block_self.masterView.tableView reloadData];
    }];
    
    return YES;
}


#pragma mark - MessageView delegates

- (void)sendNewMessage:(NSString *)message toContact:(CKContact *)contact newContact:(BOOL)newContact
{
    CKContact *contactInList;
    if (newContact == YES) {
        contactInList = [self addContactWithName:contact.displayName email:contact.jabberIdentifier
            phone:contact.phoneNumber];
    } else {
        contactInList = contact;
    }
    
    if (self.delegate != nil && contactInList != nil) {
        [self.delegate sendNewMessage:message toContact:contactInList];
    }
}

#pragma mark - ConfigureView delegates

- (CKContact *)addContactWithName:(NSString *)name email:(NSString *)address phone:(NSString *)number
{
    CKDebug(@"[+] MasterViewController: addContactWithName");
    CKContact *contact = [[CKContact alloc] initWithJabberIdentifier:address
        andDisplayName:name andPhoneNumber:number andContactState:ContactStateIndeterminate];
    [[CKContactList sharedInstance] addContact:contact];
    
    if (self.chattaKit.chattaState == ChattaStateConnected) {
        [self.chattaKit requestContactStatus:contact];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.masterView.tableView reloadData];
    });
    
    return contact;
}

- (CKContact *)updateContact:(CKContact *)contact withName:(NSString *)name
                       email:(NSString *)address phone:(NSString *)number
{
    CKDebug(@"[+] MasterViewController: updateContact");
    contact.displayName      = name;
    contact.jabberIdentifier = address;
    contact.phoneNumber      = number;
    
    // force a update of the detail view controller
    NSInteger selectedRow = self.masterView.tableView.selectedRow;
    CKContact *selectedContact = [[CKContactList sharedInstance] contactWithIndex:selectedRow];
    self.detailViewController.contact = (selectedRow < 0) ? nil : selectedContact;
    self.detailViewController.enabled = (self.chattaKit.chattaState == ChattaStateConnected) ? YES : NO;
    
    [self.chattaKit requestContactStatus:contact];
    [self.masterView.tableView reloadData];
    
    return contact;
}

- (void)popoverWillClose:(id)sender
{
    CKDebug(@"[+] MasterViewController: popoverWillClose");
    self.masterView.addContactButton.state = NSOffState;
    self.masterView.addMessageButton.state = NSOffState;
}

#pragma mark - Actions

- (void)showContactAction:(id)sender
{
    CKDebug(@"[+] MasterViewController, showContactAction");
    [self updateSelectedContact:sender];
}

- (void)showMessageAction:(id)sender
{
    CKDebug(@"[+] MasterViewController, showMessageAction");
    [self.messageViewController.popover showRelativeToRect:[sender bounds]
        ofView:sender preferredEdge:NSMaxYEdge];
}

@end
