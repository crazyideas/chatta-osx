//
//  AppDelegate.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RootWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

//@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) RootWindowController *rootWindowController;

- (IBAction)toggleDebugPanelAction:(id)sender;
- (IBAction)clearLogsAction:(id)sender;
- (IBAction)reimportContactsAction:(id)sender;

@end
