//
//  HighScoresVC.h
//  MathMage
//
//  Created by Thomas Colligan on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameData.h"

@interface HighScoresVC : UIViewController

@property (nonatomic, strong) GameData *gameData;
@property (nonatomic, strong) IBOutlet UILabel *additionDataLabel;
@property (nonatomic, strong) IBOutlet UILabel *subtractionDataLabel;
@property (nonatomic, strong) IBOutlet UILabel *multiplicationDataLabel;
@property (nonatomic, strong) IBOutlet UILabel *divisionDataLabel;
@property (nonatomic, strong) IBOutlet UILabel *mixedDataLabel;
@property (nonatomic, strong) IBOutlet UILabel *customDataLabel;

- (IBAction)segmentedControlClicked:(id)sender;
- (void) loadScoreData: (NSString *)scoreType;

@end
