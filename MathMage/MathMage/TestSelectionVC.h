//
//  TestSelectionVC.h
//  MathMage
//
//  Created by Thomas Colligan on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameScreenVC.h"
#import "CustomTestSelectionVC.h"

@interface TestSelectionVC : UIViewController

@property (nonatomic, strong) GameScreenVC *gameVC;
@property (nonatomic, strong) SoundManager *soundManager;
@property (nonatomic, strong) CustomTestSelectionVC *customSelectionVC;

-(IBAction)btnClicked:(id)sender;

@end
