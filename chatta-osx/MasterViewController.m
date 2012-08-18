//
//  MasterViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "MasterViewController.h"
#import "CKTableViewCellStyleDetailed.h"
#import "CKTableRowView.h"
#import "CKContactList.h"
#import "CKContact.h"
#import "CKMessage.h"
#import "CKTableView.h"
#import "CKRoster.h"
#import "CKRosterItem.h"
#import "SettingsPopoverViewController.h"
#import "DetailViewController.h"
#import "ContactPopoverViewController.h"
#import "ChattaKit.h"


@implementation MasterViewController

@synthesize delegate                      = _delegate;
@synthesize refreshButton                 = _refreshButton;
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
@synthesize chattaKit                     = _chattaKit;

- (void)setConnectionState:(ChattaState)connectionState
{
    self.settingsPopoverViewController.connectionState = connectionState;
    self.detailViewController.enabled = (connectionState == ChattaStateConnected) ? YES : NO;
    
    _connectionState = connectionState;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contactPopoverViewController = [[ContactPopoverViewController alloc] 
            initWithNibName:@"ContactPopoverViewController" bundle:nil];
        
        self.settingsPopoverViewController = [[SettingsPopoverViewController alloc]
            initWithNibName:@"SettingsPopoverViewController" bundle:nil];
        
        self.contactPopover  = [[NSPopover alloc] init];
        self.settingsPopover = [[NSPopover alloc] init];
    }
    
    return self;
}

- (void) awakeFromNib
{
    self.detailViewController.contact = nil;
    self.detailViewController.enabled =
        (self.chattaKit.chattaState == ChattaStateConnected) ? YES : NO;
    self.detailViewController.delegate = self;

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
    
    self.contactPopoverViewController.chattaKit = self.chattaKit;
    
    [CKContactList sharedInstance].delegate = self;
    
    [self.minusButton setEnabled:NO];
    self.connectionState = ChattaStateDisconnected;
    previouslySelectedRow = -1;
    
    // for debugging
    [self.refreshButton setHidden:YES];
}

- (void)updateUnreadCount
{
    // sum up unread messages
    NSUInteger unreadMessages = 0;
    NSArray *allContacts = [CKContactList sharedInstance].allContacts;
    for (CKContact *contact in allContacts) {
        unreadMessages += contact.unreadCount;
    }
    
    // update unreadTextField
    self.unreadTextField.stringValue = (unreadMessages == 0) ? @"" :
    [NSString stringWithFormat:@"Unread (%li)", unreadMessages];
}

- (void)clearLogsForSelectedContact
{
    NSInteger selectedRow = self.contactListTableView.selectedRow;
    if (selectedRow < 0) {
        return;
    }
    
    CKContact *selectedContact = [[CKContactList sharedInstance] contactWithIndex:selectedRow];
    [selectedContact removeAllMessages];
    
    self.detailViewController.contact = selectedContact;
    [self.contactListTableView reloadData];
    
    CKDebug(@"[+] cleared logs for contact: %@", selectedContact);
}

- (void)playNewMessageSound
{
    NSString *soundPath = @"/System/Library/Components/CoreAudio.component/Contents/"
                           "SharedSupport/SystemSounds/system/burn complete.aif";
    NSSound *sound = [[NSSound alloc] initWithContentsOfFile:soundPath byReference:YES];
    if (sound == nil) {
        soundPath = [[NSBundle mainBundle] pathForResource:@"chatta_new_message" ofType:@"wav"];
        sound = [[NSSound alloc] initWithContentsOfFile:soundPath byReference:YES];
    }
    
    if (sound != nil && sound.isPlaying == NO) {
        [sound play];
    }
}

#pragma mark - DetailViewController Delegate

- (void)sendNewMessage:(NSString *)message toContact:(CKContact *)contact
{
    CKDebug(@"[+] sending message: %@, to contact: %@", message, contact);
    if (self.chattaKit != nil) {
        [self.chattaKit sendMessage:message toContact:contact];
    }
}

- (void)makeTextFieldFirstResponder
{
    if (self.delegate != nil) {
        [self.delegate makeTextFieldFirstResponder];
    }
}

#pragma mark - CKContactList Delegates

- (void)addedContact:(CKContact *)contact
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.contactListTableView reloadData];
    });
}

- (void)removedContact:(CKContact *)contact
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.contactListTableView reloadData];
    });
}

- (void)newMessage:(CKMessage *)message forContact:(CKContact *)contact
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        __block MasterViewController *block_self = self;
        NSInteger selectedRow = block_self.contactListTableView.selectedRow;
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
            
            [block_self playNewMessageSound];
        }
        
        // if new message is for selected contact, update detailViewController
        if ([selectedContact isEqualToContact:contact]) {
            [block_self.detailViewController updateTextViewWithNewMessage:message];
        }
        
        [block_self updateUnreadCount];
        [block_self.contactListTableView reloadData];
    });
}

- (void)contactConnectionStateUpdated:(ContactState)state forContact:(CKContact *)contact
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.contactListTableView reloadData];
    });
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
        andDisplayName:name andPhoneNumber:number andContactState:ContactStateIndeterminate];
    [[CKContactList sharedInstance] addContact:contact];
    
    if (self.chattaKit.chattaState == ChattaStateConnected) {
        [self.chattaKit requestContactStatus:contact];
    }
    
    [self.contactListTableView reloadData];
}

- (void)updateContact:(CKContact *)contact withName:(NSString *)name email:(NSString *)address
                phone:(NSString *)number
{
    contact.displayName      = name;
    contact.jabberIdentifier = address;
    contact.phoneNumber      = number;
    
    [self.chattaKit requestContactStatus:contact];
    
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
    CKTableViewCellStyleDetailed *contactCell = [tableView makeViewWithIdentifier:@"contactCell" owner:self];
    if (contactCell == nil) {
        NSRect cellFrame = [tableView frameOfCellAtColumn:0 row:row];
        contactCell = [[CKTableViewCellStyleDetailed alloc] initWithFrame:cellFrame];
        contactCell.identifier = @"contactCell";
    }
    
    CKContact *contact = [[CKContactList sharedInstance] contactWithIndex:row];
    if (contact == nil) {        
        return nil;
    }
    
    // update contact for cell
    contactCell.contact = contact;

    return contactCell;
}

- (void)tableView:(CKTableView *)tableView didSingleClickRow:(NSInteger)row
{
    CKContact *selectedContact = [[CKContactList sharedInstance] contactWithIndex:row];
    
    // update unread count
    selectedContact.unreadCount = 0;
    [self updateUnreadCount];
    [self.contactListTableView reloadData];
    
    // make textfield first responder
    if (self.delegate != nil) {
        [self.delegate makeTextFieldFirstResponder];
    }
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

    // update selected contact
    CKContact *selectedContact = [[CKContactList sharedInstance] contactWithIndex:selectedRow];
    self.detailViewController.contact = (selectedRow < 0) ? nil : selectedContact;
    self.detailViewController.enabled =
        (self.chattaKit.chattaState == ChattaStateConnected) ? YES : NO;
    CKDebug(@"[+] tableViewSelectionDidChange: %li", self.contactListTableView.selectedRow);
    
    previouslySelectedRow = selectedRow;
}

- (IBAction)reloadData:(id)sender
{
    /*
    CKContactList *contactList = [CKContactList sharedInstance];
    NSUInteger contactCount = contactList.count;
    if (contactCount > 0) {
        CKContact *tmp = [contactList contactWithIndex:arc4random_uniform((unsigned int)contactCount)];
        tmp.unreadCount = arc4random_uniform(contactCount);
    }
    */
    //[self loadFakeData];
    //[self.contactListTableView reloadData];
}

- (void)loadFakeData
{
    CKContact *me = [CKContactList sharedInstance].me;
    me.displayName = @"Me";
    
    // fake contact #1
    CKContact *contact = [[CKContact alloc] initWithJabberIdentifier:@"jsmith@gmail.com"
        andDisplayName:@"John Smith" andPhoneNumber:@"+18005551212"
        andContactState:ContactStateOnline];
    CKMessage *message1 = [[CKMessage alloc] initWithContact:contact timestamp:[NSDate date]
        messageText:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eius"];
    [contact addMessage:message1];
    [[CKContactList sharedInstance] addContact:contact];
    
    // fake contact #2
    CKContact *contact2 = [[CKContact alloc] initWithJabberIdentifier:@"a.vandelay@gmail.com"
        andDisplayName:@"Art Vandelay" andPhoneNumber:@"+18005551111"
        andContactState:ContactStateOffline];
    CKMessage *message2 = [[CKMessage alloc] initWithContact:me timestamp:[NSDate date]
        messageText:@"Ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud"];
    [contact2 addMessage:message2];
    [[CKContactList sharedInstance] addContact:contact2];
    
    // fake contact #3
    CKContact *contact3 = [[CKContact alloc] initWithJabberIdentifier:@"bender@gmail.com"
        andDisplayName:@"Bender Rodriguez" andPhoneNumber:@"+18005552222"
        andContactState:ContactStateIndeterminate];
    CKMessage *message3 = [[CKMessage alloc] initWithContact:me timestamp:[NSDate date]
        messageText:@"ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute iru"];
    [contact3 addMessage:message3];
    [[CKContactList sharedInstance] addContact:contact3];
    
    [self.contactListTableView reloadData];
}


@end
