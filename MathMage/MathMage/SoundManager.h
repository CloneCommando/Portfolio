//
//  SoundManager.h
//  MathMage
//
//  Created by Thomas Colligan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
    TimerClick = 0,
    ButtonClick = 1,
    CorrectAnswer = 2,
    IncorrectAnswer = 3,
    TimeIsUp = 4
} Sounds;

@interface SoundManager : NSObject <AVAudioPlayerDelegate>
{
    NSMutableArray *audioPlayersArray;
    NSMutableArray *soundFilesArray;
}

@property (nonatomic, strong) AVAudioPlayer *player;

+ (SoundManager *)sharedInstance;

- (void) loadSoundFiles;
- (void) playSound: (int) soundIndex;
- (void) setSoundVolume: (double) newVolumeLevel;

@end
