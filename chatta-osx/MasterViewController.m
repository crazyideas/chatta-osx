//
//  MasterViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "MasterViewController.h"
#import "ContactCellView.h"
#import "CKTableRowView.h"
#import "CKContactList.h"
#import "CKContact.h"
#import "CKMessage.h"
#import "CKTableView.h"

@implementation MasterViewController

@synthesize delegate                      = _delegate;
@synthesize contactListTableView          = _contactListTableView;
@synthesize unreadTextField               = _unreadTextField;
@synthesize detailViewController          = _detailViewController;
@synthesize contactList                   = _contactList;
@synthesize contactPopoverViewController  = _contactPopoverViewController;
@synthesize settingsPopoverViewController = _settingsPopoverViewController;
@synthesize settingsPopover               = _settingsPopover;
@synthesize minusButton                   = _minusButton;
@synthesize plusButton                    = _plusButton;
@synthesize contactPopover                = _contactPopover;
@synthesize connectionState               = _connectionState;

- (void)setConnectionState:(ChattaState)connectionState
{
    self.settingsPopoverViewController.connectionState = connectionState;
    _connectionState = connectionState;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contactPopoverViewController = [[ContactPopoverViewController alloc] 
            initWithNibName:@"ContactPopoverViewController" bundle:nil];
        self.contactPopoverViewController.delegate = self;
        
        self.settingsPopoverViewController = [[SettingsPopoverViewController alloc]
            initWithNibName:@"SettingsPopoverViewController" bundle:nil];
        self.settingsPopoverViewController.delegate = self;
        
        self.contactPopover  = [[NSPopover alloc] init];
        self.settingsPopover = [[NSPopover alloc] init];
    }
    
    return self;
}

- (void) awakeFromNib
{
    self.contactListTableView.delegate     = self;
    self.contactListTableView.dataSource   = self;
    self.contactListTableView.target       = self;
    self.contactListTableView.doubleAction = @selector(tableViewDoubleClick:);
    self.contactListTableView.action       = @selector(tableViewSingleClick:);
    self.contactListTableView.allowsEmptySelection    = YES;
    self.contactListTableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleSourceList;
    self.contactListTableView.gridStyleMask           = NSTableViewSolidHorizontalGridLineMask;
    
    self.contactPopover.contentViewController = self.contactPopoverViewController;
    self.contactPopover.behavior = NSPopoverBehaviorTransient;
    self.contactPopover.delegate = self.contactPopoverViewController;
    
    self.settingsPopover.contentViewController = self.settingsPopoverViewController;
    self.settingsPopover.behavior = NSPopoverBehaviorTransient;
    self.settingsPopover.delegate = self.settingsPopoverViewController;
    
    self.settingsPopoverViewController.delegate = self;
    self.contactPopoverViewController.delegate  = self;
    
    [self.minusButton setEnabled:NO];
    self.connectionState = ChattaStateDisconnected;
    currentlySelectedRow = -1;
    
    if ([[CKContactList sharedInstance] count] == 0) {
        CKContact *contact = [[CKContact alloc] initWithJabberIdentifier:@"jsmith@gmail.com"
                                                          andDisplayName:@"John Smith" andPhoneNumber:@"1-800-555-1212" andContactState:ConnectionStateIndeterminate];
        [[CKContactList sharedInstance] addContact:contact];
        CKContact *contact2 = [[CKContact alloc] initWithJabberIdentifier:@"jsmith@gmail.com"
                                                          andDisplayName:@"John Smith" andPhoneNumber:@"1-800-555-1111" andContactState:ConnectionStateIndeterminate];
        [[CKContactList sharedInstance] addContact:contact2];
        [self reloadContactTableView:self];

    }
}

#pragma mark - Add, Remove, Update Contact Actions

- (void)reloadContactTableView:(id)sender
{
    [self.contactListTableView reloadData];
    
    if (currentlySelectedRow < 0) {
        [self.minusButton setEnabled:NO];
        [self.contactListTableView deselectAll:self];
    }
    
    NSIndexSet *selectedIndexSet = [NSIndexSet indexSetWithIndex:currentlySelectedRow];
    [self.contactListTableView selectRowIndexes:selectedIndexSet byExtendingSelection:NO];
}

- (IBAction)addContactPushed:(id)sender
{
    self.contactPopoverViewController.popoverType = PopoverTypeAddContact;

    [self.contactPopover showRelativeToRect:[sender bounds] 
                                     ofView:sender 
                              preferredEdge:NSMaxXEdge];
    
    self.contactPopoverViewController.popoverType = PopoverTypeAddContact;
}

- (IBAction)removeContactPushed:(id)sender
{
    if (currentlySelectedRow < 0) {
        return;
    }
    
    CKContact *rmContact = [[CKContactList sharedInstance] contactWithIndex:currentlySelectedRow];
    [[CKContactList sharedInstance] removeContact:rmContact];
    
    currentlySelectedRow = -1;
    [self reloadContactTableView:sender];
}

- (void)tableViewDoubleClick:(id)sender
{
    currentlySelectedRow = [sender clickedRow];
    if (currentlySelectedRow <  0) {
        return;
    }
    
    // update sender to be clicked nstablerowview
    sender = [sender rowViewAtRow:currentlySelectedRow makeIfNecessary:YES];
    
    self.contactPopoverViewController.popoverType = PopoverTypeUpdateContact;

    [self.contactPopover showRelativeToRect:[sender bounds] 
                                     ofView:sender 
                              preferredEdge:NSMaxXEdge];
    
    self.contactPopoverViewController.popoverType = PopoverTypeUpdateContact;
    self.contactPopoverViewController.contact =
        [[CKContactList sharedInstance] contactWithIndex:currentlySelectedRow];
}

#pragma mark - Settings Actions and Delegates

- (IBAction)settingsPushed:(id)sender
{
    [self.settingsPopover showRelativeToRect:[sender bounds] 
                                      ofView:sender 
                               preferredEdge:NSMinYEdge];
}

- (void)loginToChatta
{
    if (self.delegate != nil) {
        [self.delegate loginToChatta];
    }
}

- (void)logoutOfChatta
{
    if (self.delegate != nil) {
        [self.delegate logoutOfChatta];
    }
}

#pragma mark - ContactPopoverDelegate

- (void)addContactWithName:(NSString *)name email:(NSString *)address phone:(NSString *)number
{
    CKContact *contact = [[CKContact alloc] initWithJabberIdentifier:address
        andDisplayName:name andPhoneNumber:number andContactState:ConnectionStateIndeterminate];
    [[CKContactList sharedInstance] addContact:contact];
    
    [self reloadContactTableView:self];
}

- (void)updateContact:(CKContact *)contact withName:(NSString *)name email:(NSString *)address
                phone:(NSString *)number
{
    contact.displayName      = name;
    contact.jabberIdentifier = address;
    contact.phoneNumber      = number;
    
    [self reloadContactTableView:self];
}

- (void)closePopover
{
    [self.contactPopover close];
    [self.settingsPopover close];
}

#pragma mark - NSTableView Delegate and NSTableView DataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [[CKContactList sharedInstance] count];
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    CKTableRowView *tableRowView = [tableView makeViewWithIdentifier:@"ckRow" owner:self];
    if (tableRowView == nil) {
        NSRect rowFrame = [tableView frameOfCellAtColumn:0 row:row];
        tableRowView = [[CKTableRowView alloc] initWithFrame:rowFrame];
        tableRowView.identifier = @"ckRow";
        tableRowView.separatorStyle = CKTableRowSeparatorStyleSingleLineEtched;
    }
    return tableRowView;
}

- (NSView *)tableView:(NSTableView *)tableView 
   viewForTableColumn:(NSTableColumn *)tableColumn 
                  row:(NSInteger)row
{
    // test by setting contactcell == nil
    ContactCellView *contactCell = [tableView makeViewWithIdentifier:@"contactCell" owner:self];
    if (contactCell == nil) {
        NSRect cellFrame = [tableView frameOfCellAtColumn:0 row:row];
        contactCell = [[ContactCellView alloc] initWithFrame:cellFrame];
        contactCell.identifier = @"contactCell";
    }
    
    CKContact *contact = [[CKContactList sharedInstance] contactWithIndex:row];
    if (contact == nil) {        
        return nil;
    }
    
    contactCell.displayName.stringValue = contact.displayName;
    contactCell.connectionState = contact.connectionState;
    
    CKMessage *lastMessage = contact.messages.lastObject;
    if (lastMessage == nil) {
        contactCell.lastMessage.stringValue          = @"";
        contactCell.lastMessageTimestamp.stringValue = @"";
        return contactCell;
    }
    contactCell.lastMessage.stringValue          = lastMessage.text;
    contactCell.lastMessageTimestamp.stringValue = lastMessage.timestampString;

    return contactCell;
}

- (void)tableViewSingleClick:(id)sender
{
    currentlySelectedRow = [sender clickedRow];
    if (currentlySelectedRow < 0) {
        [self.minusButton setEnabled:NO];
        [self.contactListTableView deselectAll:self];
        return;
    }
    [self.minusButton setEnabled:YES];
}

- (IBAction)reloadData:(id)sender
{
    [self reloadContactTableView:sender];
}


@end
