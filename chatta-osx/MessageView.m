//
//  MessageView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "MessageView.h"
#import "CKButton.h"
#import "CKLabel.h"

#import "NSColor+CKAdditions.h"
#import "NSFont+CKAdditions.h"

@implementation MessageView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftButton       = [[CKButton alloc] initWithFrame:NSMakeRect   (  0, 146, 160, 40)];
        self.rightButton      = [[CKButton alloc] initWithFrame:NSMakeRect   (160, 146, 160, 40)];
        self.serviceLabel     = [[CKLabel alloc] initWithFrame:NSMakeRect    (  9, 120,  98, 17)];
        self.messageLabel     = [[CKLabel alloc] initWithFrame:NSMakeRect    ( 48,  88,  59, 17)];
        self.serviceTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(112, 117, 198, 22)];
        self.messageTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(112,  41, 198, 66)];
        self.sendButton       = [[NSButton alloc] initWithFrame:NSMakeRect   (216,   5, 100, 32)];
        self.noteLabel        = [[CKLabel alloc] initWithFrame:NSMakeRect    ( 10,  11, 221, 17)];
        
        [self.leftButton setTitle:@"Google Talk"];
        [self.leftButton setState:NSOnState];
        
        [self.rightButton setTitle:@"Google Voice"];
        
        [self.serviceLabel setTextColor:[NSColor darkGrayColor]];
        [self.serviceLabel setAttributedStringValue:[NSFont etchedString:@"Phone Number"
            withFont:[NSFont systemFontOfSize:0]]];
        
        [self.messageLabel setTextColor:[NSColor darkGrayColor]];
        [self.messageLabel setAttributedStringValue:[NSFont etchedString:@"Message"
            withFont:[NSFont systemFontOfSize:0]]];
        
        [self.sendButton setTitle:@"Send"];
        [self.sendButton setBezelStyle:NSRoundedBezelStyle];
        
        [self.noteLabel setTextColor:[NSColor darkGrayColor]];
        [self.noteLabel setAttributedStringValue:[NSFont etchedString:@"Message will be sent if contact is online"
            withFont:[NSFont systemFontOfSize:10]]];
        
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self addSubview:self.serviceLabel];
        [self addSubview:self.messageLabel];
        [self addSubview:self.serviceTextField];
        [self addSubview:self.messageTextField];
        [self addSubview:self.sendButton];
        [self addSubview:self.noteLabel];
    }
    
    return self;
}

#pragma mark - Overridden Methods

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor mediumBackgroundNoiseColor] setFill];
    NSRectFill(dirtyRect);
}

@end
