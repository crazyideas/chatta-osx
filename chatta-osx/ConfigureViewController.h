//
//  ConfigureViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CKEmailAddressFormatter.h"
#import "CKProgressIndicator.h"

@protocol ConfigureViewDelegate <NSObject>
@optional
- (void)loginPushedUsername:(NSString *)username password:(NSString *)password;
- (void)cancelChattaLogin;
- (void)configurationSheetDidComplete;
@end

@interface ConfigureViewController : NSViewController <NSTextFieldDelegate>

@property (nonatomic, assign) id <ConfigureViewDelegate> delegate;
@property (nonatomic, strong) CKEmailAddressFormatter *emailAddressFormatter;

@property (weak) IBOutlet NSTextFieldCell *chattaTextField;
@property (weak) IBOutlet NSTextField *usernameTextField;
@property (weak) IBOutlet NSSecureTextField *passwordTextField;
@property (weak) IBOutlet CKProgressIndicator *loginProgressIndicator;
@property (weak) IBOutlet NSButton *firstCancelButton;
@property (weak) IBOutlet NSButton *firstPreviousButton;
@property (weak) IBOutlet NSButton *firstNextButton;

- (void)showLoginView;
- (void)showContactImportView;

- (void)loginInProgress;
- (void)loginStopped;

- (void)configureSheetWillOpen;
- (void)configureSheetWillClose;
- (void)validateFieldsAndUpdateButtons;

- (IBAction)firstNextPushed:(id)sender;
- (IBAction)firstCancelPushed:(id)sender;
- (IBAction)importBackPushed:(id)sender;
- (IBAction)importContinuePushed:(id)sender;

@end
