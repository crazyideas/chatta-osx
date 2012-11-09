//
//  AppDelegate.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RootWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, RootWindowDelegate>

@property (nonatomic, strong) NSWindow *window;
@property (nonatomic, strong) RootWindowController *rootWindowController;

@property (weak) IBOutlet NSMenuItem *contactMenuItem;

- (IBAction)updateContactMenuAction:(id)sender;
- (IBAction)removeContactMenuAction:(id)sender;
- (IBAction)accountPressedAction:(id)sender;

@end
