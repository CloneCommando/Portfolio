//
//  CustomTestSelectionVC.m
//  MathMage
//
//  Created by Student on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTestSelectionVC.h"

@implementation CustomTestSelectionVC
@synthesize customTestData, scrollView, gameVC, soundManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.customTestData = [CustomTestData sharedInstance];
        self.soundManager = [SoundManager sharedInstance];
        hasCustomTests = YES;
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
    
    // Check to see if there are any custom tests, if not pop up alert
    NSMutableArray *listOfCustomTests = [customTestData getListOfCustomTestsCreated];
    
    // The list is empty meaning you have no custom tests created
    if(listOfCustomTests == nil || [listOfCustomTests count] <= 0)
    {
        hasCustomTests = NO;
        return;
    }
    else
        hasCustomTests = YES;
    
    // Log out the names of the custom tests available
    for (NSString *testName in listOfCustomTests)
    {
        NSLog(@"Custom Test: %@", testName);
    }
    
    // Create buttons from the name of available custom tests
    [self createTestNameButtoms:listOfCustomTests];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.scrollView = nil;
    self.gameVC = nil;
    self.customTestData = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    // No custom tests to choose from, pop up an alert and pop off this view
    if (hasCustomTests == NO)
    {
        UIAlertView  * alert = [[ UIAlertView   alloc ]  initWithTitle : @"No Custom Tests!"   message :@"You have no custom tests to choose from! Go back to the main menu and create one!"  delegate : self   cancelButtonTitle : @"OK" otherButtonTitles : nil ];
        
        [alert  show ];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - Methods that build the UI

- (void) createTestNameButtoms: (NSMutableArray *) testNames
{
    int xPos = (self.view.frame.size.width / 4);
    int yPos = 20;
    int ySpacing = 70;
    int width = 160;
    int height = 40;
    UIButton *button = nil;
    
    // Create a button for each custom test we have
    for (NSString* testName in testNames)
    {
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(customTestSelected:)forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont fontWithName:@"Chalkduster" size:15];
        [button setTitle:testName forState:UIControlStateNormal];
        button.frame = CGRectMake(xPos, yPos, width, height);
        [self.scrollView addSubview:button];
        
        yPos += ySpacing;
    }
    
    // Size the scroll view accordingly
    [self.scrollView setContentSize: CGSizeMake(self.view.frame.size.width, yPos + (ySpacing*2))];
}

- (void) customTestSelected: (id)sender
{
    // Determine which button was clicked through the sender
    NSString *testName = [sender currentTitle];
    NSLog(@"%@ Button was clicked", testName);
    [self.soundManager playSound:ButtonClick];
    
    NSMutableArray *questionsArray = [self.customTestData getCustomTestQuestionArray:testName];
    
    // A custom test to play was chosen, get its questions and create the game
    self.gameVC = [[GameScreenVC alloc] initWithNibName:nil bundle:nil testType:@"Custom" isCustomTest:YES customQuestions:questionsArray];
    
    self.gameVC.title = @"Math Mage";
    [self.navigationController pushViewController:self.gameVC animated:YES];
}

@end
