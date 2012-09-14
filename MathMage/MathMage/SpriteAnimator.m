//
//  SpriteAnimator.m
//  MathMage
//
//  Created by Thomas Colligan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpriteAnimator.h"

static SpriteAnimator *sharedInstance = nil;

@implementation SpriteAnimator

+ (SpriteAnimator *)sharedInstance
{
    if(!sharedInstance)
    {
        // Create the singleton
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id) init
{
    if (sharedInstance)
    {
        return sharedInstance;
    }
    
    self = [super init];
    
    if (self)
    {
        [self loadSpritesToAnimate];
    }
    
    return self;
}

- (void) loadSpritesToAnimate
{
	NSArray * imageArray = nil;
    
    // The mage that represents the player
    imageArray  = [[NSArray alloc] initWithObjects:
                             [UIImage imageNamed:@"mage_1.png"],
                             [UIImage imageNamed:@"mage_2.png"],
                             nil];
    
	mageNormalCycle = [[UIImageView alloc] initWithFrame:
                             CGRectMake(45, 110, 90, 135)];
	mageNormalCycle.animationImages = imageArray;
	mageNormalCycle.animationDuration = 1.1;
	mageNormalCycle.contentMode = UIViewContentModeScaleAspectFit;
    
    // The mage that represents the enemy
    imageArray  = [[NSArray alloc] initWithObjects:
                   [UIImage imageNamed:@"enemy_1.png"],
                   [UIImage imageNamed:@"enemy_2.png"],
                   nil];
    
	enemyMageNormalCycle = [[UIImageView alloc] initWithFrame:
                       CGRectMake(200, 135, 90, 135)];
	enemyMageNormalCycle.animationImages = imageArray;
	enemyMageNormalCycle.animationDuration = 1.1;
	enemyMageNormalCycle.contentMode = UIViewContentModeScaleAspectFit;
    
    // The User's health bar
    orgUserHealthBarWidth = 35;
    orgUserHealthBarHeight = 120;
    
    userHealthBar = [[UIImageView alloc] initWithFrame: CGRectMake(25, 140, orgUserHealthBarWidth, orgUserHealthBarHeight)];
    [userHealthBar setImage:[UIImage imageNamed:@"health_bar.png"]];
    userHealthBar.contentMode = UIViewContentModeScaleAspectFit;
    
    // The User's Lightning Attack
    imageArray  = [[NSArray alloc] initWithObjects:
                   [UIImage imageNamed:@"lightning_1.png"],
                   [UIImage imageNamed:@"lightning_2.png"],
                   [UIImage imageNamed:@"lightning_3.png"],
                   [UIImage imageNamed:@"lightning_4.png"],
                   [UIImage imageNamed:@"lightning_5.png"],
                   [UIImage imageNamed:@"lightning_6.png"],
                   nil];
    
	userLightningAttack = [[UIImageView alloc] initWithFrame:
                            CGRectMake(115, 150, 140, 21)];
	userLightningAttack.animationImages = imageArray;
	userLightningAttack.animationDuration = 2.0;
    userLightningAttack.animationRepeatCount = 1;
	userLightningAttack.contentMode = UIViewContentModeScaleAspectFit;
    
    // The enemy's lightning attack
    imageArray  = [[NSArray alloc] initWithObjects:
                   [UIImage imageNamed:@"enemy_lightning_1.png"],
                   [UIImage imageNamed:@"enemy_lightning_2.png"],
                   [UIImage imageNamed:@"enemy_lightning_3.png"],
                   [UIImage imageNamed:@"enemy_lightning_4.png"],
                   [UIImage imageNamed:@"enemy_lightning_5.png"],
                   [UIImage imageNamed:@"enemy_lightning_6.png"],
                   nil];
    
	enemyLightningAttack = [[UIImageView alloc] initWithFrame:
                           CGRectMake(90, 160, 140, 21)];
	enemyLightningAttack.animationImages = imageArray;
	enemyLightningAttack.animationDuration = 2.0;
    enemyLightningAttack.animationRepeatCount = 1;
	enemyLightningAttack.contentMode = UIViewContentModeScaleAspectFit;
    
    // User wand explode animation
    imageArray  = [[NSArray alloc] initWithObjects:
                   [UIImage imageNamed:@"explosion_1.png"],
                   [UIImage imageNamed:@"explosion_2.png"],
                   [UIImage imageNamed:@"explosion_3.png"],
                   [UIImage imageNamed:@"explosion_4.png"],
                   nil];
    
	userWandExplode = [[UIImageView alloc] initWithFrame:
                           CGRectMake(90, 125, 70, 70)];
	userWandExplode.animationImages = imageArray;
	userWandExplode.animationDuration = 2.5;
    userWandExplode.animationRepeatCount = 1;
	userWandExplode.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (UIImageView *) getMageNormalCycle
{
    return mageNormalCycle;
}

- (UIImageView *) getEnemyNormalCycle
{
    return enemyMageNormalCycle;
}

- (UIImageView *) getUserHealthBar
{
    return userHealthBar;
}

- (UIImageView *) getUserLightningAttack
{
    return userLightningAttack;
}

- (UIImageView *) getEnemyLightningAttack
{
    return enemyLightningAttack;
}

- (UIImageView *) getUserWandExplode
{
    return userWandExplode;
}

@end
