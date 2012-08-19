//
//  DetailViewCacheItem.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "DetailViewCacheItem.h"

@implementation DetailViewCacheItem

- (id)init
{
    self = [super init];
    if (self) {
        self.textStorage = [[NSMutableAttributedString alloc] init];
        self.itemCount = 0;
    }
    return self;
}

@end
