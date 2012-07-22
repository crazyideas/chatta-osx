//
//  RootWindowController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "RootWindowController.h"
#import "CKContact.h"

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
@synthesize chattaKit               = _chattaKit;
@synthesize username                = _username;
@synthesize password                = _password;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        CKContact *me = [[CKContact alloc] initWithJabberIdentifier:nil andDisplayName:@"Me" andPhoneNumber:nil];
        self.chattaKit = [[ChattaKit alloc] initWithMe:me];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
        
    self.splitView.subviews = [NSArray arrayWithObjects:
        self.masterViewController.view, self.detailViewController.view, nil];
        
    self.configureViewController = [[ConfigureViewController alloc] 
        initWithNibName:@"ConfigureViewController" bundle:nil];
    self.configureViewController.delegate = self;
    
    self.masterViewController.connectionState = ChattaStateDisconnected;
    self.masterViewController.delegate = self;
    
    self.chattaKit.delegate = self;
    
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
    self.username = username;
    self.password = password;
    
    [self.chattaKit loginToServiceWith:self.username andPassword:self.password];
}

- (void)configurationSheetDidComplete
{
    [NSApp endSheet:self.configureSheet];
    
    // if the user has resized the window already, don't resize it again
    if (self.window.frame.size.width > 480 && self.window.frame.size.height > 270) {
        return;
    }
    
    [self.splitView setPosition:140 ofDividerAtIndex:0];
    [self.splitView adjustSubviews];
    
    CGFloat sizeX = 850;
    CGFloat sizeY = 650;
    CGFloat originX = ((NSScreen.mainScreen.frame.size.width)  / 2) - (sizeX / 2);
    CGFloat originY = ((NSScreen.mainScreen.frame.size.height) / 2) - (sizeY / 2) + 55;

    NSRect windowFrame = NSMakeRect(originX, originY, sizeX, sizeY);
    [self.window setFrame:windowFrame display:YES animate:YES];
}

#pragma mark - ChattaKit Delegates

- (void)connectionStateNotification:(ChattaState)state
{
    switch (state) {
        case ChattaStateConnected:
        {
            CKDebug(@"ChattaStateConnected");
            self.masterViewController.connectionState = state;
            dispatch_async(dispatch_get_main_queue(), ^(void){ 
                [self configurationSheetDidComplete];
            });
            break;
        }
        case ChattaStateDisconnected:
        {
            CKDebug(@"ChattaStateDisconnected");
            self.masterViewController.connectionState = state;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (self.configureSheet.isVisible == NO) {  
                    [self showConfigureSheet:self.window];
                }
            });
            break;
        }
        default:
        {
            CKDebug(@"connectionStateNotification: invalid state");
            break;
        }
    }
}

#pragma mark - MasterViewController Delegates

- (void)loginToChatta
{
    [self showConfigureSheet:self.window];
}

- (void)logoutOfChatta
{
    [self.chattaKit logoutOfService];
}

#pragma mark - Sheet Methods

- (void)showConfigureSheet:(NSWindow *)window
{
    [self.configureViewController configureSheetWillOpen];
    [self.configureSheetView addSubview:self.configureViewController.view];
    
    [NSApp beginSheet:self.configureSheet 
       modalForWindow:self.window 
        modalDelegate:self 
       didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
          contextInfo:nil];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)ctxInfo
{
    [self.configureViewController configureSheetWillClose];
    [self.configureSheet orderOut:self];
}

@end
