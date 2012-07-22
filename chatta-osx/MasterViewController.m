//
//  MasterViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "MasterViewController.h"
#import "ContactCellView.h"

@implementation MasterViewController

@synthesize delegate                      = _delegate;
@synthesize contactListTableView          = _contactListTableView;
@synthesize unreadTextField               = _unreadTextField;
@synthesize detailViewController          = _detailViewController;
@synthesize contactList                   = _contactList;
@synthesize contactPopoverViewController  = _contactPopoverViewController;
@synthesize settingsPopoverViewController = _settingsPopoverViewController;
@synthesize settingsPopover               = _settingsPopover;
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
        // Initialization code here.
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
    
    self.contactPopover.contentViewController = self.contactPopoverViewController;
    self.contactPopover.behavior = NSPopoverBehaviorTransient;
    self.contactPopover.delegate = self.contactPopoverViewController;
    
    self.settingsPopover.contentViewController = self.settingsPopoverViewController;
    self.settingsPopover.behavior = NSPopoverBehaviorTransient;
    self.settingsPopover.delegate = self.settingsPopoverViewController;
    
    self.settingsPopoverViewController.delegate = self;
    self.contactPopoverViewController.delegate  = self;
    
    self.connectionState = ChattaStateDisconnected;
    currentlySelectedRow = -1;
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
    NSLog(@"removeContactPushed");
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
    NSLog(@"addContactWithName: %@", name);
}

- (void)updateContact:(id)contact withName:(NSString *)name email:(NSString *)address phone:(NSString *)number
{
    NSLog(@"updateContact: %@", name);
}

- (void)closePopover
{
    [self.contactPopover close];
    [self.settingsPopover close];
}

#pragma mark - NSTableView Delegate and NSTableView DataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (self.contactList == nil) {
        self.contactList = [NSArray arrayWithObjects:@"0", @"1", @"2", nil];
    }
    return [self.contactList count];
}

- (NSView *)tableView:(NSTableView *)tableView 
   viewForTableColumn:(NSTableColumn *)tableColumn 
                  row:(NSInteger)row
{
    ContactCellView *contactCellView = [tableView makeViewWithIdentifier:@"contactCell" owner:self];
    
    contactCellView.displayName.stringValue = @"John Smith";
    contactCellView.lastMessageTimestamp.stringValue = (row == 0) ? @"12:22 AM" : @"12/12/12";
    contactCellView.connectionState = arc4random_uniform(3);
    
    NSString *randStr;
    switch (contactCellView.connectionState) {
        case 0:
        {
            randStr = [NSString stringWithString:@"current state is indeterminate"];
            break;
        }
        case 1:
        {
            randStr = [NSString stringWithString:@"current state is offline"];
            break;
        }
        case 2:
        {
            randStr = [NSString stringWithString:@"current state is online"];
            break;
        }
        default:
        {
            break;
        }
    }
    contactCellView.lastMessage.stringValue = randStr;
    
    
    return contactCellView;
}

- (void)tableViewSingleClick:(id)sender
{
    currentlySelectedRow = [sender clickedRow];
    if (currentlySelectedRow < 0) {
        [self.contactListTableView deselectAll:self];
    }
}

- (IBAction)reloadData:(id)sender
{
    [self.contactListTableView reloadData];
    
    NSIndexSet *selectedIndexSet = [NSIndexSet indexSetWithIndex:currentlySelectedRow];
    [self.contactListTableView selectRowIndexes:selectedIndexSet byExtendingSelection:NO];
}


@end
