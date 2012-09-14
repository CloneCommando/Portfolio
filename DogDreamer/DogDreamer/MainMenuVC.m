//
//  MainMenuVC.m
//  DogDreamer
//
//  Created by Thomas Colligan on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuVC.h"

@implementation MainMenuVC
@synthesize gameVC, instructionsVC, optionsVC, highscoresVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        didRotateLabels = NO;
        
        if (self.gameVC == nil)
            self.gameVC = [[GameVC alloc] initWithNibName:nil bundle:nil];
        
        if (self.instructionsVC == nil)
            self.instructionsVC = [[InstructionsVC alloc] initWithNibName:nil bundle:nil];
        
        if (self.optionsVC == nil)
            self.optionsVC = [[OptionsVC alloc] initWithNibName:nil bundle:nil];
        
        if(self.highscoresVC == nil)
            self.highscoresVC = [[HighScoresVC alloc] initWithNibName:nil bundle:nil];
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
    
    // Rotate button labels to match the orientation of the buttons
    if (didRotateLabels == NO)
    {
        didRotateLabels = YES;
        playBtnLabel.transform = CGAffineTransformMakeRotation(-M_PI / 10);
        instructionsBtnLabel.transform = CGAffineTransformMakeRotation(-M_PI / 10);
        highScoresLabel.transform = CGAffineTransformMakeRotation(-M_PI / 10);
        optionsLabel.transform = CGAffineTransformMakeRotation(-M_PI / 10);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

# pragma mark - IBAction Methods

- (IBAction)playGameBtnClicked:(id)sender
{
    NSLog(@"PlayGameBtn was Clicked");
    self.gameVC = [[GameVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:self.gameVC animated:YES];
}

- (IBAction)instructionsBtnClicked:(id)sender
{
    NSLog(@"InstructionsBtn was Clicked");
    [self.navigationController pushViewController:self.instructionsVC animated:YES];
}

- (IBAction)highScoresBtnClicked:(id)sender
{
    NSLog(@"HighScoresBtn was Clicked");
    [self.navigationController pushViewController:self.highscoresVC animated:YES];
}

- (IBAction)optionsBtnClicked:(id)sender
{
    NSLog(@"OptionsBtn was Clicked");
    [self.navigationController pushViewController:self.optionsVC animated:YES];
}

@end
