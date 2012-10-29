//
//  MasterViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CKContactList.h"
#import "CKTableView.h"
#import "DetailViewController.h"

@protocol ContactPopoverDelegate;
@protocol SettingsPopoverDelegate;
@protocol CKContactListDelegate;
@protocol DetailViewControllerDelegate;
@protocol CKTableViewDelegate;

@class ChattaKit;
@class DetailViewController;
@class PopoverViewController;
@class CKTableView;
@class CKScrollView;

@protocol MasterViewDelegate <NSObject>
@optional
- (void)logoutOfChatta;
- (void)loginToChatta;
@end

@interface MasterViewController : NSViewController <CKTableViewDelegate, NSTableViewDataSource,
                                                    NSPopoverDelegate, CKContactListDelegate,
                                                    DetailViewControllerDelegate>

@property (nonatomic, strong) CKScrollView *scrollView;
@property (nonatomic, strong) CKTableView *tableView;
@property (nonatomic, strong) NSTableColumn *tableColumn;
@property (nonatomic, strong) NSBox *lineSeparator;
@property (nonatomic, strong) NSButton *addContactButton;

@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) PopoverViewController *popoverViewController;
@property (nonatomic, strong) NSPopover *popover;

@property (nonatomic, assign) id <MasterViewDelegate> delegate;
@property (nonatomic, strong) ChattaKit *chattaKit;
@property (nonatomic) ChattaState connectionState;
@property (nonatomic) NSInteger previouslySelectedRow;
@property (nonatomic) BOOL isVisible;


@end
