//
//  Dog.m
//  DogDreamer
//
//  Created by Thomas Colligan on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Dog.h"

@implementation Dog

- (id) initWithWidth: (CGFloat) w height: (CGFloat) h xPos: (CGFloat) x yPos: (CGFloat) y xVel: (CGFloat) xV yVel: (CGFloat) yV
{
    self = [super init];
    
    if (self)
    {
        xPos = x;
        yPos = y;
        width = w;
        height = h;
        
        halfWidth = width/2;
        halfHeight = height/2;
        xVelocity = xV;
        yVelocity = yV;
        
        isSpeedingUp = NO;
        speedUpRatio = 1.01;
        slowDownRatio = 0.97;
        slowDownAirRatio = 0.988;
        gravity = 0.042;
        minRunSpeed = 3.0;
        maxJumpSpeed = 2.8;
        
        [self loadAnimations];
        soundManager = [SoundManager sharedInstance];
    }
    
    return self;
}

- (void) setDisplayView: (UIView *) view
{
    displayView = view;
    [displayView addSubview:stillDogAnimation];
    [displayView addSubview:runningRightDogAnimation];
    [displayView addSubview:runningLeftDogAnimation];
    [displayView addSubview:jumpRightAnimation];
    [displayView addSubview:jumpLeftAnimation];
    
    [currentAnimationCycle startAnimating];
    [displayView setNeedsDisplay];
}

- (void) loadAnimations
{

    NSMutableArray *imageArray = nil;
    UIImage *spriteSheet = [UIImage imageNamed:@"red_dog.png"];
    
    // Still Dog Animation
    imageArray = [self getSpriteSheetAnimation:spriteSheet width:width height:height row:5 col:2 amount:6];
    
     stillDogAnimation = [[UIImageView alloc] initWithFrame: CGRectMake(xPos, yPos, width, height)];
	 stillDogAnimation.animationImages = imageArray;
	 stillDogAnimation.animationDuration = 5.0;
    
    // Running Right Animation
    imageArray = [self getSpriteSheetAnimation:spriteSheet width:width height:height row:2 col:3 amount:5];
    
    runningRightDogAnimation = [[UIImageView alloc] initWithFrame: CGRectMake(xPos, yPos, width, height)];
    runningRightDogAnimation.animationImages = imageArray;
    runningRightDogAnimation.animationDuration = 0.5;
    
    // Running Left Animation
    runningLeftDogAnimation = [[UIImageView alloc] initWithFrame: CGRectMake(xPos, yPos, width, height)];
    runningLeftDogAnimation.animationImages = imageArray;
    runningLeftDogAnimation.animationDuration = runningRightDogAnimation.animationDuration;
    runningLeftDogAnimation.transform = CGAffineTransformMake(-1, 0, 0, 1, 0, 0);
    
    // Jump Right Animation
    imageArray = [self getSpriteSheetAnimation:spriteSheet width:width height:height row:1 col:4 amount:1];
    
    jumpRightAnimation = [[UIImageView alloc] initWithFrame: CGRectMake(xPos, yPos, width, height)];
    jumpRightAnimation.animationImages = imageArray;
    jumpRightAnimation.animationDuration = 2.0;
    
    // Jump Left Animation
    jumpLeftAnimation = [[UIImageView alloc] initWithFrame: CGRectMake(xPos, yPos, width, height)];
    jumpLeftAnimation.animationImages = imageArray;
    jumpLeftAnimation.animationDuration = jumpRightAnimation.animationDuration;
    jumpLeftAnimation.transform = CGAffineTransformMake(-1, 0, 0, 1, 0, 0);
    
    // Add all the animations to an array so it is easier to iterate through them
    imageViewsArray = [NSMutableArray arrayWithObjects:stillDogAnimation, runningRightDogAnimation, runningLeftDogAnimation, jumpRightAnimation, jumpLeftAnimation, nil];
    
    // Set the inital animation to be the dog standing still
    currentAnimationCycle = stillDogAnimation;
    currentAnimationType = SitStill;
}

- (void) changeAnimation: (Animation) newAnimation
{
    // If we are already using this animation, quick exit
    if(newAnimation == currentAnimationType)
        return;
    
    [currentAnimationCycle stopAnimating];
    
    switch (newAnimation) 
    {
        case SitStill:
        {
            // Only do this animation when we are not moving
            if (xVelocity != 0.0 || yVelocity != 0.0)
            {
                [currentAnimationCycle startAnimating];
                isSpeedingUp = NO;
                return;
            }
            currentAnimationCycle = stillDogAnimation;
            currentAnimationType = SitStill;
            isSpeedingUp = NO;
        }
            break;
            
        case RunRight:
        {
            // Dont play the run right animation if we are jumping
            if (yVelocity != 0.0)
            {
                [currentAnimationCycle startAnimating];
                return;
            }
            
            currentAnimationCycle = runningRightDogAnimation;
            currentAnimationType = RunRight;
            
            isSpeedingUp = YES;
            xVelocity = minRunSpeed;
        }
            break;
            
        case RunLeft:
        {
            // Dont play the run right animation if we are jumping
            if (yVelocity != 0.0)
            {
                [currentAnimationCycle startAnimating];
                return;
            }
            
            currentAnimationCycle = runningLeftDogAnimation;
            currentAnimationType = RunLeft;
            
            isSpeedingUp = YES;
            xVelocity = -minRunSpeed;
        }
            break;
            
        case Jump:
        {
            if(xVelocity < 0)
                currentAnimationCycle = jumpLeftAnimation;
            else
                currentAnimationCycle = jumpRightAnimation;     
            
            [soundManager playSound:DogJump];
            currentAnimationType = Jump;
            
            isSpeedingUp = NO;
            yVelocity = maxJumpSpeed;
        }
            break;
            
        default:
            break;
    }
    
    // Make sure animation we are not using are hidden and not animating
    for (UIImageView *animation in imageViewsArray)
    {
        if (animation != currentAnimationCycle)
        {
            [animation stopAnimating];
            [animation setHidden:YES];
        }
    }
    
    [currentAnimationCycle startAnimating];
    [currentAnimationCycle setHidden:NO];
    [displayView setNeedsDisplay];
}

- (CGFloat) getSpeed
{
    return ((xVelocity * xVelocity) + (yVelocity * yVelocity));
}

- (void) update
{
    if (xVelocity != 0.0)
    {
        if (isSpeedingUp == YES && yVelocity == 0.0)
            xVelocity *= speedUpRatio;
        else if (isSpeedingUp == NO && yVelocity == 0.0)
             xVelocity *= slowDownRatio;
        else if (isSpeedingUp == NO && yVelocity != 0.0)
            xVelocity *= slowDownAirRatio;
        
        // Cap the velocity max
        if (xVelocity > 0 && xVelocity > xVelocityMax)
            xVelocity = xVelocityMax;
        else if (xVelocity < 0 && xVelocity < -xVelocityMax)
            xVelocity = -xVelocityMax;
        
        // Floor the Velocity to stop running
        if ((xVelocity > 0 && xVelocity < 1) || (xVelocity < 0 && xVelocity > -1))
        {
            xVelocity = 0.0;
        }
        
    }
    
    if (yVelocity != 0.0)
    {
        yVelocity -= gravity;
    }
    
    //NSLog(@"X: %1.2f Y: %1.2f",currentAnimationCycle.center.x, currentAnimationCycle.center.y);
}

// A helper method that pieces out the parts of a sprite sheet
- (NSMutableArray *) getSpriteSheetAnimation: (UIImage *) spriteSheet width: (CGFloat) w height: (CGFloat) h row: (int) r col: (int) c amount: (int) amt
{
    //UIImage *img = nil;
    CGImageRef cgiImgRef = nil;
    NSMutableArray *imageArray = [NSMutableArray array];
    
    CGFloat startingX = 0.0;
    CGFloat startingY = h * r;
    
    for (int i = 0; i < amt; i++)
    {
        // Move along the sprite sheet horizontally to pick out the images we need
        startingX = w * ( c + i);
        cgiImgRef = CGImageCreateWithImageInRect(spriteSheet.CGImage, CGRectMake(startingX, startingY, w, h));
        
        [imageArray addObject:[UIImage imageWithCGImage:cgiImgRef]];
    }
    
    return imageArray;
}

- (void) slowDown
{
    xVelocity /= 2.0;
    isSpeedingUp = NO;
}

- (BOOL) isJumping
{
    return (currentAnimationCycle == jumpLeftAnimation || currentAnimationCycle ==          jumpRightAnimation);
}

@end
