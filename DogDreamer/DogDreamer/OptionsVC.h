//
//  OptionsVC.h
//  DogDreamer
//
//  Created by Thomas Colligan on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavedData.h"
#import "SoundManager.h"

@interface OptionsVC : UIViewController
{
    SavedData *savedData;
    SoundManager *soundManager;
}

@property (nonatomic, strong) IBOutlet UISegmentedControl *difficultyLvlControl;
@property (nonatomic, strong) IBOutlet UISlider *audioLvlSlider;
@property (nonatomic, strong) IBOutlet UILabel *audioLvlLabel;

- (IBAction)backBtnClicked:(id)sender;
- (IBAction)audioSliderValueChanged:(id)sender;

@end
