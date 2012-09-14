//
//  OptionsVC.m
//  DogDreamer
//
//  Created by Thomas Colligan on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OptionsVC.h"

#define Easy 0
#define Normal 1
#define Hard 2

@implementation OptionsVC
@synthesize audioLvlLabel, audioLvlSlider, difficultyLvlControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        savedData = [SavedData sharedInstance];
        soundManager = [SoundManager sharedInstance];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    double audioLvl = [savedData getAudioLevel];
    NSString *difficultyLvl = [savedData getDifficultyLevel];
    
    // Set the audio level to its saved value
    [audioLvlSlider setValue:audioLvl];
    [audioLvlLabel setText:[NSString stringWithFormat:@"%1.2f", audioLvlSlider.value]];
    
    // Set the Difficulty Control Segment to its saved value
    if (difficultyLvl != nil)
    {
        if ([difficultyLvl isEqualToString:@"Easy"])
            [self.difficultyLvlControl setSelectedSegmentIndex:Easy];
        else if ([difficultyLvl isEqualToString:@"Normal"])
            [self.difficultyLvlControl setSelectedSegmentIndex:Normal];
        else if ([difficultyLvl isEqualToString:@"Hard"])
            [self.difficultyLvlControl setSelectedSegmentIndex:Hard];
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    // Save which difficulty level the user has selected
    switch (difficultyLvlControl.selectedSegmentIndex) 
    {
        case Easy:
            [savedData saveDifficultyLevel:@"Easy"];
            break;
            
        case Normal:
            [savedData saveDifficultyLevel:@"Normal"];
            break;
            
        case Hard:
            [savedData saveDifficultyLevel:@"Hard"];
            break;
            
        default:
            break;
    }
    
    // Save the audio level the user selected
    [savedData saveAudioLevel:audioLvlSlider.value];
    [soundManager setSoundVolume:audioLvlSlider.value];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - IBAction Methods

- (IBAction)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)audioSliderValueChanged:(id)sender
{
    [soundManager setSoundVolume:audioLvlSlider.value];
    [self.audioLvlLabel setText:[NSString stringWithFormat:@"%1.2f", audioLvlSlider.value]];
    [soundManager playSound:DogJump];
}
@end
