//
//  Bone.m
//  DogDreamer
//
//  Created by Thomas Colligan on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Bone.h"

@implementation Bone

- (void) setDisplayView: (UIView *) view
{
    displayView = view;
    
    currentAnimationCycle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_bone.png"]];
    
    [currentAnimationCycle setFrame:CGRectMake(xPos, yPos, width, height)];
    [displayView addSubview:currentAnimationCycle];
}

- (void) moveBone: (float)xDist yMove: (float) yDist
{
    xPos += xDist;
    yPos += yDist;
    //[currentAnimationCycle setFrame:CGRectMake(xPos, yPos, width, height)];
    currentAnimationCycle.center = CGPointMake(currentAnimationCycle.center.x + xDist, currentAnimationCycle.center.y + yDist);
}

- (void) destroy
{
    [currentAnimationCycle removeFromSuperview];
    currentAnimationCycle = nil;
    displayView = nil;
}

@end
