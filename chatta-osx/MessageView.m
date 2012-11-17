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
        self.segmentedControl = [[NSSegmentedControl alloc] initWithFrame:NSMakeRect( 11, 150, 301, 24)];
        self.serviceLabel     = [[CKLabel alloc] initWithFrame:NSMakeRect           (  9, 120,  98, 17)];
        self.messageLabel     = [[CKLabel alloc] initWithFrame:NSMakeRect           ( 48,  88,  59, 17)];
        self.serviceTextField = [[NSTextField alloc] initWithFrame:NSMakeRect       (112, 117, 198, 22)];
        self.messageTextField = [[NSTextField alloc] initWithFrame:NSMakeRect       (112,  41, 198, 66)];
        self.sendButton       = [[NSButton alloc] initWithFrame:NSMakeRect          (216,   5, 100, 32)];
        self.noteLabel        = [[CKLabel alloc] initWithFrame:NSMakeRect           ( 10,  11, 221, 17)];
        
        [self.segmentedControl setSegmentCount:2];
        [self.segmentedControl setLabel:@"Google Talk" forSegment:0];
        [self.segmentedControl setLabel:@"Google Voice" forSegment:1];
        [self.segmentedControl setWidth:148 forSegment:0];
        [self.segmentedControl setWidth:148 forSegment:1];
        [self.segmentedControl setSelectedSegment:0];
        [self.segmentedControl setTarget:self];
        [self.segmentedControl setAction:@selector(segmentedControlAction:)];
        
        [self.serviceLabel setTextColor:[NSColor darkGrayColor]];
        [self.serviceLabel setAttributedStringValue:[NSFont etchedString:@"Phone Number"
            withFont:[NSFont systemFontOfSize:0]]];
        
        [self.messageLabel setTextColor:[NSColor darkGrayColor]];
        [self.messageLabel setAttributedStringValue:[NSFont etchedString:@"Message"
            withFont:[NSFont systemFontOfSize:0]]];
        
        [self.sendButton setTitle:@"Send"];
        [self.sendButton setBezelStyle:NSRoundedBezelStyle];
        [self.sendButton setTarget:self];
        [self.sendButton setAction:@selector(sendAction:)];
        
        [self.noteLabel setTextColor:[NSColor darkGrayColor]];
        [self.noteLabel setAttributedStringValue:[NSFont etchedString:@"Message will be sent if contact is online"
            withFont:[NSFont systemFontOfSize:10]]];
        
        [self addSubview:self.segmentedControl];
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

#pragma mark - Actions

- (void)segmentedControlAction:(id)sender
{
    NSInteger selectedSegment = [sender selectedSegment];
    CKDebug(@"[+] MessageView, segmentedControlAction, %li", selectedSegment);
}

- (void)sendAction:(id)sender
{
    CKDebug(@"[+] MessageView, sendButtonAction");
}

@end
