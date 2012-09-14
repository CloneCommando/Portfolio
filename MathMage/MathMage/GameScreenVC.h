//
//  GameScreenVC.h
//  MathMage
//
//  Created by Thomas Colligan on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MathTest.h"
#import "GameData.h"
#import "SoundManager.h"
#import "SpriteAnimator.h"

@interface GameScreenVC : UIViewController <UIAlertViewDelegate>
{
    enum TimerMode { ReadjustTime, QuestionCountdown, GameAnimation, NextQuestion, Paused };
    CGRect orgBtn1Rect;
    CGRect orgBtn2Rect;
    CGRect orgBtn3Rect;
    CGRect orgBtn4Rect;
    CGRect orgQLabelRect;
    CGRect orgALabelRect;
    CGRect orgTimerLabelRect;
    CGRect orgTitleLabelRect;
    CGRect orgCloseBtnRect;
    
    double correctAnswer;
    NSTimer *timer;
    double timeLeft;
    int damagePerEnemyAttack, damagePerUserAttack;
    enum TimerMode timerModeBeforePause;
    NSString *mathTestType;
    double halfTimerCountdownInterval;
    BOOL testUsesDoubleDigits;
    
    BOOL didStartInitialAnimation;
    UIImageView *playerMageAnimation;
    UIImageView *enemyMageAnimation;
    UIImageView *userHealthBar;
    UIImageView *userLightningAttack;
    UIImageView *enemyLightningAttack;
    UIImageView *userWandExplode;
    float orgHealthBarHeight;
    BOOL killTest;
}

@property (strong, nonatomic) MathTest *mathTest;
@property (nonatomic, strong) GameData *gameData;
@property (nonatomic, strong) SoundManager *soundManager;
@property (nonatomic, strong) SpriteAnimator *spriteAnimator;
@property (nonatomic, strong) IBOutlet UIButton *answerBtn1;
@property (nonatomic, strong) IBOutlet UIButton *answerBtn2;
@property (nonatomic, strong) IBOutlet UIButton *answerBtn3;
@property (nonatomic, strong) IBOutlet UIButton *answerBtn4;
@property (nonatomic, strong) IBOutlet UILabel *questionLabel;
@property (nonatomic, strong) IBOutlet UILabel *answerLabel;
@property (nonatomic, strong) IBOutlet UILabel *timerLabel;
@property (nonatomic, strong) IBOutlet UILabel *yourHpLabel;
@property (nonatomic, strong) IBOutlet UILabel *enemyHpLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIButton *exitBtn;

@property (nonatomic, assign) int numOfQuestionsAsked;
@property (nonatomic, assign) int numOfQuestionsAnsweredCorrectly;
@property (nonatomic, assign) double timeSpentAnsweringQuestions;
@property (nonatomic, assign) enum TimerMode timerMode;
@property (nonatomic, assign) int uiAnimationSpeed;
@property (nonatomic, assign) double timerCountdownInterval, timePerQuestion, timePerGameAnimation, timeTillNextQuestion, timePerReadjust;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil testType:(NSString *)testType isCustomTest:(BOOL)isCustomTest customQuestions:(NSMutableArray *)questionsArray;
- (IBAction)answerBtnClicked:(id)sender;
- (IBAction)exitBtnClicked:(id)sender;

- (void)loadNewMathQuestion:(NSString *)question;
- (void)checkUserAnswer:(double)userAnswer;
- (void)timerCountdown:(int)totalSeconds;
- (void)testIsFinished;
- (void)changeTitleLabel:(NSString *)status;
- (void)resetUIPosition;
- (void)animateUI: (double)xDist: (double)yDist;
- (void)setButtonsEnabled: (BOOL) isEnabled;
- (void)saveGameData;
- (void)setUserHealthBar: (int) currentHealth;
- (void)killMathTest;

@end
