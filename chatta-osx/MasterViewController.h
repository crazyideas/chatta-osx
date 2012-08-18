//
//  MasterViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CKTableView.h"
#import "ContactPopoverViewController.h"
#import "SettingsPopoverViewController.h"
#import "CKContactList.h"
#import "DetailViewController.h"

@protocol ContactPopoverDelegate;
@protocol SettingsPopoverDelegate;
@protocol CKContactListDelegate;
@protocol DetailViewDelegate;
@protocol CKTableViewDelegate;

@class DetailViewController;
@class ChattaKit;


@protocol MasterViewDelegate <NSObject>
@optional
- (void)logoutOfChatta;
- (void)loginToChatta;
- (void)makeTextFieldFirstResponder;
@end

@interface MasterViewController : NSViewController <CKTableViewDelegate, NSTableViewDataSource,
                                                    ContactPopoverDelegate, SettingsPopoverDelegate,
                                                    CKContactListDelegate, DetailViewDelegate>
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
@property (weak) IBOutlet NSButton *refreshButton;
@property (nonatomic) BOOL isVisible;

@property (weak) IBOutlet CKTableView *contactListTableView;
@property (weak) IBOutlet NSTextField *unreadTextField;

@property (nonatomic, assign) id <MasterViewDelegate> delegate;
@property (nonatomic, strong) ChattaKit *chattaKit;
@property (nonatomic) ChattaState connectionState;

- (IBAction)addContactPushed:(id)sender;
- (IBAction)settingsPushed:(id)sender;
- (IBAction)removeContactPushed:(id)sender;

- (void)clearLogsForSelectedContact;

// tmp
- (IBAction)reloadData:(id)sender;
- (void)loadFakeData;

@end
