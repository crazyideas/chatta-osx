//
//  ConfigureViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EmailAddressFormatter.h"

@protocol ConfigureViewDelegate <NSObject>
@optional
- (void)loginPushedUsername:(NSString *)username password:(NSString *)password;
- (void)configurationSheetDidComplete;
@end

@interface ConfigureViewController : NSViewController <NSTextFieldDelegate>

@property (nonatomic, assign) id <ConfigureViewDelegate> delegate;
@property (nonatomic, strong) EmailAddressFormatter *emailAddressFormatter;

@property (weak) IBOutlet NSTextFieldCell *chattaTextField;
@property (weak) IBOutlet NSTextField *usernameTextField;
@property (weak) IBOutlet NSSecureTextField *passwordTextField;
@property (weak) IBOutlet NSProgressIndicator *loginProgressIndicator;
@property (weak) IBOutlet NSButton *firstPreviousButton;
@property (weak) IBOutlet NSButton *firstNextButton;

- (void)showLoginView;
- (void)showContactImportView;

- (void)configureSheetWillOpen;
- (void)configureSheetWillClose;
- (void)validateFieldsAndUpdateButtons;

- (IBAction)firstNextPushed:(id)sender;
- (IBAction)firstCancelPushed:(id)sender;
- (IBAction)importBackPushed:(id)sender;
- (IBAction)importContinuePushed:(id)sender;

@end
