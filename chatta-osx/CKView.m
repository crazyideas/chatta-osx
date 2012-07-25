//
//  ConfigureView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKView.h"

@implementation CKView

@synthesize backgroundImage      = _backgroundImage;
@synthesize backgroundImageAlpha = _backgroundImageAlpha;

- (id)initWithImage:(NSString *)imageName alpha:(CGFloat)alpha {
    self = [super init];
    if (self) {
        self.backgroundImage      = [NSImage imageNamed:imageName];
        self.backgroundImageAlpha = alpha;
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundImage      = nil;
        self.backgroundImageAlpha = 1.0;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (self.backgroundImage != nil) {
        NSSize imageSize = self.backgroundImage.size;
        [self.backgroundImage drawInRect:self.bounds 
                                fromRect:NSMakeRect(0.0, 0.0, imageSize.width, imageSize.height) 
                               operation:NSCompositeCopy 
                                fraction:self.backgroundImageAlpha];
    }
}

@end
