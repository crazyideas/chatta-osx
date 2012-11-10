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
#import "PopoverViewController.h"

@protocol PopoverDelegate;
@protocol ContactPopoverDelegate;
@protocol SettingsPopoverDelegate;
@protocol CKContactListDelegate;
@protocol CKTableViewDelegate;

@class ChattaKit;
@class DetailViewController;
@class PopoverViewController;
@class MasterView;

@protocol MasterViewDelegate <NSObject>
@optional
- (void)selectedContactDidChange:(CKContact *)contact;
@end

@interface MasterViewController : NSViewController <CKTableViewDelegate, NSTableViewDataSource,
                                                    CKContactListDelegate, PopoverDelegate>

@property (nonatomic, strong) MasterView *masterView;
@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) PopoverViewController *popoverViewController;
@property (nonatomic, strong) NSPopover *popover;

@property (nonatomic, assign) id <MasterViewDelegate> delegate;
@property (nonatomic, strong) ChattaKit *chattaKit;
@property (nonatomic) ChattaState connectionState;
@property (nonatomic) NSInteger previouslySelectedRow;
@property (nonatomic) BOOL isVisible;

- (id)initWithFrame:(NSRect)frame;

- (void)updateSelectedContact:(id)sender;
- (void)removeSelectedContact:(id)sender;

@end
