//
//  SoundManager.m
//  MathMage
//
//  Created by Thomas Colligan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundManager.h"

static SoundManager *sharedInstance = nil;

@implementation SoundManager
@synthesize player;

+ (SoundManager *)sharedInstance
{
    if(!sharedInstance)
    {
        // Create the singleton
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id) init
{
    if (sharedInstance)
    {
        return sharedInstance;
    }
    
    self = [super init];
    
    if (self)
    {
        // Initalize data
        [self loadSoundFiles];
    }
    
    return self;
}

- (void) loadSoundFiles
{
    // Initalize our arrays
    soundFilesArray = [NSMutableArray array];
    audioPlayersArray = [NSMutableArray array];
    
    // Load in our sound files in order
    [soundFilesArray addObject:@"click2.mp3"]; // Timer Click
    [soundFilesArray addObject:@"click2.mp3"]; // Button Click
    [soundFilesArray addObject:@"Ding.mp3"]; // Correct Answer
    [soundFilesArray addObject:@"buzz.mp3"]; // Incorrect Answer
    [soundFilesArray addObject:@"alarm.mp3"]; // Time is up
    
    // Split up the sounds and load them into their own players
    NSString *fileName = nil;
    NSString *fileExtension = nil;
    NSArray *sections = nil;
    NSString *soundFilePath = nil;
    NSURL *fileUrl = nil;
    AVAudioPlayer *myPlayer = nil;
    
    // Each sound having its own player makes sure there are no delays when the sound plays
    for (NSString *fileString in soundFilesArray)
    {
        sections = [fileString componentsSeparatedByString:@"."];
        fileName = [sections objectAtIndex:0];
        fileExtension = [sections objectAtIndex:1];
        
        soundFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
        fileUrl = [[NSURL alloc] initFileURLWithPath:soundFilePath];
        myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
        [myPlayer prepareToPlay];
        [audioPlayersArray addObject:myPlayer];
    }
    
    soundFilesArray = nil;
    
}

- (void) playSound: (int) soundIndex
{
    NSLog(@"Playing Sound #%d", soundIndex);
    self.player = [audioPlayersArray objectAtIndex:soundIndex];
    [self.player play];
}

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)playedSuccessfully 
{
    self.player = nil;
}

- (void) setSoundVolume: (double) newVolumeLevel
{
    // Double check volume values
    if(newVolumeLevel < 0.0)
        newVolumeLevel = 0.0;
    else if (newVolumeLevel > 1.0)
        newVolumeLevel = 1.0;
    
    NSLog(@"Changing Sound Volume to %f", newVolumeLevel);
    
    // Set the volume level of all the audio players
    for (AVAudioPlayer *pl in audioPlayersArray)
    {
        [pl setVolume:newVolumeLevel];
    }
}

@end
