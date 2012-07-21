//
//  ConfigureViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ConfigureViewControllerDelegate <NSObject>
@optional
- (void)loginPushedUsername:(NSString *)username password:(NSString *)password;
- (void)configurationSheetDidComplete;
@end

@interface ConfigureViewController : NSViewController

@property (nonatomic, assign) id <ConfigureViewControllerDelegate> delegate;

@property (weak) IBOutlet NSButton *firstPreviousPressed;
@property (weak) IBOutlet NSTextFieldCell *chattaTextField;
@property (weak) IBOutlet NSProgressIndicator *loginProgressIndicator;

- (void)showLoginView;
- (void)showContactImportView;

- (IBAction)firstNextPushed:(id)sender;
- (IBAction)configurationComplete:(id)sender;
- (IBAction)importBackPushed:(id)sender;
- (IBAction)importContinuePushed:(id)sender;

@end
