//
//  NSSound+CKAdditions.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "NSSound+CKAdditions.h"

@implementation NSSound (CKAdditions)

+ (void)playNewMessageBackgroundSound
{
    NSSound *sound = [NSSound soundNamed:@"Tink"];
    if (sound != nil && sound.isPlaying == NO) {
        [sound play];
    }
}

+ (void)playNewMessageForegroundSound
{
    NSSound *sound = [NSSound soundNamed:@"Tink"];
    if (sound != nil && sound.isPlaying == NO) {
        [sound play];
    }
}

@end
