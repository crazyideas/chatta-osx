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

@interface RootWindowController : NSWindowController <NSSplitViewDelegate, MasterViewDelegate,
                                                      ChattaKitDelegate, ConfigureViewDelegate>

@property (weak)   IBOutlet NSSplitView *splitView;
@property (weak)   IBOutlet NSView *configureSheetView;
@property (strong) IBOutlet NSPanel *configureSheet;

@property (nonatomic, strong) MasterViewController *masterViewController;
@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) ConfigureViewController *configureViewController;
@property (nonatomic, strong) ChattaKit *chattaKit;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end
