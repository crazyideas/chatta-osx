//
//  EmailAddressFormatter.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKEmailAddressFormatter.h"

@implementation CKEmailAddressFormatter

- (NSString *)stringForObjectValue:(id)object
{
    return (NSString *)object;
}

- (BOOL)getObjectValue:(__autoreleasing id *)object 
             forString:(NSString *)string 
      errorDescription:(NSString *__autoreleasing *)error
{
    *object = string;
    return YES;
}

- (BOOL)isPartialStringValid:(NSString *__autoreleasing *)partialStringPtr 
       proposedSelectedRange:(NSRangePointer)proposedSelRangePtr 
              originalString:(NSString *)origString 
       originalSelectedRange:(NSRange)origSelRange 
            errorDescription:(NSString *__autoreleasing *)error
{
    // new string that only contains changes
    NSRange newRange = NSMakeRange(origSelRange.location, (*proposedSelRangePtr).location - origSelRange.location);
    NSString *newString = [(*partialStringPtr) substringWithRange:newRange];
    
    // backspace
    if ([newString isEqualToString:@""]) {
        return YES;
    }
    
    // invalid email character set 
    NSString *invalidEmailChars = @" ";
    NSCharacterSet *invalidEmailCharacterSet = 
        [NSCharacterSet characterSetWithCharactersInString:invalidEmailChars];
    
    // if invalid email characters not found, return 
    NSRange foundLocation = [newString rangeOfCharacterFromSet:invalidEmailCharacterSet];
    if (foundLocation.location == NSNotFound) {
        return YES;
    }
    
    return NO;
}


+ (BOOL)isValidEmailAddress:(NSString *)emailAddress
{
    NSString *regexPattern = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPattern];
    if ([predicate evaluateWithObject:emailAddress] == YES) {
        return YES;
    }
    
    return NO;
}


@end
