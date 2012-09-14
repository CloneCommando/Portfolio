//
//  SoundManager.h
//  DogDreamer
//
//  Created by Thomas Colligan on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SavedData.h"

typedef enum {
    DogJump = 0,
    CollectedBone = 1,
    HitGarbageCan = 2,
    BackgroundMusic = 3
} Sounds;

@interface SoundManager : NSObject <AVAudioPlayerDelegate>
{
    NSMutableArray *audioPlayersArray;
    NSMutableArray *soundFilesArray;
    SavedData *savedData;
}

@property (nonatomic, strong) AVAudioPlayer *player;

+ (SoundManager *)sharedInstance;

- (void) loadSoundFiles;
- (void) playSound: (int) soundIndex;
- (void) stopSound: (int) soundIndex;
- (void) setSoundVolume: (double) newVolumeLevel;

@end
