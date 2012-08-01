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
#import "CKTableView.h"
#import "ChattaKit.h"

@protocol MasterViewDelegate <NSObject>
@optional
- (void)logoutOfChatta;
- (void)loginToChatta;
@end

@interface MasterViewController : NSViewController <CKTableViewDelegate, NSTableViewDataSource,
                                                    ContactPopoverDelegate, SettingsPopoverDelegate>
{
    NSInteger previouslySelectedRow;
}

@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) ContactPopoverViewController *contactPopoverViewController;
@property (nonatomic, strong) SettingsPopoverViewController *settingsPopoverViewController;
@property (nonatomic, strong) NSPopover *contactPopover;
@property (nonatomic, strong) NSPopover *settingsPopover;
@property (weak) IBOutlet NSButton *minusButton;
@property (weak) IBOutlet NSButton *plusButton;

@property (weak) IBOutlet CKTableView *contactListTableView;
@property (weak) IBOutlet NSTextField *unreadTextField;

@property (nonatomic, assign) id <MasterViewDelegate> delegate;
@property (nonatomic) ChattaState connectionState;

- (IBAction)addContactPushed:(id)sender;
- (IBAction)settingsPushed:(id)sender;
- (IBAction)removeContactPushed:(id)sender;



// tmp
@property (nonatomic, strong) NSArray *contactList;
- (IBAction)reloadData:(id)sender;

@end
