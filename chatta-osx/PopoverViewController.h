//
//  PopoverViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PopoverView.h"
#import "CKContact.h"

@interface PopoverViewController : NSViewController

@property (nonatomic, strong) PopoverView *popoverView;
@property (nonatomic, strong) CKContact *contact;

@property (nonatomic) PopoverType popoverType;

@end
