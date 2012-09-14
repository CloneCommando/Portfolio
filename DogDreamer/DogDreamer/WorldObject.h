//
//  WorldObject.h
//  DogDreamer
//
//  Created by Thomas Colligan on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorldObject : NSObject
{
    CGFloat width;
    CGFloat height;
    CGFloat halfWidth;
    CGFloat halfHeight;
    
    CGFloat xPos;
    CGFloat yPos;
    
    CGFloat xVelocity;
    CGFloat yVelocity;
    CGFloat xVelocityMax;
    CGFloat yVelocityMax;
    
    UIImageView *currentAnimationCycle;
    UIView *displayView;
}

- (id) initWithWidth: (CGFloat) w height: (CGFloat) h xPos: (CGFloat) x yPos: (CGFloat) y xVel: (CGFloat) xV yVel: (CGFloat) yV;

- (void) setDisplayView: (UIView *) view;
- (BOOL) isCollidingWithWorldObject: (WorldObject *) otherObject;

- (void) setX: (CGFloat) newX;
- (void) setY: (CGFloat) newY;
- (void) setVelocityX: (CGFloat) newVelX;
- (void) setVelocityY: (CGFloat) newVelY;
- (void) setVelocityMaxX: (CGFloat) newMaxVelX;
- (void) setVelocityMaxY: (CGFloat) newMaxVelY;

- (CGFloat) getWidth;
- (CGFloat) getHeight;
- (CGFloat) getHalfWidth;
- (CGFloat) getHalfHeight;

- (CGFloat) getX;
- (CGFloat) getY;
- (CGFloat) getCenterX;
- (CGFloat) getCenterY;
- (CGFloat) getVelX;
- (CGFloat) getVelY;

@end
