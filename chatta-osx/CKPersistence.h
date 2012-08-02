//
//  CKPersistence.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKPersistence : NSObject

+ (void)saveContactsToPersistentStorage;
+ (void)loadContactsFromPersistentStorage;

@end
