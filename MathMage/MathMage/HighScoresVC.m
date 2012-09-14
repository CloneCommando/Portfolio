//
//  HighScoresVC.m
//  MathMage
//
//  Created by Thomas Colligan on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HighScoresVC.h"

@implementation HighScoresVC
@synthesize gameData, additionDataLabel, subtractionDataLabel, multiplicationDataLabel;
@synthesize divisionDataLabel, mixedDataLabel, customDataLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.gameData = [GameData sharedInstance];
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
    
    [self loadScoreData:@"NumberCorrect"];
   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - IBAction Methods
- (IBAction)segmentedControlClicked:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *) sender;
    int selectedIndex = control.selectedSegmentIndex;
    
    // Number Correct Segment was clicked
    if (selectedIndex == 0)
    {
        [self loadScoreData:@"NumberCorrect"];
    }
    // Best Times Segment was clicked index = 1
    else
    {
        [self loadScoreData:@"BestTimes"];
    }
}

# pragma mark - Data Loading methods

- (void) loadScoreData: (NSString *)scoreType
{
    // Get all the high score data that we need to display
    NSString *additionText = [self.gameData getHighScoreText:@"Addition" scoreType:scoreType];
    NSString *subtractionText = [self.gameData getHighScoreText:@"Subtraction" scoreType:scoreType];
    NSString *multiplicationText = [self.gameData getHighScoreText:@"Multiplication" scoreType:scoreType];
    NSString *divisionText = [self.gameData getHighScoreText:@"Division" scoreType:scoreType];
    NSString *mixedText = [self.gameData getHighScoreText:@"Mixed" scoreType:scoreType];
    NSString *customText = [self.gameData getHighScoreText:@"Custom" scoreType:scoreType];
    
    // Change the text labels to display the correct data
    [self.additionDataLabel setText:additionText];
    [self.subtractionDataLabel setText:subtractionText];
    [self.multiplicationDataLabel setText:multiplicationText];
    [self.divisionDataLabel setText:divisionText];
    [self.mixedDataLabel setText:mixedText];
    [self.customDataLabel setText:customText];
}

@end
