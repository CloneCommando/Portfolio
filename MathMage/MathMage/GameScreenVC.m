//
//  GameScreenVC.m
//  MathMage
//
//  Created by Thomas Colligan on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScreenVC.h"

@implementation GameScreenVC
@synthesize mathTest, answerBtn1, answerBtn2, answerBtn3, answerBtn4, questionLabel;
@synthesize timerLabel, timeTillNextQuestion, uiAnimationSpeed, timeSpentAnsweringQuestions;
@synthesize yourHpLabel, enemyHpLabel, gameData, timePerReadjust, exitBtn, soundManager;
@synthesize numOfQuestionsAsked, numOfQuestionsAnsweredCorrectly, answerLabel, titleLabel;
@synthesize timerMode, timerCountdownInterval, timePerQuestion, timePerGameAnimation;
@synthesize spriteAnimator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil testType:(NSString *)testType isCustomTest:(BOOL)isCustomTest customQuestions:(NSMutableArray *)questionsArray
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // Create a new math test based on what type of test the user selected
        self.gameData = [GameData sharedInstance];
        
        // Test will be initalized differently if it is a custom test
        if(isCustomTest == NO)
        {
            self.mathTest = [[MathTest alloc] initWithPlist:testType];
            mathTestType = testType;
        }
        else
        {
            self.mathTest = [[MathTest alloc] initWithArray:questionsArray];
            mathTestType = testType;
        }
        
        // Find out what the difficulty level of the game is
        NSString *gameDifficulty = [self.gameData getGameDifficultyLevel];
        self.soundManager = [SoundManager sharedInstance];
        self.spriteAnimator = [SpriteAnimator sharedInstance];
        
        // Get refrences to the animations
        playerMageAnimation = [self.spriteAnimator getMageNormalCycle];
        enemyMageAnimation = [self.spriteAnimator getEnemyNormalCycle];
        userHealthBar = [self.spriteAnimator getUserHealthBar];
        userLightningAttack = [self.spriteAnimator getUserLightningAttack];
        enemyLightningAttack = [self.spriteAnimator getEnemyLightningAttack];
        userWandExplode = [self.spriteAnimator getUserWandExplode];
        didStartInitialAnimation = NO;
        killTest = NO;
        
        // Change certain variables based on the difficulty
        if([gameDifficulty isEqualToString:@"Easy"])
        {
            self.timePerQuestion = 20.0;
            damagePerEnemyAttack = 10;
        }
        else if([gameDifficulty isEqualToString:@"Normal"])
        {
            self.timePerQuestion = 15.0;
            damagePerEnemyAttack = 15;
        }
        else // Game is in Hard Mode
        {
            self.timePerQuestion = 10.0;
            damagePerEnemyAttack = 20;
        }
        
        // Animation based variables
        self.timePerGameAnimation = 3.0;
        self.timeTillNextQuestion = 3.0;
        self.timePerReadjust = 3.0;
        self.timerCountdownInterval = 0.05;
        halfTimerCountdownInterval = self.timerCountdownInterval / 2;
        self.uiAnimationSpeed = 120;
        
        // General Initalization
        damagePerUserAttack = 10;
        self.timeSpentAnsweringQuestions = 0.0;
        self.numOfQuestionsAsked = 0;
        self.numOfQuestionsAnsweredCorrectly = 0;
        
        // Decide how to display the numbers based on the test type
        if([mathTestType isEqualToString:@"Division"] || [mathTestType isEqualToString:@"Mixed"] || [mathTestType isEqualToString:@"Custom"])
        {
            testUsesDoubleDigits = YES;
        }
        else
        {
            testUsesDoubleDigits = NO;
        }
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
    
    // Get a new math question and load it to be displayed
    [self loadNewMathQuestion:[self.mathTest getNextMathQuestion]];
    
    // Make a timer to count down
    self.timerMode = ReadjustTime;
    timeLeft = self.timePerReadjust;
    timerLabel.text = [NSString stringWithFormat:@"%1.0f sec", self.timePerQuestion];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:self.timerCountdownInterval target:self selector:@selector(timerCountdown:) userInfo:nil repeats:YES];
    
    // Save original x positions of uibuttons and labels for animation
    orgBtn1Rect = self.answerBtn1.frame;
    orgBtn2Rect = self.answerBtn2.frame;
    orgBtn3Rect = self.answerBtn3.frame;
    orgBtn4Rect = self.answerBtn4.frame;
    orgQLabelRect = self.questionLabel.frame;
    orgALabelRect = self.answerLabel.frame;
    orgTimerLabelRect = self.timerLabel.frame;
    orgTitleLabelRect = self.titleLabel.frame;
    orgCloseBtnRect = self.exitBtn.frame;
    orgHealthBarHeight = userHealthBar.frame.size.height;
    
    // Add character sprites
    [self.view addSubview:playerMageAnimation];
    [self.view addSubview:enemyMageAnimation];
    //[self.view addSubview:userHealthBar];
    [self.view addSubview: userLightningAttack];
    [self.view addSubview:enemyLightningAttack];
    [self.view addSubview:userWandExplode];
    
    [userLightningAttack setHidden:YES];
    [enemyLightningAttack setHidden:YES];
    [userWandExplode setHidden:YES];
    
    // Make the animated ui stuff appear on the right hand side off of the screen
    [self animateUI:320 :0];
    [self setButtonsEnabled:FALSE];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.answerBtn1 = nil;
    self.answerBtn2 = nil;
    self.answerBtn3 = nil;
    self.answerBtn4 = nil;
    self.questionLabel = nil;
    self.answerLabel = nil;
    self.timerLabel = nil;
    self.enemyHpLabel = nil;
    self.yourHpLabel = nil;
    self.titleLabel = nil;
    
    playerMageAnimation = nil;
    enemyMageAnimation = nil;
    userHealthBar = nil;
    userLightningAttack = nil;
    enemyLightningAttack = nil;
    userWandExplode = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBActions

-(IBAction)answerBtnClicked:(id)sender
{
    // Determine which button the user clicked for their answer
    NSString *buttonText = [sender currentTitle];
    double answerChosen = [buttonText doubleValue];
    
    // Add how much time was spent answering the question
    self.timeSpentAnsweringQuestions += (self.timePerQuestion - timeLeft);
    
    [self checkUserAnswer:answerChosen];
    buttonText = nil;
}

- (IBAction)exitBtnClicked:(id)sender
{
    timerModeBeforePause = self.timerMode;
    self.timerMode = Paused;
    [self.view setHidden:YES];
    
    // Create an alert to inform the player of how many questions they answered correctly
    NSString *msg = @"Are you sure you wish to exit the game before you finish? You will lose all your progress!";
    
    UIAlertView  * alert = [[ UIAlertView   alloc ]  initWithTitle : @"Exit Test?"   message :msg  delegate : self   cancelButtonTitle : @"Yes" otherButtonTitles : @"Cancel", nil ];
    
    [alert  show ];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    [self.view setHidden:NO];
    // The User clicked the alert view ok button or cancel button when trying to exit prematurely
    if (buttonIndex == 0)
    {
        // Exit the game
        NSLog(@"Yes Alert button was pressed");
        [self.navigationController popViewControllerAnimated:YES];
        
        // Dealloc poiters and invalidate the timer
        [timer invalidate];
        timer = nil;
        self.mathTest = nil;
    }
    else
    {
        // Resume the game
        NSLog(@"Cancel Alert button was pressed");
        self.timerMode = timerModeBeforePause;
    }
}

#pragma mark - General Math Class Methods

-(void)loadNewMathQuestion:(NSString *)question
{
    // No more questions left in the test
    if(question == nil)
    {
        NSLog(@"Completed all questions in the math test!");
        [self testIsFinished];
        return;
    }
    
    NSLog(@"Loading a New Math Question: %@", question);
    
    // Increment the num of questions that have been asked
    self.numOfQuestionsAsked++;
    
    // Set the question text label to match the new question to load
    [self.questionLabel setText:[NSString stringWithFormat:@"%@ =", question]];
    [self.answerLabel setText:@"?"];
    self.answerLabel.textColor = [UIColor whiteColor];
    [self changeTitleLabel:@"Reset"];
    
    // Generate possible answers for the question
    NSMutableArray *answers = [NSMutableArray arrayWithArray:[self.mathTest generateAnswersToQuestion:question]];
    
    // The First num in the array is always the correct answer to the question
    correctAnswer = [[answers objectAtIndex:0] doubleValue]; 
    
    // Put the buttons in an array to make it easier to cycle through them all
    NSMutableArray *buttonsArray = [NSMutableArray arrayWithObjects:answerBtn1,answerBtn2,answerBtn3,answerBtn4, nil];
    
    // Loop through the array until it is empty
    while ([buttonsArray count] > 0) 
    {
        // Generate random num within the bounds of the array
        int rNum = (arc4random()%[buttonsArray count]);
        
        // Assign an answer to a random button
        UIButton *btn = [buttonsArray objectAtIndex:rNum];
        double answer = [[answers objectAtIndex:0] doubleValue];
        
        
        // Assign the number to the button label
        if(testUsesDoubleDigits == YES)
            [btn setTitle:[NSString stringWithFormat:@"%1.2f", answer] forState:UIControlStateNormal];
        else
            [btn setTitle:[NSString stringWithFormat:@"%1.0f", answer] forState:UIControlStateNormal];
        
        // Pop the objects off their array
        [buttonsArray removeObjectAtIndex:rNum];
        [answers removeObjectAtIndex:0];
    }
    
}

-(void)checkUserAnswer:(double)userAnswer
{
    // Check to see if their answer was correct or not, NAN means their time was up
    if (isnan(userAnswer))
    {
        // The timer ran out
        NSLog(@"DID NOT ANSWER QUESTION IN TIME!");
        [self.soundManager playSound:TimeIsUp];
        
        // Animate enemy lightning attack
        [enemyLightningAttack setHidden:NO];
        [enemyLightningAttack startAnimating];
        
        // User gets damaged if they run out of time
        int yourHealthLeft = [[[self yourHpLabel] text] intValue] - damagePerEnemyAttack;
        self.yourHpLabel.text = [NSString stringWithFormat:@"%d", yourHealthLeft];
        [self setUserHealthBar:yourHealthLeft];
        
        [self changeTitleLabel:@"Incorrect"];
        
        // Player was defeated, test is over
        if(yourHealthLeft <= 0)
            [self testIsFinished];
    }
    else if (userAnswer == correctAnswer || (testUsesDoubleDigits && round(userAnswer) == round(correctAnswer)))
    {
        NSLog(@"CORRECT ANSWER!");
        [self.soundManager playSound:CorrectAnswer];
        
        // Animate user lightning attack
        [userLightningAttack setHidden:NO];
        [userLightningAttack startAnimating];
        
        
        // Switch the timer to display the game animations
        self.timerMode = GameAnimation;
        timeLeft = self.timePerGameAnimation;
        
        // Damage the enemy when you get a correct answer
        int enemyHealthLeft = [[[self enemyHpLabel] text] intValue] - damagePerUserAttack;
        self.enemyHpLabel.text = [NSString stringWithFormat:@"%d", enemyHealthLeft];
        
        // Increment how many questions were answered correctly
        self.numOfQuestionsAnsweredCorrectly++;
        
        [self changeTitleLabel:@"Correct"];
        
        // Enemy was defeated, test is over
        if(enemyHealthLeft <= 0)
            [self testIsFinished];
    }
    else
    {
        NSLog(@"INCORRECT ANSWER!");
        [self.soundManager playSound:IncorrectAnswer];
        
        // Animate user's wand exploding
        [userWandExplode setHidden:NO];
        [userWandExplode startAnimating];
        
        // Switch the timer to display the game animations
        self.timerMode = GameAnimation;
        timeLeft = self.timePerGameAnimation;
        
        // User gets damaged if they answer incorrectly
        int yourHealthLeft = [[[self yourHpLabel] text] intValue] - damagePerEnemyAttack;
        self.yourHpLabel.text = [NSString stringWithFormat:@"%d", yourHealthLeft];
        [self setUserHealthBar:yourHealthLeft];
        
        [self changeTitleLabel:@"Incorrect"];
        
        // Player was defeated, test is over
        if(yourHealthLeft <= 0)
            [self testIsFinished];
    }
    
    // Change the label to display the correct answer
    if(testUsesDoubleDigits == YES)
        [self.answerLabel setText:[NSString stringWithFormat:@"%1.2f", correctAnswer]];
    else
        [self.answerLabel setText:[NSString stringWithFormat:@"%1.0f", correctAnswer]];
    
    self.answerLabel.textColor = [UIColor greenColor];
    [self setButtonsEnabled:NO];
    
    NSLog(@"Answer Chosen: %f Correct Answer: %f",userAnswer, correctAnswer);
    
}

// This method is called once every second by the timer
- (void)timerCountdown:(int)totalSeconds
{
    
    // Do nothing if the timer is paused
    if(self.timerMode == Paused)
        return;
    
    // Subtract how much time has passed
    timeLeft -= self.timerCountdownInterval;
    
    if(didStartInitialAnimation == NO)
    {
        [playerMageAnimation startAnimating];
        [enemyMageAnimation startAnimating];
        didStartInitialAnimation = YES;
    }
    
    // Game functions differently depending on the mode of the timer
    switch (self.timerMode) 
    {
        // Giver the user some time to read the question before the timer starts ticking down
        case ReadjustTime:
        {
            // Move the ui slowly to the left back onto the screen
            double xDist = -(self.uiAnimationSpeed * self.timerCountdownInterval);
            [self animateUI:xDist :0];
            
            // UI has reached its designated position
            if(answerBtn1.frame.origin.x <= orgBtn1Rect.origin.x)
            {
                [self resetUIPosition];
                timeLeft = 0;
            }
            
            if(timeLeft <= 0)
            {
                self.timerMode = QuestionCountdown;
                timeLeft = self.timePerQuestion;
                [self setButtonsEnabled:YES];
            }
        }
            break;
        // The typical mode where the timer is counting down with how much time you have left to
            // answer a math question
        case QuestionCountdown:
        {
            // Update the label with how much time is left
            timerLabel.text = [NSString stringWithFormat:@"%1.0f sec", timeLeft];
            
            // Timer countdown click plays once every second
            double rounded = floor(timeLeft);
            
            if(timeLeft < rounded - halfTimerCountdownInterval || timeLeft > rounded + halfTimerCountdownInterval)
                [self.soundManager playSound:TimerClick];
            
            // Time ran out before question was answered
            if(timeLeft <= 0)
            {
                // Spent the full time trying to answer a question
                self.timeSpentAnsweringQuestions += self.timePerQuestion;
                
                // Make sure the timer label displays 0.00 as the time left
                timerLabel.text = @"0 sec";
                
                // Inform checkUserAnswer that time ran out before question was answered
                [self checkUserAnswer:NAN];
                
                // Switch the timer mode to animate the results i.e.)Wizard casting a spell
                self.timerMode = GameAnimation;
                timeLeft = self.timePerGameAnimation;
                
            }
        }
            break;
        
        // The timer countdown which allows sprite animations to occur
        case GameAnimation:
        {
            if(timeLeft <= 0)
            {
                [userLightningAttack stopAnimating];
                [userLightningAttack setHidden:YES];
                
                [enemyLightningAttack stopAnimating];
                [enemyLightningAttack setHidden:YES];
                
                [userWandExplode stopAnimating];
                [userWandExplode setHidden:YES];
                
                if(killTest == YES)
                {
                    [self killMathTest];
                    return;
                }
                
                self.timerMode = NextQuestion;
                timeLeft = self.timeTillNextQuestion;
            }
        }
            break;
            
        // The timer countdown which allows the UI to animate to the next question    
        case NextQuestion:
        {
            
            // Move the ui slowly to the left off of the screen
            double xDist = -(self.uiAnimationSpeed * self.timerCountdownInterval);
            [self animateUI:xDist :0];
            
            if(timeLeft <= 0)
            {
                self.timerMode = ReadjustTime;
                timeLeft = self.timePerReadjust;
                
                // Make the animated ui stuff appear on the right hand side off of the screen
                [self animateUI:640 :0];
                
                // Load the next math question
                [self loadNewMathQuestion:[self.mathTest getNextMathQuestion]];
                timerLabel.text = [NSString stringWithFormat:@"%1.0f sec", self.timePerQuestion];
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)testIsFinished
{
    // Set the timer to show the final game animation
    self.timerMode = GameAnimation;
    timeLeft = self.timePerGameAnimation;
    killTest = YES;
}

- (void)killMathTest
{
    NSLog(@"Test is Finished, ending game and saving data");
    // Save any data that is new and needs to be updated
    [self saveGameData];
    
    // Create an alert to inform the player of how many questions they answered correctly
    NSString *msg = [NSString stringWithFormat:@"You answered %d / %d questions correctly!", self.numOfQuestionsAnsweredCorrectly, self.numOfQuestionsAsked];
    
    UIAlertView  * alert = [[ UIAlertView   alloc ]  initWithTitle : @"Test is Over!"   message :msg  delegate : self   cancelButtonTitle : @"OK" otherButtonTitles : nil ];
    
    [alert  show ];
    [self.navigationController popViewControllerAnimated:YES];
    
    // Dealloc poiters and invalidate the timer
    [timer invalidate];
    timer = nil;
    self.mathTest = nil;
}

- (void)saveGameData
{
    NSLog(@"Starting to save new game data");
    
    [self.gameData saveNewHighScore:mathTestType newNumOfCorrectAnswers:numOfQuestionsAnsweredCorrectly newNumOfQuestionsCompleted:numOfQuestionsAsked newBestTime:self.timeSpentAnsweringQuestions];
    
    //self.gameData = nil;
}

// Change the color of the title label based on a status
// Status: Correct, Incorrect, Reset
- (void)changeTitleLabel:(NSString *)status
{
    if([status isEqualToString:@"Correct"])
    {
        titleLabel.textColor = [UIColor greenColor];
    }
    else if([status isEqualToString:@"Incorrect"])
    {
        titleLabel.textColor = [UIColor redColor];
    }
    else
    {
        titleLabel.textColor = [UIColor whiteColor];
    }
}

// Resets the position of all the ui pieces that were animated to move
- (void)resetUIPosition
{
    self.answerBtn1.frame = orgBtn1Rect;
    self.answerBtn2.frame = orgBtn2Rect;
    self.answerBtn3.frame = orgBtn3Rect;
    self.answerBtn4.frame = orgBtn4Rect;
    self.questionLabel.frame = orgQLabelRect;
    self.answerLabel.frame = orgALabelRect;
    self.timerLabel.frame = orgTimerLabelRect;
    self.titleLabel.frame = orgTitleLabelRect;
    self.exitBtn.frame = orgCloseBtnRect;
}

// Move the specified UI a certain distance
- (void)animateUI: (double)xDist: (double)yDist
{
    // Put all the UI stuff to animate in an array to make things easier
    NSMutableArray *uiAnimationArray = [NSMutableArray arrayWithObjects:answerBtn1,answerBtn2,answerBtn3,answerBtn4,questionLabel, answerLabel, timerLabel, titleLabel, exitBtn, nil];
    
    CGRect newFrame;
    UIView *newItem;
    
    // Animate the UI Buttons and labels sliding to the left
    for (id item in uiAnimationArray)
    {
        newItem = ((UIView *) item);
        newFrame = newItem.frame;
        newFrame.origin.x += xDist;
        newFrame.origin.x += yDist;
        newItem.frame = newFrame;
    }
}

// A helper method to make the answer buttons enabled or disabled
- (void)setButtonsEnabled: (BOOL) isEnabled
{
    if(isEnabled)
        NSLog(@"Answer Buttons are Enabled");
    else
        NSLog(@"Answer Buttons are Disabled");
    
    [answerBtn1 setEnabled:isEnabled];
    [answerBtn2 setEnabled:isEnabled];
    [answerBtn3 setEnabled:isEnabled];
    [answerBtn4 setEnabled:isEnabled];
    [exitBtn setEnabled:isEnabled];

}

- (void)setUserHealthBar: (int) currentHealth
{
    float width = userHealthBar.frame.size.width;
    float xPos = userHealthBar.frame.origin.x;
    float yPos = userHealthBar.frame.origin.y;
    float newHeight = ((double)currentHealth/(double)100) * orgHealthBarHeight;
    
    //CGRect cropImage = CGRectMake(0, orgHealthBarHeight, width, -newHeight);
    //CGImageRef imageRef = CGImageCreateWithImageInRect([userHealthBar.image CGImage], cropImage);
    
    //[userHealthBar setImage:[UIImage imageWithCGImage:imageRef]];
    [userHealthBar setFrame:CGRectMake(xPos, yPos, width, newHeight)];
    [userHealthBar setNeedsDisplay];
    //CGImageRelease(imageRef);
}

@end
