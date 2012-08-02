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
    previouslySelectedRow = -1;
}

#pragma mark - Add, Remove, Update Contact Actions

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
    NSInteger selectedRow = self.contactListTableView.selectedRow;
    if (selectedRow < 0) {
        return;
    }

    CKContact *rmContact = [[CKContactList sharedInstance] contactWithIndex:selectedRow];
    [[CKContactList sharedInstance] removeContact:rmContact];

    [self.contactListTableView deselectAll:self];
    [self.contactListTableView reloadData];
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
    
    [self.contactListTableView reloadData];
}

- (void)updateContact:(CKContact *)contact withName:(NSString *)name email:(NSString *)address
                phone:(NSString *)number
{
    contact.displayName      = name;
    contact.jabberIdentifier = address;
    contact.phoneNumber      = number;
    
    [self.contactListTableView reloadData];
}

- (void)closePopover
{
    [self.contactPopover close];
    [self.settingsPopover close];
}

#pragma mark - CKTableView Delegate and NSTableView DataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [[CKContactList sharedInstance] count];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 58.0;
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
    contactCell.unreadMessageCount               = contact.unreadCount;

    return contactCell;
}

- (void)tableView:(CKTableView *)tableView didSingleClickRow:(NSInteger)row
{
    // set unread message count to zero
    [[CKContactList sharedInstance] contactWithIndex:row].unreadCount = 0;
    [self.contactListTableView reloadData];
}

- (void)tableView:(CKTableView *)tableView didDoubleClickRow:(NSInteger)row
{
    NSInteger selectedRow = self.contactListTableView.selectedRow;
    id sender = [tableView rowViewAtRow:selectedRow makeIfNecessary:YES];
    
    self.contactPopoverViewController.popoverType = PopoverTypeUpdateContact;
    
    [self.contactPopover showRelativeToRect:[sender bounds]
                                     ofView:sender
                              preferredEdge:NSMaxXEdge];
    
    self.contactPopoverViewController.popoverType = PopoverTypeUpdateContact;
    self.contactPopoverViewController.contact =
        [[CKContactList sharedInstance] contactWithIndex:selectedRow];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger selectedRow = self.contactListTableView.selectedRow;
    
    if (selectedRow < 0) {
        [self.minusButton setEnabled:NO];
    } else {
        [self.minusButton setEnabled:YES];
    }
    
    if (selectedRow == previouslySelectedRow) {
        return;
    }

    CKDebug(@"tableViewSelectionDidChange: %li", self.contactListTableView.selectedRow);

    previouslySelectedRow = selectedRow;
}

- (IBAction)reloadData:(id)sender
{
    CKContactList *contactList = [CKContactList sharedInstance];
    NSUInteger contactCount = contactList.count;
    if (contactCount > 0) {
        CKContact *tmp = [contactList contactWithIndex:arc4random_uniform((unsigned int)contactCount)];
        tmp.unreadCount = arc4random_uniform(contactCount);
    }    
    [self.contactListTableView reloadData];
}

- (void)loadFakeData
{
    CKContact *me = [CKContactList sharedInstance].me;
    
    // fake contact #1
    CKContact *contact = [[CKContact alloc] initWithJabberIdentifier:@"jsmith@gmail.com"
        andDisplayName:@"John Smith" andPhoneNumber:@"1-800-555-1212"
        andContactState:ConnectionStateOnline];
    CKMessage *message1 = [[CKMessage alloc] initWithContact:me timestamp:[NSDate date]
        messageText:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eius"];
    [contact addMessage:message1];
    [[CKContactList sharedInstance] addContact:contact];
    
    // fake contact #2
    CKContact *contact2 = [[CKContact alloc] initWithJabberIdentifier:@"a.vandelay@gmail.com"
        andDisplayName:@"Art Vandelay" andPhoneNumber:@"1-800-555-1111"
        andContactState:ConnectionStateOffline];
    CKMessage *message2 = [[CKMessage alloc] initWithContact:me timestamp:[NSDate date]
        messageText:@"Ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud"];
    [contact2 addMessage:message2];
    [[CKContactList sharedInstance] addContact:contact2];
    
    // fake contact #3
    CKContact *contact3 = [[CKContact alloc] initWithJabberIdentifier:@"bender@gmail.com"
        andDisplayName:@"Bender Rodriguez" andPhoneNumber:@"1-800-555-2222"
        andContactState:ConnectionStateIndeterminate];
    CKMessage *message3 = [[CKMessage alloc] initWithContact:me timestamp:[NSDate date]
        messageText:@"ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute iru"];
    [contact3 addMessage:message3];
    [[CKContactList sharedInstance] addContact:contact3];
    
    [self.contactListTableView reloadData];
}


@end
