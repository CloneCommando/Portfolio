//
//  CustomizedTestVC.h
//  MathMage
//
//  Created by Thomas Colligan on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTestData.h"
#import "SoundManager.h"

@interface CustomizedTestVC : UIViewController
{
    double spacingPerQuestion;
    int numberOfQuestions;
    double startingY;
    double endingY;
    
    NSMutableArray *arrayOfSegmentedControls;
    NSMutableArray *arrayOfLeftTextFields;
    NSMutableArray *arrayOfRightTextFields;
    UIButton *doneButton;
    UITextField *testNameField;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) CustomTestData *customTestData;
@property (nonatomic, strong) SoundManager *soundManager;

- (void) addLabelsToScrollView;
- (void) addTextFieldsToScrollView;
- (void) addSegmentedControls;
- (void) doneCreatingTestBtnClicked: (id)sender;
- (BOOL) checkCutomTestInput;

@end
