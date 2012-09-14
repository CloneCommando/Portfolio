//
//  GameVC.m
//  DogDreamer
//
//  Created by Thomas Colligan on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameVC.h"


@implementation GameVC
@synthesize characterDogRef;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) 
    {
        gameLevel = [[GameLevel alloc] init];
        movementController = [[Controls alloc] init];
        soundManager = [SoundManager sharedInstance];
        [self reset];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];

    // Timer controls the main game loop
    timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
    
    // Add the dog and controls to the world
    [gameLevel setDisplayView:self.view];
    [movementController setDisplayView:self.view];
    characterDogRef = [gameLevel getCharacterDog];
    
    // Create the timer label that will count down
    timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(310, 5, 160.0, 40.0)];
    timerLabel.text = [NSString stringWithFormat:@"Time Left: %1.0f sec", mainGameTimeAmount];
    timerLabel.textColor = [UIColor redColor];
    timerLabel.font = [UIFont fontWithName:@"Optima" size:17];
    [timerLabel setFont: [UIFont boldSystemFontOfSize:17]];
    timerLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:timerLabel];
    
    // Create the label that shows how many bones have been collected
    bonesCollectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200.0, 40.0)];
    bonesCollectedLabel.text = [NSString stringWithFormat:@"Bones Collected: %d", numOfBonesCollected];
    bonesCollectedLabel.textColor = [UIColor whiteColor];
    bonesCollectedLabel.font = [UIFont fontWithName:@"Optima" size:17];
    [bonesCollectedLabel setFont: [UIFont boldSystemFontOfSize:17]];
    bonesCollectedLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bonesCollectedLabel];
    
    // Create the label that prompts the user
    introLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 100, 480.0, 40.0)];
    introLabel.text = @"Ready?";
    introLabel.textColor = [UIColor greenColor];
    introLabel.font = [UIFont fontWithName:@"Optima" size:32];
    [introLabel setFont: [UIFont boldSystemFontOfSize:32]];
    introLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:introLabel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    // The view appeared, start the intro
    timerMode = Intro;
    timeLeft = introTimeAmount;
    [soundManager playSound:BackgroundMusic];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - Game Loop that runs every frame
-(void)gameLoop
{
    // Quick Exit if timer is paused
    if (timerMode == Paused)
        return;
    
    // Update the timer
    timeLeft -= timerInterval;
    
    switch (timerMode)
    {
        case Intro:
        {
            [gameLevel update];
            
            if (timeLeft <= 0.0)
            {
                timerMode = MainGame;
                timeLeft = mainGameTimeAmount;
                introLabel.text = @"GO!";
            }
        }
            break;
            
        case MainGame:
        {
            [self checkControllerInput];
            [gameLevel update];
            
            // Get rid of the intro label if enough time has passed
            if (didKillIntroLabel == NO && timeLeft < mainGameTimeAmount - 1)
            {
                didKillIntroLabel = YES;
                [introLabel setHidden:YES];
            }
            
            if (timeLeft <= 0.0)
            {
                timerMode = GameOver;
                timeLeft = gameOverTimeAmount;
                timerLabel.text = @"Time Left: 0 sec";
            }
            else
            {
                timerLabel.text = [NSString stringWithFormat:@"Time Left: %1.0f sec", timeLeft];
            }
            
            // Update Bone counter label if we need to
            if ([gameLevel getNumOfBonesCollected] > numOfBonesCollected)
            {
                numOfBonesCollected = [gameLevel getNumOfBonesCollected];
                bonesCollectedLabel.text = [NSString stringWithFormat:@"Bones Collected: %d", numOfBonesCollected];
            }
        }
            break;
            
        case GameOver:
        {
            [gameLevel update];
            [characterDogRef changeAnimation:SitStill];
            
            if (timeLeft <= 0.0)
            {
                // Kill the timer
                timerMode = Paused;
                timer = nil;
                
                // Pop up a message to the user
                NSString *msg = [NSString stringWithFormat:@"You Collected %d Dog Bones!", numOfBonesCollected];
                UIAlertView  * alert = [[ UIAlertView   alloc ]  initWithTitle : @"Game Over!"   message :msg  delegate : self   cancelButtonTitle : @"OK" otherButtonTitles : nil ];
                
                [alert  show ];
                [gameLevel saveGameResults];
            }
        }
            break;
            
        default:
            break;
    }
    

}

- (void) checkControllerInput
{
    // Move in different directions depending on which arrow is held
    if([movementController isUpArrowHeld])
    {
        [characterDogRef changeAnimation:Jump];
    }
    else if ([movementController isRightArrowHeld])
    {
        [characterDogRef changeAnimation:RunRight];
    }
    else if ([movementController isLeftArrowHeld])
    {
        [characterDogRef changeAnimation:RunLeft];
    }
    else
    {
        [characterDogRef changeAnimation:SitStill];
    }
}

// Reset all the class values to how they are at the beginning
- (void) reset
{
    NSLog(@"Resetting GameVC Values");
    timerInterval = (1.0 / 60.0);
    introTimeAmount = 3.5;
    mainGameTimeAmount = [gameLevel getMainGameTimeAmount];
    gameOverTimeAmount = 2.5;
    
    timerMode = Paused;
    timeLeft = introTimeAmount;
    
    numOfBonesCollected = 0;
    didKillIntroLabel = NO;
    
    if(introLabel != nil)
    {
        introLabel.text = @"Ready?";
        [introLabel setHidden:NO];
    }
    
    if(timerLabel != nil)
    {
        timerLabel.text = [NSString stringWithFormat:@"Time Left: %1.0f sec", mainGameTimeAmount];
    }
    
    if (bonesCollectedLabel != nil)
    {
        bonesCollectedLabel.text = [NSString stringWithFormat:@"Bones Collected: %d", numOfBonesCollected];
    }
    
    //[gameLevel reset];
}

// Called when alert at the end of the game is dismissed
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	// Ok Button on Alert was Pressed
	if (buttonIndex == 0) 
    {
        NSLog(@"Resetting and Popping GameVC off of Navigation Stack");
        [soundManager stopSound:BackgroundMusic];
        [self reset];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
