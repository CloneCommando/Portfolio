//
//  OptionsVC.h
//  MathMage
//
//  Created by Thomas Colligan on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameData.h"
#import "SoundManager.h"

@interface OptionsVC : UIViewController

@property (nonatomic, strong) GameData *gameData;
@property (nonatomic, strong) SoundManager *soundManager;
@property (nonatomic, strong) IBOutlet UISegmentedControl *difficultyControl;
@property (nonatomic, strong) IBOutlet UISlider *audioSlider;
@property (nonatomic, strong) IBOutlet UILabel *audioLevelLabel;

-(IBAction)audioSliderChanged:(id)sender;

@end
