//
//  RootWindowController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MasterViewController.h"
#import "ConfigureViewController.h"
#import "DetailViewController.h"
#import "ChattaKit.h"
#import "NSString+CKAdditions.h"

@interface RootWindowController : NSWindowController <NSSplitViewDelegate, NSWindowDelegate,
                                                      MasterViewDelegate, ConfigureViewDelegate,
                                                      ChattaKitDelegate>

@property (weak)   IBOutlet NSSplitView *splitView;
@property (weak)   IBOutlet NSView *configureSheetView;
@property (strong) IBOutlet NSPanel *configureSheet;

@property (nonatomic, strong) MasterViewController *masterViewController;
@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) ConfigureViewController *configureViewController;
@property (nonatomic, strong) ChattaKit *chattaKit;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

- (void)receivedSleepNotification:(NSNotification *)notification;
- (void)receivedWakeNotification:(NSNotification *)notification;

// debug panel support
@property (strong) IBOutlet NSPanel *debugPanel;
@property (weak) IBOutlet NSTextField *debugContactNameTextField;
@property (weak) IBOutlet NSTextField *debugContactStateTextField;
- (IBAction)debugSleepNotification:(id)sender;
- (IBAction)debugWakeNotification:(id)sender;
- (IBAction)debugConnectedNotification:(id)sender;
- (IBAction)debugDisconnectedNotification:(id)sender;
- (IBAction)debugconnectionInProgress:(id)sender;
- (IBAction)debugUpdateConnectionState:(id)sender;
- (IBAction)debugNewMessageForContact:(id)sender;

@end
