//
//  GameVC.h
//  DogDreamer
//
//  Created by Thomas Colligan on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dog.h"
#import "Controls.h"
#import "GameLevel.h"
#import "SoundManager.h"

@interface GameVC : UIViewController
{
    Controls *movementController;
    GameLevel *gameLevel;
    SoundManager *soundManager;
    enum TimerMode timerMode;
    
    UILabel *timerLabel;
    UILabel *bonesCollectedLabel;
    UILabel *introLabel;
    NSTimer *timer;
    
    float timerInterval;
    float timeLeft;
    int numOfBonesCollected;
    
    float introTimeAmount;
    float mainGameTimeAmount;
    float gameOverTimeAmount;
    
    enum TimerMode { Intro, MainGame, GameOver, Paused };
    BOOL didKillIntroLabel;
}

@property (nonatomic, strong) Dog *characterDogRef;

- (void) gameLoop;
- (void) checkControllerInput;
- (void) reset;

@end
