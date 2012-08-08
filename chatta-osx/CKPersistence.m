//
//  CKPersistence.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "CKPersistence.h"
#import "CKContactList.h"

@implementation CKPersistence

+ (NSString *)pathForContactsFile
{
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *folder = @"~/Library/Application Support/chatta-osx";
    folder = [folder stringByExpandingTildeInPath];
    
    if ([fileManager fileExistsAtPath:folder] == NO) {
        [fileManager createDirectoryAtPath:folder withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    if (error != nil) {
        CKDebug(@"error creating application support dir: %@", error);
        return nil;
    }
    
    NSString *fileName = @"chatta-osx.database";
    return [folder stringByAppendingPathComponent:fileName];
}

+ (void)saveContactsToPersistentStorage
{
    NSString *path = [CKPersistence pathForContactsFile];
    if (path == nil) {
        CKDebug(@"path to save is nil");
        return;
    }
    
    NSMutableDictionary *rootObject = [NSMutableDictionary dictionary];
    
    [rootObject setValue:[CKContactList sharedInstance].me
                  forKey:@"CKContactList-Me"];
    [rootObject setValue:[CKContactList sharedInstance].allContacts
                  forKey:@"CKContactList-ContactList"];
    [NSKeyedArchiver archiveRootObject:rootObject toFile:path];
}

+ (void)loadContactsFromPersistentStorage
{
    NSString *path = [CKPersistence pathForContactsFile];
    if (path == nil) {
        CKDebug(@"path to save is nil");
        return;
    }
    
    NSDictionary *rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [[CKContactList sharedInstance]
        setMe:[rootObject valueForKey:@"CKContactList-Me"]];
    [[CKContactList sharedInstance]
        replaceAllContacts:[rootObject valueForKey:@"CKContactList-ContactList"]];
}

@end
