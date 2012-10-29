//
//  ConfigureView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "ConfigureView.h"

#import "NSColor+CKAdditions.h"
#import "NSFont+CKAdditions.h"

@implementation ConfigureView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel        = [[CKLabel alloc] initWithFrame:NSMakeRect(23, 195, 434, 73)];
        self.usernameLabel     = [[CKLabel alloc] initWithFrame:NSMakeRect(76, 152, 96, 17)];
        self.passwordLabel     = [[CKLabel alloc] initWithFrame:NSMakeRect(108, 120, 64, 17)];
        
        self.usernameTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(177, 149, 225, 22)];
        self.passwordTextField = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(177, 117, 225, 22)];
        self.progressIndicator = [[CKProgressIndicator alloc] initWithFrame:NSMakeRect(76, 79,  329, 18)];
        
        self.leftButton = [[NSButton alloc] initWithFrame:NSMakeRect(14, 12, 97, 32)];
        self.rightButton = [[NSButton alloc] initWithFrame:NSMakeRect(369, 12, 97, 32)];
        
        self.titleLabel.attributedStringValue = [self etchedString:@"chatta"];
        self.titleLabel.textColor = [NSColor logoColor];
        self.usernameLabel.stringValue = @"Gmail Address";
        self.passwordLabel.stringValue = @"Password";

        [self.leftButton setTitle:@"Cancel"];
        [self.leftButton setBezelStyle:NSRoundedBezelStyle];
        [self.leftButton setAutoresizingMask:NSViewMaxYMargin | NSViewMinXMargin | NSViewMaxXMargin];
        [self.leftButton setTarget:self];
        [self.leftButton setAction:@selector(leftButtonPressed:)];
        
        [self.rightButton setTitle:@"Login"];
        [self.rightButton setBezelStyle:NSRoundedBezelStyle];
        [self.rightButton setAutoresizingMask:NSViewMaxYMargin | NSViewMinXMargin | NSViewMaxXMargin];
        [self.rightButton setTarget:self];
        [self.rightButton setAction:@selector(rightButtonPressed:)];
        
        [self.usernameTextField.cell setPlaceholderString:@"username@gmail.com"];
        [self.passwordTextField.cell setPlaceholderString:@"supersecretpassword"];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.usernameLabel];
        [self addSubview:self.passwordLabel];
        
        [self addSubview:self.usernameTextField];
        [self addSubview:self.passwordTextField];
        [self addSubview:self.progressIndicator];
        
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
    }
    
    return self;
}

- (NSAttributedString *)etchedString:(NSString *)string
{
    // font for logo
    NSFont *font = [NSFont applicationLogo];
    
    // attributed string with white etched shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor whiteColor]];
    [shadow setShadowOffset:NSMakeSize(-0.0, -2.0)];
    
    // center text
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSCenterTextAlignment];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       font,           NSFontAttributeName,
                                       shadow,         NSShadowAttributeName,
                                       paragraphStyle, NSParagraphStyleAttributeName,
                                       nil];
    
    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
}

#pragma mark - Overridden Methods

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor mediumBackgroundNoiseColor] setFill];
    NSRectFill(dirtyRect);
}

#pragma mark - NSButton Delegates

- (void)leftButtonPressed:(id)sender
{
    if (self.delegate != nil) {
        [self.progressIndicator stopAnimation:self];
        
        [self.delegate leftButtonAction:sender];
    }
}

- (void)rightButtonPressed:(id)sender
{
    if (self.delegate != nil) {
        self.progressIndicator.usesThreadedAnimation = YES;
        [self.progressIndicator startAnimation:self];
        
        [self.delegate rightButtonAction:sender];
    }
}

@end
