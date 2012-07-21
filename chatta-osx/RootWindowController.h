//
//  RootWindowController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ConfigureViewController.h"

@class MasterViewController, DetailViewController, ConfigureViewController;

@interface RootWindowController : NSWindowController <ConfigureViewControllerDelegate, NSSplitViewDelegate>

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *configureSheetView;
@property (strong) IBOutlet NSPanel *configureSheet;

@property (nonatomic, strong) MasterViewController *masterViewController;
@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) ConfigureViewController *configureViewController;

@end
