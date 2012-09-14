//
//  TestSelectionVC.m
//  MathMage
//
//  Created by Thomas Colligan on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestSelectionVC.h"

@implementation TestSelectionVC
@synthesize gameVC, customSelectionVC, soundManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

-(IBAction)btnClicked:(id)sender
{
    // Determine which button was clicked through the sender
    NSString *buttonName = [sender currentTitle];
    NSLog(@"%@ Button was clicked", buttonName);
    
    // Play clicking sound
    [self.soundManager playSound:ButtonClick];
    
    // If it is a customized test we pop on a different screen that lets you select
    // From a list of customized tests you have created
    if([buttonName isEqualToString:@"Customized"])
    {
        if(self.customSelectionVC == nil)
        {
            self.customSelectionVC = [[CustomTestSelectionVC alloc] initWithNibName:nil bundle:nil];
            self.customSelectionVC.title = @"Custom Tests";
        }
        
        [self.navigationController pushViewController:self.customSelectionVC animated:YES];
        return;
    }
    
    // Pop up the main game screen where you actually play the game
    self.gameVC = [[GameScreenVC alloc] initWithNibName:nil bundle:nil testType:buttonName isCustomTest:NO customQuestions:nil];
    
    self.gameVC.title = @"Math Mage";
    [self.navigationController pushViewController:self.gameVC animated:YES];
}

@end
