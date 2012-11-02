//
//  ConfigureView.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CKLabel.h"

@protocol ConfigureViewDelegate <NSObject>
@optional
- (void)leftButtonAction:(id)sender;
- (void)rightButtonAction:(id)sender;
@end

@interface ConfigureView : NSView

typedef enum {
    ConfigureViewStateNormal,
    ConfigureViewStateProgress,
    ConfigureViewStateError
} ConfigureViewState;

@property (nonatomic, strong) CKLabel *titleLabel;
@property (nonatomic, strong) CKLabel *usernameLabel;
@property (nonatomic, strong) CKLabel *passwordLabel;

@property (nonatomic, strong) NSTextField *usernameTextField;
@property (nonatomic, strong) NSSecureTextField *passwordTextField;
@property (nonatomic, strong) NSView *progressOrErrorView;

@property (nonatomic, strong) NSButton *leftButton;
@property (nonatomic, strong) NSButton *rightButton;

@property (nonatomic, assign) id <ConfigureViewDelegate> delegate;

- (void)changeViewState:(ConfigureViewState)newConfigureState;

@end
