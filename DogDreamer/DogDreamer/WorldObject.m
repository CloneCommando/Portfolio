//
//  WorldObject.m
//  DogDreamer
//
//  Created by Thomas Colligan on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorldObject.h"

@implementation WorldObject

- (id) init
{
    self = [super init];
    
    if (self)
    {
        xPos = 0.0;
        yPos = 0.0;
        width = 1.0;
        height = 1.0;
        
        halfWidth = width / 2.0;
        halfHeight = height / 2.0;
        xVelocity = 0.0;
        yVelocity = 0.0;
    }
    
    return self;
}

- (id) initWithWidth: (CGFloat) w height: (CGFloat) h xPos: (CGFloat) x yPos: (CGFloat) y xVel: (CGFloat) xV yVel: (CGFloat) yV
{
    self = [super init];
    
    if (self)
    {
        xPos = x;
        yPos = y;
        width = w;
        height = h;
        
        halfWidth = width / 2.0;
        halfHeight = height / 2.0;
        xVelocity = xV;
        yVelocity = yV;
    }
    
    return self;
}

- (void) setDisplayView: (UIView *) view
{
    displayView = view;
}

// Basic AABB Collision detection
- (BOOL) isCollidingWithWorldObject: (WorldObject *) otherObject
{
    /*NSLog(@"Dog: centerX: %1.2f centerY: %1.2f halfWidth: %1.2f halfHeight: %1.2f", currentAnimationCycle.center.x, currentAnimationCycle.center.y, halfWidth, halfHeight);
    NSLog(@"Other: centerX: %1.2f centerY: %1.2f halfWidth: %1.2f halfHeight: %1.2f", [otherObject getCenterX], [otherObject getCenterY], [otherObject getHalfWidth], [otherObject getHalfHeight]);
    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");*/
    
    if (fabsf(currentAnimationCycle.center.x - [otherObject getCenterX]) > (halfWidth + [otherObject getHalfWidth]))
        return NO;
    if (fabsf(currentAnimationCycle.center.y - [otherObject getCenterY]) > (halfHeight+ [otherObject getHalfHeight]))
        return NO;
    
    return YES;
}

- (void) setX: (CGFloat) newX
{
    xPos = newX;
}

- (void) setY: (CGFloat) newY
{
    yPos = newY;
}

- (void) setVelocityX: (CGFloat) newVelX
{
    xVelocity = newVelX;
}

- (void) setVelocityY: (CGFloat) newVelY
{
    yVelocity = newVelY;
}

- (void) setVelocityMaxX: (CGFloat) newMaxVelX
{
    xVelocityMax = newMaxVelX;
}

- (void) setVelocityMaxY: (CGFloat) newMaxVelY
{
    yVelocityMax = newMaxVelY;
}

- (CGFloat) getWidth
{
    return width;
}

- (CGFloat) getHeight
{
    return height;
}

- (CGFloat) getHalfWidth
{
    return halfWidth;
}

- (CGFloat) getHalfHeight
{
    return halfHeight;
}

- (CGFloat) getX
{
    return xPos;
}

- (CGFloat) getY
{
    return yPos;
}

- (CGFloat) getCenterX
{
    return currentAnimationCycle.center.x; 
}

- (CGFloat) getCenterY
{
    return currentAnimationCycle.center.y; 
}

- (CGFloat) getVelX
{
    return xVelocity;
}

- (CGFloat) getVelY
{
    return yVelocity;
}

@end
