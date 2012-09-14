//
//  SpriteAnimator.h
//  MathMage
//
//  Created by Thomas Colligan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface SpriteAnimator : NSObject
{
    UIImageView *mageNormalCycle;
    UIImageView *enemyMageNormalCycle;
    UIImageView *userHealthBar;
    UIImageView *userLightningAttack;
    UIImageView *enemyLightningAttack;
    UIImageView *userWandExplode;
    int orgUserHealthBarWidth;
    int orgUserHealthBarHeight;
}

+ (SpriteAnimator *)sharedInstance;

- (void) loadSpritesToAnimate;
- (UIImageView *) getMageNormalCycle;
- (UIImageView *) getEnemyNormalCycle;
- (UIImageView *) getUserHealthBar;
- (UIImageView *) getUserLightningAttack;
- (UIImageView *) getEnemyLightningAttack;
- (UIImageView *) getUserWandExplode;

@end
