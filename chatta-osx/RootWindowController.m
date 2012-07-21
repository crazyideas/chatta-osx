//
//  RootWindowController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "RootWindowController.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ConfigureViewController.h"

@interface RootWindowController (PrivateMethods)
- (void)showConfigureSheet:(NSWindow *)window;
- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)ctxInfo;
@end



@implementation RootWindowController

@synthesize splitView               = _splitView;
@synthesize configureSheet          = _configureSheet;
@synthesize configureSheetView      = _configureSheetView;
@synthesize masterViewController    = _masterViewController;
@synthesize detailViewController    = _detailViewController;
@synthesize configureViewController = _configureViewController;


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window 
    // controller's window has been loaded from its nib file.
    
    self.splitView.subviews = [NSArray arrayWithObjects:
        self.masterViewController.view, self.detailViewController.view, nil];
        
    self.configureViewController = [[ConfigureViewController alloc] 
        initWithNibName:@"ConfigureViewController" bundle:nil];
    self.configureViewController.delegate = self;
    
    [self showConfigureSheet:self.window];
}

-   (CGFloat)splitView:(NSSplitView *)splitView 
constrainMinCoordinate:(CGFloat)proposedMinimumPosition 
           ofSubviewAt:(NSInteger)dividerIndex
{
    if (dividerIndex == 0) {
        return 140;
    }
    return proposedMinimumPosition;
}

#pragma mark - ConfigureViewController Delegates

- (void)loginPushedUsername:(NSString *)username password:(NSString *)password
{
    [self.configureViewController performSelector:@selector(configurationComplete:) withObject:self afterDelay:2];
}

- (void)configurationSheetDidComplete
{
    [NSApp endSheet:self.configureSheet];
    
    [self.splitView setPosition:140 ofDividerAtIndex:0];
    [self.splitView adjustSubviews];
    
    CGFloat sizeX = 850;
    CGFloat sizeY = 650;
    CGFloat originX = ((NSScreen.mainScreen.frame.size.width)  / 2) - (sizeX / 2);
    CGFloat originY = ((NSScreen.mainScreen.frame.size.height) / 2) - (sizeY / 2) + 55;

    NSRect windowFrame = NSMakeRect(originX, originY, sizeX, sizeY);
    [self.window setFrame:windowFrame display:YES animate:YES];
}

#pragma mark - Sheet Methods

- (void)showConfigureSheet:(NSWindow *)window
{
    [self.configureSheetView addSubview:self.configureViewController.view];
    
    [NSApp beginSheet:self.configureSheet 
       modalForWindow:self.window 
        modalDelegate:self 
       didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
          contextInfo:nil];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)ctxInfo
{
    [self.configureSheet orderOut:self];
}

@end
