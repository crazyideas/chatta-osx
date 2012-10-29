//
//  AppDelegate.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RootWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) NSWindow *window;
@property (nonatomic, strong) RootWindowController *rootWindowController;

- (IBAction)accountPressedAction:(id)sender;

@end
