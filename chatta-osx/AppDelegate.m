//
//  AppDelegate.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "DetailViewController.h"

@implementation AppDelegate

@synthesize window               = _window;
@synthesize rootWindowController = _rootWindowController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if (self.rootWindowController == nil) {
        self.rootWindowController = 
            [[RootWindowController alloc] initWithWindowNibName:@"RootWindow"];
        
        self.rootWindowController.masterViewController = 
            [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
        self.rootWindowController.detailViewController =
            [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ApplePersistenceIgnoreState"];
    [self.rootWindowController.window center];
    
    [self.rootWindowController showWindow:self];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    // if window closed, and click dock icon, bring window back to front
    [self.rootWindowController.window makeKeyAndOrderFront:self];
    return YES;
}

@end
