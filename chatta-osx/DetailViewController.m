//
//  DetailViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

@synthesize delegate               = _delegate;
@synthesize messagesTextView       = _messagesTextView;
@synthesize messagesInputTextField = _messagesInputTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (IBAction)newMessageEntered:(id)sender 
{
    if (self.delegate != nil) {
        NSTextField *textField = sender;
        [self.delegate sendNewMessage:textField.stringValue];
    }
}
@end
