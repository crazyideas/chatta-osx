//
//  RootWindowController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ConfigureWindowController.h"

#import "ChattaKit.h"

@interface RootWindowController : NSWindowController <NSSplitViewDelegate, NSWindowDelegate,
                                                      MasterViewDelegate, DetailViewDelegate,
                                                      ConfigureWindowDelegate, ChattaKitDelegate>

@property (nonatomic, strong) NSSplitView *splitView;
@property (nonatomic, strong) MasterViewController *masterViewController;
@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) ConfigureWindowController *configureWindowController;
@property (nonatomic, strong) ChattaKit *chattaKit;

- (void)receivedSleepNotification:(NSNotification *)notification;
- (void)receivedWakeNotification:(NSNotification *)notification;
- (void)receivedAccountPressedNotification:(id)sender;

@end
