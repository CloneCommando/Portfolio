//
//  HighScoresVC.h
//  DogDreamer
//
//  Created by Thomas Colligan on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavedData.h"

@interface HighScoresVC : UIViewController
{
    IBOutlet UILabel *easyScoreLabel;
    IBOutlet UILabel *normalScoreLabel;
    IBOutlet UILabel *hardScoreLabel;
     SavedData *savedData;
}

- (IBAction)backBtnClicked:(id)sender;

@end
