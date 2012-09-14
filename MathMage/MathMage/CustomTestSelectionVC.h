//
//  CustomTestSelectionVC.h
//  MathMage
//
//  Created by Student on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTestData.h"
#import "GameScreenVC.h"
#import "SoundManager.h"

@interface CustomTestSelectionVC : UIViewController
{
    BOOL hasCustomTests;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) CustomTestData *customTestData;
@property (nonatomic, strong) GameScreenVC *gameVC;
@property (nonatomic, strong) SoundManager *soundManager;

- (void) createTestNameButtoms: (NSMutableArray *) testNames;
- (void) customTestSelected: (id)sender;

@end
