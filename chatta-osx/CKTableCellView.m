//
//  CKTableCellView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKTableCellView.h"
#import "NSColor+CKAdditions.h"

@implementation CKTableCellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.nameLabel      = [[CKLabel alloc] initWithFrame:NSMakeRect     (30,  58, 148, 20)];
        self.messageLabel   = [[CKLabel alloc] initWithFrame:NSMakeRect     (30,  12, 210, 40)];
        self.timestampLabel = [[CKLabel alloc] initWithFrame:NSMakeRect     (190, 58,  70, 19)];
        self.statusView     = [[CKStatusView alloc] initWithFrame:NSMakeRect(0,    0,  13, 82)];
                
        self.nameLabel.font                  = [NSFont fontWithName:@"HelveticaNeue-Bold" size:14];
        self.nameLabel.textColor             = [NSColor darkGrayColor];
        self.nameLabel.autoresizingMask      = NSViewWidthSizable | NSViewMaxXMargin;

        self.timestampLabel.font             = [NSFont fontWithName:@"HelveticaNeue-Light" size:12];
        self.timestampLabel.textColor        = [NSColor alternateSelectedControlColor];
        self.timestampLabel.autoresizingMask = NSViewMinXMargin;
        
        self.messageLabel.font               = [NSFont fontWithName:@"HelveticaNeue-Light" size:12];
        self.messageLabel.textColor          = [NSColor darkGrayColor];
        self.messageLabel.autoresizingMask   = NSViewWidthSizable;

        [self.nameLabel.cell setLineBreakMode:NSLineBreakByTruncatingTail];

        [self addSubview:self.nameLabel];
        [self addSubview:self.messageLabel];
        [self addSubview:self.timestampLabel];
        [self addSubview:self.statusView];
    }
    
    return self;
}

- (BOOL)wantsDefaultClipping
{
    return NO;
}

- (NSArray *)draggingImageComponents
{
    NSMutableArray *result = [[super draggingImageComponents] mutableCopy];
    
    NSImage *controlImage = [NSImage imageNamed:@"dark_noise.png"];
    NSBitmapImageRep *imageRep = [[controlImage representations] objectAtIndex:0];

    NSImage *draggedImage = [[NSImage alloc] initWithSize:[imageRep size]];
    [draggedImage addRepresentation:imageRep];
    
    NSDraggingImageComponent *colorComponent = [NSDraggingImageComponent draggingImageComponentWithKey:@"Color"];
    colorComponent.contents = draggedImage;
    
    NSRect viewBounds = self.bounds;
    viewBounds = [self convertRect:viewBounds fromView:self];
    colorComponent.frame = viewBounds;
    
    [result insertObject:colorComponent atIndex:0];
    
    return [result copy];
}

#pragma mark - Properties

- (void)setContactState:(ContactState)contactState
{
    self.statusView.contactState = contactState;
    _contactState = contactState;
}

@end
