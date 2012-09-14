//
//  Controls.m
//  DogDreamer
//
//  Created by Thomas Colligan on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Controls.h"

#define LeftArrowBtn -1
#define UpArrowBtn 0
#define RightArrowBtn 1

@implementation Controls

- (id) init
{
    self = [super init];
    
    if (self)
    {
        arrowThatIsHeld = -1;
        leftArrowIsHeld = NO;
        upArrowIsHeld = NO;
        rightArrowIsHeld = NO;
    }
    
    return self;
}

- (void) setDisplayView: (UIView *) view
{
    displayView = view;
    [self loadArrowButtons];
}

# pragma marke Accessors and Mutators
- (int) getArrowThatIsHeld
{
    return arrowThatIsHeld;
}

- (BOOL) isLeftArrowHeld
{
    return leftArrowIsHeld;
}

- (BOOL) isRightArrowHeld
{
    return rightArrowIsHeld;
}

- (BOOL) isUpArrowHeld
{
    return upArrowIsHeld;
}

# pragma mark - Creat the Arrow UI

// Loads and creats the arrow buttons that are used to control the player's avatar
- (void) loadArrowButtons
{
    // Create the arrow buttons that are used to control the character
    UIImage *arrowImg = [UIImage imageNamed:@"arrow.png"];
    UIImage *arrowOnDwnImg = [UIImage imageNamed:@"arrow_onDown.png"];
    UIButton *arrowBtn = nil;
    float xPos = 0.0;
    float yPos = 0.0;
    
    // There is a left, right, and up arrow button
    for (int i = -1; i < 2; i++)
    {
        arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        arrowBtn.userInteractionEnabled = YES;
        
        // Change button positions based on if its left, right, or up
        switch (i) 
        {
            case LeftArrowBtn:
            {
                xPos = 350;
                yPos = 252;
                
                [arrowBtn addTarget:self action:@selector(leftArrowTouchDown:)
                   forControlEvents:UIControlEventTouchDown];
                [arrowBtn addTarget:self action:@selector(leftArrowTouchUpInside:)
                   forControlEvents:UIControlEventTouchUpInside];
                [arrowBtn addTarget:self action:@selector(leftArrowTouchUpOutside:)
                   forControlEvents:UIControlEventTouchUpOutside];
            }
                break;
                
            case UpArrowBtn:
            {
                xPos = 382;
                yPos = 220;
                
                [arrowBtn addTarget:self action:@selector(upArrowTouchDown:)
                   forControlEvents:UIControlEventTouchDown];
                [arrowBtn addTarget:self action:@selector(upArrowTouchUpInside:)
                   forControlEvents:UIControlEventTouchUpInside];
                [arrowBtn addTarget:self action:@selector(upArrowTouchUpOutside:)
                   forControlEvents:UIControlEventTouchUpOutside];
            }
                break;
                
            case RightArrowBtn:
            {
                xPos = 414;
                yPos = 252;
                
                [arrowBtn addTarget:self action:@selector(rightArrowTouchDown:)
                   forControlEvents:UIControlEventTouchDown];
                [arrowBtn addTarget:self action:@selector(rightArrowTouchUpInside:)
                   forControlEvents:UIControlEventTouchUpInside];
                [arrowBtn addTarget:self action:@selector(rightArrowTouchUpOutside:)
                   forControlEvents:UIControlEventTouchUpOutside];
            }
                break;
                
            default:
                break;
        }
        
        [arrowBtn setFrame:CGRectMake(xPos, yPos, 32.0, 32.0)];
        
        [arrowBtn setImage:arrowImg forState:UIControlStateNormal];
        [arrowBtn setImage:arrowOnDwnImg forState:UIControlStateHighlighted];
        [arrowBtn setTitle:[NSString stringWithFormat:@"Arrow %d", i] forState:UIControlStateNormal];
        arrowBtn.transform = CGAffineTransformMakeRotation( (  (i * 90) * M_PI ) / 180 );
        
        [displayView addSubview:arrowBtn];
    }
}

# pragma mark - Arrow Control methods

- (void) leftArrowTouchDown: (id)sender
{
    leftArrowIsHeld = YES;
    arrowThatIsHeld = LeftArrowBtn;
}

- (void) leftArrowTouchUpInside: (id)sender
{
    leftArrowIsHeld = NO;
}

- (void) leftArrowTouchUpOutside: (id)sender
{
    leftArrowIsHeld = NO;
}

- (void) upArrowTouchDown: (id)sender
{
    upArrowIsHeld = YES;
    arrowThatIsHeld = UpArrowBtn;
}

- (void) upArrowTouchUpInside: (id)sender
{
    upArrowIsHeld = NO;
}

- (void) upArrowTouchUpOutside: (id)sender
{
    upArrowIsHeld = NO;
}

- (void) rightArrowTouchDown: (id)sender
{
    rightArrowIsHeld = YES;
    arrowThatIsHeld = RightArrowBtn;
}

- (void) rightArrowTouchUpInside: (id)sender
{
    rightArrowIsHeld = NO;
}

- (void) rightArrowTouchUpOutside: (id)sender
{
    rightArrowIsHeld = NO;
}

@end
