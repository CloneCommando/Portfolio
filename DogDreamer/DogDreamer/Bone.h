//
//  Bone.h
//  DogDreamer
//
//  Created by Thomas Colligan on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorldObject.h"

@interface Bone : WorldObject
{
    
}

- (void) moveBone: (float)xDist yMove: (float) yDist;
- (void) destroy;

@end
