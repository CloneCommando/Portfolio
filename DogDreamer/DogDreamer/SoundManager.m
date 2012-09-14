//
//  SoundManager.m
//  DogDreamer
//
//  Created by Thomas Colligan on 3/8/12.
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
        savedData = [SavedData sharedInstance];
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
    [soundFilesArray addObject:@"Jump.mp3"]; // Dog Jump
    [soundFilesArray addObject:@"Bell.mp3"]; // Catch Bone
    [soundFilesArray addObject:@"Crash.mp3"]; // Hit Garbage Can
    [soundFilesArray addObject:@"Internationale.mp3"]; // Background Music
    
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
    
    // Set the audio level of all the sounds to what is had been saved as initially, as long as it wasnt muted
    double audioLvl = [savedData getAudioLevel];
    if (audioLvl != 0.0)
        [self setSoundVolume:audioLvl];
}

- (void) playSound: (int) soundIndex
{
    NSLog(@"Playing Sound #%d", soundIndex);
    self.player = [audioPlayersArray objectAtIndex:soundIndex];
    [self.player play];
}

- (void) stopSound: (int) soundIndex
{
    NSLog(@"Stopping Sound #%d", soundIndex);
    self.player = [audioPlayersArray objectAtIndex:soundIndex];
    [self.player stop];
    [self.player setCurrentTime:0.0];
    self.player = nil;
}

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)playedSuccessfully 
{
    // Repeat the background music
    if (self.player == [audioPlayersArray objectAtIndex:BackgroundMusic])
        [self.player play];
    else
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
