//
//  CKShadowTextFieldCell.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKShadowTextFieldCell.h"

static NSShadow *textFieldCellShadow;

@implementation CKShadowTextFieldCell

+ (void)initialize
{
    textFieldCellShadow = [[NSShadow alloc] init];
    [textFieldCellShadow setShadowOffset:NSMakeSize(0.0, -1.0)];
    [textFieldCellShadow setShadowBlurRadius:0.0];
    [textFieldCellShadow setShadowColor:[NSColor whiteColor]];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    textFieldCellShadow = [[NSShadow alloc] init];
    [textFieldCellShadow setShadowOffset:NSMakeSize(0.0, -2.0)];
    [textFieldCellShadow setShadowBlurRadius:0.0];
    [textFieldCellShadow setShadowColor:[NSColor whiteColor]];
    
    [textFieldCellShadow set];
    [super drawInteriorWithFrame:cellFrame inView:controlView];
}

@end
