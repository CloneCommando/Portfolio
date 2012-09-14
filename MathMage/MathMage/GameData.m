//
//  GameData.m
//  MathMage
//
//  Created by Thomas Colligan on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameData.h"

static GameData *sharedInstance = nil;

@implementation GameData

+ (GameData *)sharedInstance
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
        // Find the path to the GameData.plist
        NSError *error;
        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
        path = [documentsDirectory stringByAppendingPathComponent:@"GameData.plist"];
        
        fileManager = [NSFileManager defaultManager];
        
        // If it has not been copied to the documents directory, then copy it over so it can be edited
        if(![fileManager fileExistsAtPath:path])
        {
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"GameData" ofType:@"plist"];
            
            [fileManager copyItemAtPath:bundle toPath:path error:&error];
             NSLog(@"Copying Over GameData.plist to Documents Directory");
            
            if (error)
            {
                NSLog(@"Error: %@", error);
            }
            
            gameData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
           
        }
    }
    
    return self;
}

- (NSString *) getGameDifficultyLevel
{
    // Make sure we have up to date data before we do anything
    gameData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSString* difficultyLevel = [gameData objectForKey:@"Difficulty"];
    gameData = nil;
    
    return difficultyLevel;
}

- (void) setGameDifficultyLevel: (NSString *)level
{
    // Make sure we have up to date data before we do anything
    gameData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    [gameData setObject:level forKey:@"Difficulty"];
    [gameData writeToFile:path atomically:YES];
    
    gameData = nil;
}

- (double) getGameAudioLevel
{
    // Make sure we have up to date data before we do anything
    gameData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    double audioLevel = [[gameData objectForKey:@"AudioLevel"] doubleValue];
    gameData = nil;
    
    return audioLevel;
}

- (void) setGameAudioLevel: (double) level
{
    // Make sure we have up to date data before we do anything
    gameData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    [gameData setObject:[NSNumber numberWithDouble:level ] forKey:@"AudioLevel"];
    [gameData writeToFile:path atomically:YES];
    
    gameData = nil;
}

- (NSString *) getHighScoreText: (NSString *)testType scoreType: (NSString *) scoreType
{
    // Make sure we have up to date data before we do anything
    gameData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSMutableDictionary *highScoresDict = [gameData objectForKey:@"HighScores"];
    
    if ([scoreType isEqualToString:@"NumberCorrect"])
    {
        NSString *correctAnswersKey = [NSString stringWithFormat:@"%@_CorrectAnswers", testType];
        NSString *totalQuestionsKey = [NSString stringWithFormat:@"%@_TotalQuestions", testType];
        
        int numOfCorrectAnswers = [[highScoresDict objectForKey:correctAnswersKey] intValue];
        int numOfTotalQuestions = [[highScoresDict objectForKey:totalQuestionsKey] intValue];
        
        gameData = nil;
        return [NSString stringWithFormat:@"%d / %d", numOfCorrectAnswers, numOfTotalQuestions];
    }
    else // scoreType was BestTime
    {
        NSString *bestTimeKey = [NSString stringWithFormat:@"%@_BestTime", testType];
        double bestTime = [[highScoresDict objectForKey:bestTimeKey] doubleValue];
        
        // User hasnt taken this test yet
        if (bestTime == 0)
            return @"None";
        
        gameData = nil;
        return [NSString stringWithFormat:@"%1.2f sec", bestTime];
    }
}

- (void) saveNewHighScore: (NSString *)testType newNumOfCorrectAnswers: (int) newNumOfCorrectAnswers newNumOfQuestionsCompleted: (int)newNumOfQuestionsCompleted newBestTime: (double) newBestTime
{
    // Make sure we have up to date data before we do anything
    BOOL dataDidChange = NO;
    gameData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    // Look at the old data that we have saved already
    NSMutableDictionary *highScoresDict = [gameData objectForKey:@"HighScores"];
    NSString *correctAnswersKey = [NSString stringWithFormat:@"%@_CorrectAnswers", testType];
    NSString *totalQuestionsKey = [NSString stringWithFormat:@"%@_TotalQuestions", testType];
    NSString *bestTimeKey = [NSString stringWithFormat:@"%@_BestTime", testType];
    
    int numOfCorrectAnswers = [[highScoresDict objectForKey:correctAnswersKey] intValue];
    int numOfTotalQuestions = [[highScoresDict objectForKey:totalQuestionsKey] intValue];
    double bestTime = [[highScoresDict objectForKey:bestTimeKey] doubleValue];
    
    // Compare it with the new data, if the new data is a better score, save it!
    double oldNumberCorrectTotal;
    if(numOfTotalQuestions == 0)
        oldNumberCorrectTotal = 0;
    else
        oldNumberCorrectTotal= numOfCorrectAnswers / numOfTotalQuestions;
    
    double newNumberCorrectTotal;
    if (newNumOfQuestionsCompleted == 0)
        newNumberCorrectTotal = 0;
    else
        newNumberCorrectTotal = (double)newNumOfCorrectAnswers / (double)newNumOfQuestionsCompleted;
    
    // Set the objects with the new data
    if(newNumberCorrectTotal > oldNumberCorrectTotal)
    {
        [highScoresDict setObject:[NSNumber numberWithInt:newNumOfCorrectAnswers] forKey:correctAnswersKey];
        [highScoresDict setObject:[NSNumber numberWithInt:newNumOfQuestionsCompleted] forKey:totalQuestionsKey];
        dataDidChange = YES;
        
    }
    
    if(newBestTime < bestTime || bestTime == 0.0)
    {
        [highScoresDict setObject:[NSNumber numberWithDouble:newBestTime] forKey:bestTimeKey];
        dataDidChange = YES;
    }
    
    // Set the parent object, and write the new data to the file if the data changed
    if(dataDidChange == YES)
    {
        NSLog(@"Writing changed data to file");
        [gameData setObject:highScoresDict forKey:@"HighScores"];
        [gameData writeToFile:path atomically:YES];
    }
    
    gameData = nil;
}

@end
