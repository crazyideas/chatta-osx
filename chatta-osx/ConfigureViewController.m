//
//  ConfigureViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "ConfigureViewController.h"

@implementation ConfigureViewController

@synthesize delegate             = _delegate;
@synthesize chattaTextField      = _chattaTextField;
@synthesize loginProgressIndicator = _loginProgressIndicator;
@synthesize firstPreviousPressed = _firstPreviousPressed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    NSDockTile *tile = [[NSApplication sharedApplication] dockTile];
    tile.badgeLabel = @"1";
    
    self.chattaTextField.font = [NSFont fontWithName:@"Cookie-Regular" size:60];
    self.chattaTextField.textColor = [NSColor colorWithCalibratedRed:90/255.0 green:67/255.0 blue:210/255.0 alpha:1.0];
    
    [self.firstPreviousPressed setEnabled:NO];
}

- (void)transitionViewAnimationWithOffset:(NSInteger)offset
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.22];
    
    NSPoint newViewPoint = NSMakePoint(self.view.frame.origin.x + offset, self.view.frame.origin.y);
    [self.view.animator setFrameOrigin:newViewPoint];
    
    [NSAnimationContext endGrouping];
}

- (void)showLoginView
{
    [self transitionViewAnimationWithOffset:-480];
}

- (void)showContactImportView
{
    [self transitionViewAnimationWithOffset:+480];
}

- (IBAction)firstNextPushed:(id)sender
{
    if (self.delegate != nil) {
        [self.delegate loginPushedUsername:nil password:nil];
    }
    
    self.loginProgressIndicator.usesThreadedAnimation = YES;
    [self.loginProgressIndicator startAnimation:self];
    

}

- (IBAction)configurationComplete:(id)sender
{
    [self.loginProgressIndicator stopAnimation:self];
    
    if (self.delegate != nil) {
        [self.delegate configurationSheetDidComplete];
    }
}

- (IBAction)importBackPushed:(id)sender
{
    [self showContactImportView];
}

- (IBAction)importContinuePushed:(id)sender
{
    if (self.delegate != nil) {
        [self.delegate loginPushedUsername:nil password:nil];
    }
}

@end
