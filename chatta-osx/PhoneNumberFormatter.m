//
//  PhoneNumberFormatter.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "PhoneNumberFormatter.h"

@implementation PhoneNumberFormatter

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
    
    // valid phone number character set 
    NSString *validPhoneNumberChars = @"0123456789-";
    NSCharacterSet *phoneNumberCharacterSet = 
        [NSCharacterSet characterSetWithCharactersInString:validPhoneNumberChars];
    
    // if phone number characters not found, return 
    NSRange foundLocation = [newString rangeOfCharacterFromSet:phoneNumberCharacterSet];
    if (foundLocation.location == NSNotFound) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber
{
    NSDataDetector *detector = [NSDataDetector 
        dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:nil];
    
    NSUInteger numberOfMatches = [detector numberOfMatchesInString:phoneNumber
        options:0 range:NSMakeRange(0, phoneNumber.length)];
    
    if (numberOfMatches != 1) {
        return NO;
    }
    
    NSArray *matches = [detector matchesInString:phoneNumber
                                         options:0 range:NSMakeRange(0, phoneNumber.length)];
    NSTextCheckingResult *match = [matches objectAtIndex:0];
    if ([match resultType] != NSTextCheckingTypePhoneNumber) {
        return NO;
    }
    
    NSString *matchPhoneNumber = [match phoneNumber];
    matchPhoneNumber = [matchPhoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if (matchPhoneNumber.length != 11) {
        return NO;
    }
    
    return YES;
}

+ (NSString *)stripPhoneNumberFormatting:(NSString *)number
{
    NSString *strippedString = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return [NSString stringWithFormat:@"+%@", strippedString];
}

@end
