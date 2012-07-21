//
//  MasterViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DetailViewController.h"
#import "ContactPopoverViewController.h"
#import "SettingsPopoverViewController.h"

@interface MasterViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource, 
                                                    ContactPopoverDelegate, SettingsPopoverDelegate>

@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) ContactPopoverViewController *contactPopoverViewController;
@property (nonatomic, strong) SettingsPopoverViewController *settingsPopoverViewController;
@property (nonatomic, strong) NSPopover *contactPopover;
@property (nonatomic, strong) NSPopover *settingsPopover;

@property (weak) IBOutlet NSTableView *contactListTableView;
@property (weak) IBOutlet NSTextField *unreadTextField;

- (IBAction)addContactPushed:(id)sender;
- (IBAction)settingsPushed:(id)sender;
- (IBAction)removeContactPushed:(id)sender;



// tmp
@property (nonatomic, strong) NSArray *contactList;
- (IBAction)reloadData:(id)sender;

@end
