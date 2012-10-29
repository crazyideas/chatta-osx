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
    NSString *soundPath = @"/System/Library/Components/CoreAudio.component/Contents/"
    "SharedSupport/SystemSounds/system/burn complete.aif";
    NSSound *sound = [[NSSound alloc] initWithContentsOfFile:soundPath byReference:YES];
    if (sound == nil) {
        soundPath = [[NSBundle mainBundle] pathForResource:@"chatta_new_message" ofType:@"wav"];
        sound = [[NSSound alloc] initWithContentsOfFile:soundPath byReference:YES];
    }
    
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
