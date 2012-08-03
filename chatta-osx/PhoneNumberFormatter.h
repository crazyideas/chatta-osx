//
//  PhoneNumberFormatter.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneNumberFormatter : NSFormatter

+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber;
+ (NSString *)stripPhoneNumberFormatting:(NSString *)number;
//+ (NSString *)stringInDisplayFormat:(NSString *)number;

@end
