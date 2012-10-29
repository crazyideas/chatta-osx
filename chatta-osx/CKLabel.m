//
//  CKLabel.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKLabel.h"

@implementation CKLabel

- (void)propertyInit
{
    [self setBezeled:NO];
    [self setDrawsBackground:NO];
    [self setEditable:NO];
    [self setSelectable:NO];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self propertyInit];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self propertyInit];
    }
    
    return self;
}


@end
