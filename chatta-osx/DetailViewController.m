//
//  DetailViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

- (void)setEnabled:(BOOL)enabled
{
    if (enabled == YES) {
        [self.messagesInputTextField.cell setPlaceholderString:@"Type message here..."];
    } else {
        [self.messagesInputTextField.cell setPlaceholderString:@"Login to send messages..."];
    }
    
    [self.messagesTextView setEnabled:enabled];
    [self.messagesInputTextField setEnabled:enabled];
    _enabled = enabled;
}

- (void)setContact:(CKContact *)contact
{
    if (contact == nil) {
        [self.messagesTextView.textStorage
            setAttributedString:[[NSAttributedString alloc] initWithString:@""]];
    }
    else {
        // clear out textview
        [self.messagesTextView.textStorage
            setAttributedString:[[NSAttributedString alloc] initWithString:@""]];
        // update textview
        for (CKMessage *message in contact.messages) {
            [self updateTextViewWithNewMessage:message];
        }
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
    self.messagesInputTextField.delegate = self;
    self.messagesTextView.textContainerInset = NSMakeSize(1.0, 3.0);
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
        NSMutableAttributedString *attrString;
        if ([self.messagesTextView.textStorage.string isEqualToString:@""]) {
            attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:
            @"[%@] %@: %@", message.timestampString, message.contact.displayName, message.text]];
        }
        else {
            attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:
            @"\n[%@] %@: %@", message.timestampString, message.contact.displayName, message.text]];
        }
         
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
        
        [self.messagesTextView setNeedsDisplay:YES];
        
        // scroll the bottom of screen
        [self.scrollView scrollToBottom];
    });
}

#pragma mark - NSTextField Delegates

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
    NSTextView *textView = (NSTextView *)fieldEditor;
    [textView setContinuousSpellCheckingEnabled:YES];
    return YES;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    NSTextView *textView = (NSTextView *)fieldEditor;
    [textView setContinuousSpellCheckingEnabled:NO];
    return YES;
}

@end
