//
//  PopoverView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "PopoverView.h"

@implementation PopoverView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel     = [[CKLabel alloc] initWithFrame:NSMakeRect     (101, 179, 98,  17)];
        
        self.nameLabel      = [[CKLabel alloc] initWithFrame:NSMakeRect     (48,  129, 67,  17)];
        self.emailLabel     = [[CKLabel alloc] initWithFrame:NSMakeRect     (19,  97,  96,  17)];
        self.phoneLabel     = [[CKLabel alloc] initWithFrame:NSMakeRect     (19,  65,  98,  17)];

        self.nameTextField  = [[NSTextField alloc] initWithFrame:NSMakeRect (120, 124, 180, 22)];
        self.emailTextField = [[NSTextField alloc] initWithFrame:NSMakeRect (120, 94,  180, 22)];
        self.phoneTextField = [[NSTextField alloc] initWithFrame:NSMakeRect (120, 62,  180, 22)];
        
        self.leftButton     = [[NSButton alloc] initWithFrame:NSMakeRect    (24,  13,  136, 32)];
        self.rightButton    = [[NSButton alloc] initWithFrame:NSMakeRect    (160, 13,  136, 32)];

        self.titleLabel.alignment = NSCenterTextAlignment;
        self.nameLabel.alignment  = NSRightTextAlignment;
        self.emailLabel.alignment = NSRightTextAlignment;
        self.phoneLabel.alignment = NSRightTextAlignment;

        [self.titleLabel setStringValue:@"Create Contact"];
        [self.nameLabel setStringValue:@"Full Name"];
        [self.emailLabel setStringValue:@"Email Address"];
        [self.phoneLabel setStringValue:@"Phone Number"];
        
        [self.nameTextField.cell setPlaceholderString:@"John Smith"];
        [self.emailTextField.cell setPlaceholderString:@"jsmith@gmail.com"];
        [self.phoneTextField.cell setPlaceholderString:@"1-800-555-1212"];
        
        [self.leftButton setTitle:@"Left Button"];
        [self.leftButton setBezelStyle:NSRoundedBezelStyle];
        [self.leftButton setAutoresizingMask:NSViewMaxYMargin | NSViewMinXMargin | NSViewMaxXMargin];
        [self.leftButton setTarget:self];
        [self.leftButton setAction:@selector(leftButtonPressed:)];
        
        [self.rightButton setTitle:@"Right Button"];
        [self.rightButton setBezelStyle:NSRoundedBezelStyle];
        [self.rightButton setAutoresizingMask:NSViewMaxYMargin | NSViewMinXMargin | NSViewMaxXMargin];
        [self.rightButton setTarget:self];
        [self.rightButton setAction:@selector(rightButtonPressed:)];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.nameLabel];
        [self addSubview:self.emailLabel];
        [self addSubview:self.phoneLabel];
        
        [self addSubview:self.nameTextField];
        [self addSubview:self.emailTextField];
        [self addSubview:self.phoneTextField];
        
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
    }
    
    return self;
}

#pragma mark - NSButton Delegates

- (void)leftButtonPressed:(id)sender
{
    NSLog(@"leftButtonPressed");
}

- (void)rightButtonPressed:(id)sender
{
    NSLog(@"rightButtonPressed");
}

@end
