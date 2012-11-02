//
//  ConfigureView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "ConfigureView.h"

#import "NSColor+CKAdditions.h"
#import "NSFont+CKAdditions.h"
#import "CKProgressIndicator.h"

@implementation ConfigureView

#define errorText @"Unable to log in, probably due to one of the below reasons:\n\n" \
                   "\t\u2022 Invalid username/password combination\n"                  \
                   "\t\u2022 No Google Voice or Google Talk account\n"                 \
                   "\t\u2022 Tried the wrong password too many times"

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel        = [[CKLabel alloc] initWithFrame:NSMakeRect(           162, 145, 120, 80)];
        self.usernameLabel     = [[CKLabel alloc] initWithFrame:NSMakeRect(            46, 108,  96, 17)];
        self.passwordLabel     = [[CKLabel alloc] initWithFrame:NSMakeRect(            78,  76,  64, 17)];
        self.usernameTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(       147, 105, 255, 22)];
        self.passwordTextField = [[NSSecureTextField alloc] initWithFrame:NSMakeRect( 147,  73, 255, 22)];
        self.leftButton        = [[NSButton alloc] initWithFrame:NSMakeRect(           43,  15, 100, 32)];
        self.rightButton       = [[NSButton alloc] initWithFrame:NSMakeRect(          308,  15, 100, 32)];
        
        [self.titleLabel setAttributedStringValue:[self etchedString:@"chatta" withFont:[NSFont applicationLogo]]];
        [self.titleLabel setTextColor:[NSColor logoColor]];
        [self.titleLabel setAutoresizingMask:NSViewMinYMargin];

        [self.usernameLabel setAttributedStringValue:[self etchedString:@"Gmail Address"
            withFont:[NSFont systemFontOfSize:0]]];
        [self.usernameLabel setAutoresizingMask:NSViewMinYMargin];

        [self.passwordLabel setAttributedStringValue:[self etchedString:@"Password"
            withFont:[NSFont systemFontOfSize:0]]];
        [self.passwordLabel setAutoresizingMask:NSViewMinYMargin];

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
        [self.usernameTextField setAutoresizingMask:NSViewMinYMargin];

        [self.passwordTextField.cell setPlaceholderString:@"supersecretpassword"];
        [self.passwordTextField setAutoresizingMask:NSViewMinYMargin];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.usernameLabel];
        [self addSubview:self.passwordLabel];
        [self addSubview:self.usernameTextField];
        [self addSubview:self.passwordTextField];        
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
    }
    
    return self;
}


- (void)changeViewState:(ConfigureViewState)newConfigureState
{
    NSRect newWindowFrame;
    
    NSRect normalFrame   = normalRectFrame;
    NSRect progressFrame = progressRectFrame;
    NSRect errorFrame    = errorRectFrame;
    
    // if we have a progress or error indicator, remove it
    if (self.progressOrErrorView != nil) {
        [self.progressOrErrorView removeFromSuperview];
    }
    
    switch (newConfigureState) {
        case ConfigureViewStateNormal:
        {
            newWindowFrame = CKCopyRect(normalFrame);
            break;
        }
        case ConfigureViewStateProgress:
        {
            self.progressOrErrorView = [[CKProgressIndicator alloc] initWithFrame:NSMakeRect(49, 62, 355, 20)];
            [(CKProgressIndicator *)self.progressOrErrorView setUsesThreadedAnimation:YES];
            [(CKProgressIndicator *)self.progressOrErrorView startAnimation:self];
            [self addSubview:self.progressOrErrorView];
            
            newWindowFrame = CKCopyRect(progressFrame);
            break;
        }
        case ConfigureViewStateError:
        {
            self.progressOrErrorView = [[CKLabel alloc] initWithFrame:NSMakeRect(38, 52, 400, 100)];
            [(CKLabel *)self.progressOrErrorView setAttributedStringValue:[self etchedString:errorText withFont:[NSFont systemFontOfSize:0]]];
            [(CKLabel *)self.progressOrErrorView setTextColor:[NSColor redColor]];
            [self addSubview:self.progressOrErrorView];
            
            newWindowFrame = CKCopyRect(errorFrame);
            break;
        }
        default:
        {
            break;
        }
    }
    
    [self.window setFrame:newWindowFrame display:YES animate:YES];
}

- (NSAttributedString *)etchedString:(NSString *)string withFont:(NSFont *)font
{
    // font for logo
    //NSFont *font = [NSFont applicationLogo];
    
    // attributed string with white etched shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor whiteColor]];
    [shadow setShadowOffset:NSMakeSize(-0.0, -2.0)];
    
    // center text
    //NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //[paragraphStyle setAlignment:NSCenterTextAlignment];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       font,           NSFontAttributeName,
                                       //color,          NSForegroundColorAttributeName,
                                       shadow,         NSShadowAttributeName,
                                       //paragraphStyle, NSParagraphStyleAttributeName,
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
        [self.delegate leftButtonAction:sender];
    }
}

- (void)rightButtonPressed:(id)sender
{
    if (self.delegate != nil) {
        [self.delegate rightButtonAction:sender];
    }
}

@end
