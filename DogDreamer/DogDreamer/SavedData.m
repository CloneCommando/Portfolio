//
//  SavedData.m
//  DogDreamer
//
//  Created by Thomas Colligan on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SavedData.h"

static SavedData *sharedInstance;

@implementation SavedData

+ (SavedData *)sharedInstance
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
        data = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

# pragma mark - Methods that Save Data

- (void) saveDifficultyLevel: (NSString *) difficultyLevel
{
    [data setObject:difficultyLevel forKey:@"DifficultyLevel"];
    [data synchronize];
}

- (void) saveAudioLevel: (double) audioLevel
{
    [data setDouble:audioLevel forKey:@"AudioLevel"];
    [data synchronize];
}

- (void) saveHighScore: (int)score difficultyLevel: (NSString *)diffLvl
{
    NSString *key = [NSString stringWithFormat:@"%@_HighScore", diffLvl];
    [data setInteger:score forKey:key];
    [data synchronize];
}

# pragma mark - Methods the retrieve saved data
- (NSString *) getDifficultyLevel
{
    return [data stringForKey:@"DifficultyLevel"];
}

- (double) getAudioLevel
{
    return [data doubleForKey:@"AudioLevel"];
}

- (int) getHighScore: (NSString *) diffLvl
{
    NSString *key = [NSString stringWithFormat:@"%@_HighScore", diffLvl];
    return [data integerForKey:key];
}

- (void) updateData
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    data = [NSUserDefaults standardUserDefaults];
}

@end
