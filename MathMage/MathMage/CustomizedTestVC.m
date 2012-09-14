//
//  CustomizedTestVC.m
//  MathMage
//
//  Created by Thomas Colligan on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomizedTestVC.h"

@implementation CustomizedTestVC
@synthesize scrollView, customTestData, soundManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        spacingPerQuestion = 75;
        numberOfQuestions = 20;
        startingY = 75;
        
        arrayOfLeftTextFields = [[NSMutableArray alloc] init];
        arrayOfRightTextFields = [[NSMutableArray alloc] init];
        arrayOfSegmentedControls = [[NSMutableArray alloc] init];
        
        self.customTestData = [CustomTestData sharedInstance];
        self.soundManager = [SoundManager sharedInstance];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addLabelsToScrollView];
    [self addTextFieldsToScrollView];
    [self addSegmentedControls];
    [self.scrollView setContentSize: CGSizeMake(self.view.frame.size.width, endingY + (spacingPerQuestion*5))];
    
    // Add a doneCreatingTest button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self 
               action:@selector(doneCreatingTestBtnClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Done Creating Test" forState:UIControlStateNormal];
    button.frame = CGRectMake((self.view.frame.size.width / 4), endingY+ spacingPerQuestion, 160.0, 40.0);
    [self.scrollView addSubview:button];
    
    // Add a text field to enter the name of the custom test
    testNameField = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2.5), endingY, 150.0, 35.0)];
    
    testNameField.borderStyle = UITextBorderStyleRoundedRect;
    testNameField.textColor = [UIColor whiteColor];
    testNameField.font = [UIFont fontWithName:@"Chalkduster" size:17];
    testNameField.placeholder = @"";  
    testNameField.backgroundColor = [UIColor clearColor]; 
    testNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    testNameField.keyboardType = UIKeyboardTypeAlphabet; 
    testNameField.returnKeyType = UIReturnKeyDone;
    
    [testNameField setDelegate:(id)self];
    [self.scrollView addSubview:testNameField];
    
    // Add a label to idenfity the text field
    UILabel *testTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, endingY, 160.0, 40.0)];
    testTitleLabel.text = @"Test Name:";
    testTitleLabel.textColor = [UIColor whiteColor];
    testTitleLabel.font = [UIFont fontWithName:@"Chalkduster" size:17];
    testTitleLabel.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:testTitleLabel];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrollView = nil;
    arrayOfLeftTextFields = nil;
    arrayOfRightTextFields = nil;
    arrayOfSegmentedControls = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Methods that generate labels and selectors

- (void) addLabelsToScrollView
{
    UILabel *myLabel;
    int xPos = 15;
    int yPos =startingY;
    int width = 50;
    int height = 25;
    
    for (int i = 1; i <= numberOfQuestions; i++)
    {
        myLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
        myLabel.text = [NSString stringWithFormat:@"Q%d:",i];
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.textColor = [UIColor whiteColor];
        myLabel.font = [UIFont fontWithName:@"Chalkduster" size:17];
        [self.scrollView addSubview:myLabel];
        
        yPos += spacingPerQuestion;
        
        if(i == numberOfQuestions)
            endingY = yPos;
    }
}

- (void) addTextFieldsToScrollView
{
    UITextField *myTextField;
    int xPos = 60;
    int yPos =startingY;
    int width = 50;
    int height = 30;
    int spacingBetweenTextViews = 190;
    
    for (int i = 1; i <= numberOfQuestions; i++)
    {
        
        for (int j = 1; j <= 2; j++)
        {
            if (j == 1)
                myTextField = [[UITextField alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
            else
                myTextField = [[UITextField alloc] initWithFrame:CGRectMake(xPos + spacingBetweenTextViews, yPos, width, height)];
            
            myTextField.borderStyle = UITextBorderStyleRoundedRect;
            myTextField.textColor = [UIColor whiteColor];
            myTextField.font = [UIFont fontWithName:@"Chalkduster" size:15]; 
            myTextField.placeholder = @"";  
            myTextField.backgroundColor = [UIColor clearColor]; 
            myTextField.textColor = [UIColor whiteColor];
            myTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            myTextField.keyboardType = UIKeyboardTypeNumberPad; 
            myTextField.returnKeyType = UIReturnKeyDone;
            
            [myTextField setDelegate:(id)self];
            [self.scrollView addSubview:myTextField];
            
            // Depending on left or right position, add the text field to the correct array
            if(j == 1)
                [arrayOfLeftTextFields addObject:myTextField];
            else
                [arrayOfRightTextFields addObject:myTextField];
        }

        
        yPos += spacingPerQuestion;
    }
}

- (void) addSegmentedControls
{
    UISegmentedControl *myControl;
    int xPos = 130;
    int yPos =startingY - 5;
    int width = 100;
    int height = 40;
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"+", @"-", @"*", @"/", nil];
    
    for (int i = 1; i <= numberOfQuestions; i++)
    {
        myControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        myControl.frame = CGRectMake(xPos, yPos, width, height);
        myControl.segmentedControlStyle = UISegmentedControlStylePlain;
        myControl.selectedSegmentIndex = 0;
        
        // [segmentedControl addTarget:self action:@selector(pickOne:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:myControl];
        [arrayOfSegmentedControls addObject:myControl];
        
        yPos += spacingPerQuestion;
    }
}

// Done button on the keyboard was pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    
    // Dismiss the keyboard
	[textField resignFirstResponder];
    
	return YES;
    
}

// Method called when user presses the button indicating that they have finished creating their custom test
- (void) doneCreatingTestBtnClicked: (id)sender
{
    NSLog(@"Done Creating Test Button Was Clicked");
    [self.soundManager playSound:ButtonClick];
    
    BOOL passedCheck = [self checkCutomTestInput];
    
    if (passedCheck == NO)
    {
        NSLog(@"Custom Test Creations did not pass the required checks!");
        
        UIAlertView  * alert = [[ UIAlertView   alloc ]  initWithTitle : @"Need More Info!"   message :@"You did not fill in all the questions or didnt name the test! Make sure you fill everything out!"  delegate : self   cancelButtonTitle : @"OK" otherButtonTitles : nil ];
        
        [alert  show ];
    }
    else
    {
        NSLog(@"Custom Test Passed all of the required checks!");
        
        // Combine all of the arrays into a single string array that is easier to parse
        NSMutableArray *questionsArray = [[NSMutableArray alloc] init];
        NSString *leftNumber = nil;
        NSString *rightNumber = nil;
        UISegmentedControl *operationControl = nil;
        NSString *mathOperator = nil;
        NSString *myQuestion = nil;
        
        for (int i = 0; i < [arrayOfLeftTextFields count]; i++)
        {
            leftNumber = ((UITextField *)[arrayOfLeftTextFields objectAtIndex:i]).text;
            rightNumber = ((UITextField *)[arrayOfRightTextFields objectAtIndex:i]).text;
            operationControl = [arrayOfSegmentedControls objectAtIndex:i];
            mathOperator = nil;
            
            // Determine which operator to use for the question based on the segment index
            switch (operationControl.selectedSegmentIndex)
            {
                case 0:
                    mathOperator = @"+";
                    break;
                    
                case 1:
                    mathOperator = @"-";
                    break;
                    
                case 2:
                    mathOperator = @"*";
                    break;
                    
                case 3:
                    mathOperator = @"/";
                    break;
                    
                default:
                    break;
                    
            }
            
            // Add all the info onto the array
            myQuestion = [NSString stringWithFormat:@"%@ %@ %@", leftNumber, mathOperator, rightNumber];
            [questionsArray addObject:myQuestion];
        }
        
        // Send the data to CustomTestData to be saved to a plist
        NSLog(@"Saving the custom test %@ to a plist", testNameField.text);
        [self.customTestData saveNewCustomTest:testNameField.text questionsArray:questionsArray];
        
        // Dont need the data in these arrays any more
        arrayOfLeftTextFields = nil;
        arrayOfRightTextFields = nil;
        arrayOfSegmentedControls = nil;
        
        // Make an alert to let the user know that their test was saved
        NSString *msg = [NSString stringWithFormat:@"Successfully saved custom test %@!", testNameField.text];
        UIAlertView  * alert = [[ UIAlertView   alloc ]  initWithTitle : @"Test Created!"   message :msg  delegate : self   cancelButtonTitle : @"OK" otherButtonTitles : nil ];
        
        [alert  show ];
        
        // We are done with this screen, pop it off the view
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// Checks the user input of the custom test to make sure that nothing was left out
- (BOOL) checkCutomTestInput
{
    // Check to make sure each text field has a number in it
    for(UITextField *field in arrayOfLeftTextFields)
    {
        if (field.text == nil)
            return NO;
    }
    
    for(UITextField *field in arrayOfRightTextFields)
    {
        if (field.text == nil)
            return NO;
    }
    
    // Check to make sure the test has been named
    if (testNameField.text == nil)
        return NO;
    
    return YES;
}

@end
