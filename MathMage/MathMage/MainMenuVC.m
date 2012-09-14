//
//  MainMenuVC.m
//  MathMage
//
//  Created by Thomas Colligan on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuVC.h"

@implementation MainMenuVC
@synthesize gameData, soundManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.gameData = [GameData sharedInstance];
        self.soundManager = [SoundManager sharedInstance];
        
        // Initalize the audio level to whatever it was saved as before
        double audioLevel = [self.gameData getGameAudioLevel];
        [self.soundManager setSoundVolume:audioLevel];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction Methods

-(IBAction)playBtnClicked:(id)sender
{
    NSLog(@"PlayBtn was Clicked - Pushing testSelectorVC onto NavigationController Stack");
    
    // Push on the next view that lets the user choose what kind of test the want to take
    TestSelectionVC *testSelectorVC = [[TestSelectionVC alloc] initWithNibName:@"TestSelectionVC" bundle:nil];
    
    testSelectorVC.title = @"Choose A Test!";
    [soundManager playSound:ButtonClick];
    [self.navigationController pushViewController:testSelectorVC animated:YES];
}

-(IBAction)customizeBtnClicked:(id)sender
{
    NSLog(@"CustomizeTestsBtn was Clicked - Pushing customizedTestVC onto NavigationController Stack");
    
    // Push on the next view that lets us create a customized math test
    CustomizedTestVC *customizedTestVC = [[CustomizedTestVC alloc] initWithNibName:@"CustomizedTestVC" bundle:nil];
    
    customizedTestVC.title = @"Customized Test";
    [soundManager playSound:ButtonClick];
    [self.navigationController pushViewController:customizedTestVC animated:YES];
}

-(IBAction)highScoresBtnClicked:(id)sender
{
    NSLog(@"HighScoresBtn was Clicked - Pushing highScoresVC onto NavigationController Stack");
    
    // Push on the next view that lets us see the player's high scores
    HighScoresVC *highScoresVC = [[HighScoresVC alloc] initWithNibName:@"HighScoresVC" bundle:nil];
    
    highScoresVC.title = @"Customized Test";
    [soundManager playSound:ButtonClick];
    [self.navigationController pushViewController:highScoresVC animated:YES];
}

-(IBAction)optionsBtnClicked:(id)sender
{
    NSLog(@"OptionsBtn was Clicked - Pushing optionsVC onto NavigationController Stack");
    
    // Push on the next view that lets us change the game's options
    OptionsVC *optionVC = [[OptionsVC alloc] initWithNibName:@"OptionsVC" bundle:nil];
    
    optionVC.title = @"Options";
    [soundManager playSound:ButtonClick];
    [self.navigationController pushViewController:optionVC animated:YES];
}

-(IBAction)instructionsBtnClicked:(id)sender
{
     NSLog(@"InstructionsBtn was Clicked - Pushing instructionsVC onto NavigationController Stack");
    
    // Push on the next view that show the game's instructions
    InstructionsVC *instructionsVC = [[InstructionsVC alloc] initWithNibName:@"InstructionsVC" bundle:nil];
    
    instructionsVC.title = @"Instructions";
    [soundManager playSound:ButtonClick];
    [self.navigationController pushViewController:instructionsVC animated:YES];
}

@end
