//
//  CKButton.h
//  CustomButton
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CKButtonCell.h"

@interface CKButton : NSButton

@property (nonatomic, strong) CKButtonCell *buttonCell;

@end
