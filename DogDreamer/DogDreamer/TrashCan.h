//
//  TrashCan.h
//  DogDreamer
//
//  Created by Thomas Colligan on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorldObject.h"

@interface TrashCan : WorldObject
{
    BOOL didKnockDown;
}

- (void) move: (float)xDist yMove: (float) yDist;
- (void) knockDown;
- (void) destroy;
- (BOOL) isKnockedDown;

@end
