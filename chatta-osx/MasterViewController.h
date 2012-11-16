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
#import "ContactViewController.h"
#import "MessageViewController.h"

@protocol PopoverDelegate;
@protocol ContactPopoverDelegate;
@protocol SettingsPopoverDelegate;
@protocol CKContactListDelegate;
@protocol CKTableViewDelegate;

@class ChattaKit;
@class DetailViewController;
@class ContactViewController;
@class MasterView;

@protocol MasterViewDelegate <NSObject>
@optional
- (void)selectedContactDidChange:(CKContact *)contact;
@end

@interface MasterViewController : NSViewController <NSTableViewDataSource,
                                                    CKTableViewDelegate,
                                                    CKContactListDelegate,
                                                    ContactViewControllerDelegate,
                                                    MessageViewControllerDelegate>

@property (nonatomic, strong) MasterView *masterView;
@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) ContactViewController *contactViewController;
@property (nonatomic, strong) MessageViewController *messageViewController;

@property (nonatomic, assign) id <MasterViewDelegate> delegate;
@property (nonatomic, strong) ChattaKit *chattaKit;
@property (nonatomic) ChattaState connectionState;
@property (nonatomic) NSInteger previouslySelectedRow;
@property (nonatomic) BOOL isVisible;

- (id)initWithFrame:(NSRect)frame;

- (void)updateSelectedContact:(id)sender;
- (void)removeSelectedContact:(id)sender;

@end
