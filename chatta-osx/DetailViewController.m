//
//  DetailViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

- (void)setContact:(CKContact *)contact
{
    if (contact == nil) {
        [self.messagesTextView.textStorage
            setAttributedString:[[NSAttributedString alloc] initWithString:@""]];
        [self.messagesTextView setEnabled:NO];
        [self.messagesInputTextField setEnabled:NO];
    }
    else {
        // clear out textview
        [self.messagesTextView.textStorage
            setAttributedString:[[NSAttributedString alloc] initWithString:@""]];
        // update textview
        for (CKMessage *message in contact.messages) {
            [self updateTextViewWithNewMessage:message];
        }
        [self.messagesTextView setEnabled:YES];
        [self.messagesInputTextField setEnabled:YES];
    }
    
    _contact = contact;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    //[self.messagesTextView setEditable:NO];
    [self.messagesTextView setSelectable:NO];
}

- (IBAction)newMessageEntered:(id)sender 
{
    NSTextField *textField = sender;
    
    if ([textField.stringValue isEqualToString:@""]) {
        return;
    }

    if (self.delegate != nil) {
        [self.delegate sendNewMessage:textField.stringValue toContact:self.contact];
    }
    
    textField.stringValue = @"";
}


- (void)updateTextViewWithNewMessage:(CKMessage *)message
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        NSMutableAttributedString *attrString =
            [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:
            @"[%@] %@: %@\n", message.timestampString, message.contact.displayName, message.text]];
        NSRange boldRange = [attrString.string rangeOfString:message.contact.displayName];
        NSRange greyRange = [attrString.string rangeOfString:
            [NSString stringWithFormat:@"[%@]", message.timestampString]];

        [attrString beginEditing];

        [attrString addAttribute:NSFontAttributeName
                           value:[NSFont fontWithName:@"Helvetica" size:14]
                           range:NSMakeRange(0, [attrString length])];
        
        [attrString addAttribute:NSFontAttributeName
                           value:[NSFont fontWithName:@"Helvetica-Bold" size:14]
                           range:boldRange];
        
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:[NSColor disabledControlTextColor]
                           range:greyRange];
        
        [attrString endEditing];
        
        [self.messagesTextView.textStorage appendAttributedString:attrString];
        
        // scroll the bottom of screen
        [self.scrollView scrollToBottom];
    });
}

@end
