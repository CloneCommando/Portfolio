//
//  MainMenuVC.h
//  DogDreamer
//
//  Created by Thomas Colligan on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameVC.h"
#import "InstructionsVC.h"
#import "OptionsVC.h"
#import "HighScoresVC.h"

@interface MainMenuVC : UIViewController
{
    IBOutlet UILabel *playBtnLabel;
    IBOutlet UILabel *instructionsBtnLabel;
    IBOutlet UILabel *highScoresLabel;
    IBOutlet UILabel *optionsLabel;
    BOOL didRotateLabels;
}

@property (nonatomic, retain) GameVC *gameVC;
@property (nonatomic, retain) InstructionsVC *instructionsVC;
@property (nonatomic, retain) OptionsVC *optionsVC;
@property (nonatomic, retain) HighScoresVC *highscoresVC;

- (IBAction)playGameBtnClicked:(id)sender;
- (IBAction)instructionsBtnClicked:(id)sender;
- (IBAction)highScoresBtnClicked:(id)sender;
- (IBAction)optionsBtnClicked:(id)sender;

@end
