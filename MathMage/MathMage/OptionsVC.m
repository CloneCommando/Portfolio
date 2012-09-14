//
//  OptionsVC.m
//  MathMage
//
//  Created by Thomas Colligan on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OptionsVC.h"

@implementation OptionsVC
@synthesize gameData, difficultyControl, audioSlider, audioLevelLabel, soundManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.gameData = [GameData sharedInstance];
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
    
    // Set the audio slider and label to the right value
    [self.audioSlider setValue:[self.gameData getGameAudioLevel]];
    [self.audioLevelLabel setText:[NSString stringWithFormat:@"%1.2f", audioSlider.value]];
    
    // Set the control to the correct difficulty level
    NSString *difficultyLevel = [self.gameData getGameDifficultyLevel];
    
    if ([difficultyLevel isEqualToString:@"Easy"])
        [self.difficultyControl setSelectedSegmentIndex:0];
    else if ([difficultyLevel isEqualToString:@"Normal"])
        [self.difficultyControl setSelectedSegmentIndex:1];
    else if ([difficultyLevel isEqualToString:@"Hard"])
        [self.difficultyControl setSelectedSegmentIndex:2];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidDisappear:(BOOL)animated
{
    // Save which difficulty level the user has selected
    switch (difficultyControl.selectedSegmentIndex) 
    {
        case 0:
            [self.gameData setGameDifficultyLevel:@"Easy"];
            break;
        case 1:
            [self.gameData setGameDifficultyLevel:@"Normal"];
            break;
        case 2:
            [self.gameData setGameDifficultyLevel:@"Hard"];
            break;
            
        default:
            break;
    }
    
    // Save the audio level the user selected
    [self.gameData setGameAudioLevel:audioSlider.value];
    [self.soundManager setSoundVolume:audioSlider.value];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction Methods

-(IBAction)audioSliderChanged:(id)sender
{
    [self.audioLevelLabel setText:[NSString stringWithFormat:@"%1.2f", audioSlider.value]];
    [self.soundManager setSoundVolume:audioSlider.value];
    [self.soundManager playSound:CorrectAnswer];
}

@end
