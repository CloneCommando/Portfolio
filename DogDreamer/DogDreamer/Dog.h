//
//  Dog.h
//  DogDreamer
//
//  Created by Thomas Colligan on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorldObject.h"
#import "SoundManager.h"

typedef enum {
    SitStill = 0,
    RunRight = 1,
    RunLeft = 2,
    Jump = 3
} Animation;

@interface Dog : WorldObject
{
    Animation currentAnimationType;
    NSMutableArray *imageViewsArray;
    
    UIImageView *stillDogAnimation;
    UIImageView *runningRightDogAnimation;
    UIImageView *runningLeftDogAnimation;
    UIImageView *jumpRightAnimation;
    UIImageView *jumpLeftAnimation;
    
    BOOL isSpeedingUp;
    float speedUpRatio;
    float slowDownRatio;
    float slowDownAirRatio;
    float gravity;
    
    CGFloat minRunSpeed;
    CGFloat maxJumpSpeed;
    SoundManager *soundManager;
}

- (id) initWithWidth: (CGFloat) w height: (CGFloat) h xPos: (CGFloat) x yPos: (CGFloat) y xVel: (CGFloat) xV yVel: (CGFloat) yV;

- (void) loadAnimations;
- (void) changeAnimation: (Animation) newAnimation;
- (NSMutableArray *) getSpriteSheetAnimation: (UIImage *) spriteSheet width: (CGFloat) w height: (CGFloat) h row: (int) r col: (int) c amount: (int) amt;

- (CGFloat) getSpeed;
- (void) update;
- (void) slowDown;
- (BOOL) isJumping;

@end
