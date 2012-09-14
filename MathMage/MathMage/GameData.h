//
//  GameData.h
//  MathMage
//
//  Created by Thomas Colligan on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject
{
    NSArray *paths;
    NSString *documentsDirectory;
    NSString *path;
    NSFileManager *fileManager;
    NSMutableDictionary *gameData;
}

+ (GameData *)sharedInstance;

- (NSString *) getGameDifficultyLevel;
- (void) setGameDifficultyLevel: (NSString *)level;
- (double) getGameAudioLevel;
- (void) setGameAudioLevel: (double)level;
- (NSString *) getHighScoreText: (NSString *)testType scoreType: (NSString *) scoreType;
- (void) saveNewHighScore: (NSString *)testType newNumOfCorrectAnswers: (int) newNumOfCorrectAnswers newNumOfQuestionsCompleted: (int)newNumOfQuestionsCompleted newBestTime: (double) newBestTime;

@end
