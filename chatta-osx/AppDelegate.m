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

    // alloc/init master and detail view controllers
    if (self.rootWindowController == nil) {
        self.rootWindowController = 
            [[RootWindowController alloc] initWithWindowNibName:@"RootWindow"];
        
        self.rootWindowController.masterViewController = 
            [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
        self.rootWindowController.detailViewController =
            [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    }
    
    // don't persist window location
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ApplePersistenceIgnoreState"];
    [self.rootWindowController.window center];
    
    // register for sleep/wake notifications
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self 
        selector:@selector(receivedSleepNotification:) name:NSWorkspaceWillSleepNotification object:nil];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self 
        selector:@selector(receivedWakeNotification:) name:NSWorkspaceDidWakeNotification object:nil];
    
    // show root window
    [self.rootWindowController showWindow:self];
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

- (IBAction)toggleDebugPanelAction:(id)sender
{
    self.rootWindowController.debugPanel.isVisible =
        !self.rootWindowController.debugPanel.isVisible;
}

- (IBAction)clearLogsAction:(id)sender
{
    [self.rootWindowController.masterViewController clearLogsForSelectedContact];
}

- (IBAction)reimportContactsAction:(id)sender
{
    CKDebug(@"[+] deleting and re-importing all contacts");
    [self.rootWindowController deleteAndReimportContacts:self];
}

@end
