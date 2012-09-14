//
//  TrashCan.m
//  DogDreamer
//
//  Created by Thomas Colligan on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrashCan.h"

@implementation TrashCan

- (void) setDisplayView: (UIView *) view
{
    displayView = view;
    
    // Images that make up the garbage can
    didKnockDown = NO;
    currentAnimationCycle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GarbageCan_Up.png"]];
    
    [currentAnimationCycle setFrame:CGRectMake(xPos, yPos, width, height)];
    //currentAnimationCycle.center = CGPointMake(xPos + halfWidth, yPos + halfHeight);
    currentAnimationCycle.contentMode = UIViewContentModeScaleAspectFit;
    
    [displayView addSubview:currentAnimationCycle];
}

- (void) move: (float)xDist yMove: (float) yDist
{
    xPos += xDist;
    yPos += yDist;
    currentAnimationCycle.center = CGPointMake(currentAnimationCycle.center.x + xDist, currentAnimationCycle.center.y + yDist);
}

- (void) knockDown
{
    if (didKnockDown == NO)
    {
        didKnockDown = YES;
        [currentAnimationCycle setImage:[UIImage imageNamed:@"GarbageCan_Down.png"]];
    }
}

- (BOOL) isKnockedDown
{
    return didKnockDown;
}

- (void) destroy
{
    [currentAnimationCycle removeFromSuperview];
    currentAnimationCycle = nil;
    displayView = nil;
}

@end
