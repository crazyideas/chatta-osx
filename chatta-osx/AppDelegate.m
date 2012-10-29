//
//  AppDelegate.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CKPersistence.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    CKDebug(@"[+] applicationDidFinishLaunching");
    
    // register for sleep/wake notifications
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self 
        selector:@selector(receivedSleepNotification:) name:NSWorkspaceWillSleepNotification object:nil];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self 
        selector:@selector(receivedWakeNotification:) name:NSWorkspaceDidWakeNotification object:nil];
    
    // create window mask
    NSUInteger windowStyleMask = NSClosableWindowMask | NSMiniaturizableWindowMask |
    NSTitledWindowMask | NSResizableWindowMask | NSTitledWindowMask;
    
    // adjust window location
    NSScreen *mainScreen = [NSScreen mainScreen];
    CGFloat sizeX = mainScreen.frame.size.width  * 0.5; // ~850;
    CGFloat sizeY = mainScreen.frame.size.height * 0.6; // ~650;
    CGFloat originX = ((mainScreen.frame.size.width)  / 2) - (sizeX / 2);
    CGFloat originY = ((mainScreen.frame.size.height) / 2) - (sizeY / 2) + 25;
    
    // create window
    NSRect windowFrame = NSMakeRect(originX, originY, sizeX, sizeY);
    self.window = [[NSWindow alloc] initWithContentRect:windowFrame
        styleMask:windowStyleMask backing:NSBackingStoreBuffered defer:NO];
    self.window.title = @"chatta";
    
    // create and set window controller
    self.rootWindowController = [[RootWindowController alloc] initWithWindow:self.window];
    self.window.windowController = self.rootWindowController;
    
    // order front
    [self.window makeKeyAndOrderFront:self];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    CKDebug(@"[+] applicationShouldHandleReopen: %@", sender);
    
    // if window closed, and click dock icon, bring window back to front
    [self.rootWindowController.window makeKeyAndOrderFront:self];
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    CKDebug(@"[+] applicationWillTerminate: %@", notification);

    [CKPersistence saveContactsToPersistentStorage];
}

#pragma mark - Sleep/Wake Notifications

- (void)receivedSleepNotification:(NSNotification *)notification
{
    CKDebug(@"[+] receivedSleepNotification: %@", [notification name]);
    
    // send root controller sleep notification, logout user
    [self.rootWindowController receivedSleepNotification:notification];
}

- (void)receivedWakeNotification:(NSNotification *)notification
{
    CKDebug(@"[+] receivedWakeNotification: %@", notification.name);
    
    // send root controller wake notification, login user
    [self.rootWindowController receivedWakeNotification:notification];
}

#pragma mark - Actions

- (IBAction)accountPressedAction:(id)sender
{
    [self.rootWindowController receivedAccountPressedNotification:sender];
}

@end
