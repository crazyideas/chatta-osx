//
//  PhoneNumberFormatter.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKPhoneNumberFormatter : NSFormatter

+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber;

+ (NSString *)phoneNumberInServiceFormat:(NSString *)number;
+ (NSString *)phoneNumberInDisplayFormat:(NSString *)number;

@end
