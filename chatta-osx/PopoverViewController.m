//
//  PopoverViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "PopoverViewController.h"
#import "PopoverView.h"

@implementation PopoverViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.view = [[PopoverView alloc] initWithFrame:NSMakeRect(0, 0, 320, 200)];
        
        [self.view setAutoresizesSubviews:YES];
        [self.view setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin |
            NSViewMinYMargin | NSViewMaxYMargin];
    }
    return self;
}

@end
