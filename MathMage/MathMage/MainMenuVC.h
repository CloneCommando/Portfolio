//
//  MainMenuVC.h
//  MathMage
//
//  Created by Thomas Colligan on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestSelectionVC.h"
#import "CustomizedTestVC.h"
#import "HighScoresVC.h"
#import "OptionsVC.h"
#import "InstructionsVC.h"
#import "GameData.h"
#import "SoundManager.h"

@interface MainMenuVC : UIViewController

@property (nonatomic, strong) GameData *gameData;
@property (nonatomic, strong) SoundManager *soundManager;

-(IBAction)playBtnClicked:(id)sender;
-(IBAction)customizeBtnClicked:(id)sender;
-(IBAction)highScoresBtnClicked:(id)sender;
-(IBAction)optionsBtnClicked:(id)sender;
-(IBAction)instructionsBtnClicked:(id)sender;

@end
