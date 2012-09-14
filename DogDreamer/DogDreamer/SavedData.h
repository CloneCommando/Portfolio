//
//  SavedData.h
//  DogDreamer
//
//  Created by Thomas Colligan on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavedData : NSObject
{
    NSUserDefaults *data;
}

+ (SavedData *)sharedInstance;

- (void) saveDifficultyLevel: (NSString *) difficultyLevel;
- (void) saveAudioLevel: (double) audioLevel;
- (void) saveHighScore: (int)score difficultyLevel: (NSString *)diffLvl;

- (NSString *) getDifficultyLevel;
- (double) getAudioLevel;
- (int) getHighScore: (NSString *) diffLvl;
- (void) updateData;

@end
