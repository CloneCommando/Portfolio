//
//  GameLevel.m
//  DogDreamer
//
//  Created by Thomas Colligan on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLevel.h"

#define kLeftX (0.0)
#define kRightX (480.0)

@implementation GameLevel
@synthesize characterDog;

- (id) init
{
    self = [super init];
    
    if (self)
    {
        NSLog(@"Initialized GameLevel");
        backgroundImageName = @"background.png";
        
        savedData = [SavedData sharedInstance];
        soundManager = [SoundManager sharedInstance];
        difficultyLvl = [savedData getDifficultyLevel];
        
        // FIX Bug with app starting for first time ever
        if (difficultyLvl == nil)
            difficultyLvl = @"Easy";
        
        parallaxSceneLength = 1800.0;
        parallaxLeftBounds = -parallaxSceneLength;
        parallaxRightBounds = 600;
        parallaxSpeedRatio = 0.3;
        
        [self reset];
        
        boneGenerationRangeY = 45;
        boneGenerationCeilingY = 175;
        boneGenerationMinSeperationX = 200;
        boneGenerationVariableRangeX = 100;
        
        trashCanGenerationMinSeperationX = 400;
        trashCanGenerationVariablRangeX = 100;
        trashCanFloor = 250;
        
        characterDog = [[Dog alloc] initWithWidth:64 height:64 xPos:100 yPos:230 xVel:0 yVel:0];
        [characterDog setVelocityMaxX:10.0];
        [characterDog setVelocityMaxY:10.0];
        
        boneObjectsArray = [NSMutableArray array];
        trashCanObjectsArray = [NSMutableArray array];
        
        // Determine the time limit for the game depending on the difficulty level
        if ([difficultyLvl isEqualToString:@"Hard"])
            mainGameTimeAmount = 30.0;
        else if ([difficultyLvl isEqualToString:@"Normal"])
            mainGameTimeAmount = 45.0;
        else
            mainGameTimeAmount = 60.0; // Easy Mode
    }
    
    return self;
}

- (void) reset
{
    boneGenerationDist = 225.0;
    trashCanGenerationDist = 350;
    disTraveledRight = trashCanGenerationDist+1;
    lastBoneGenAtX = 0.0;
    numOfBonesCollected = 0;
    lastTrashCanGenAtX = 0.0;
    
    if (boneObjectsArray != nil)
    {
        // Clear out all the old bone objects
        Bone *bone = nil;
        for (int index = 0; index < [boneObjectsArray count]; index++)
        {
            [bone destroy];
            [boneObjectsArray removeObjectAtIndex:index];
        }
        boneObjectsArray = nil;
    }
    
    if (trashCanObjectsArray != nil)
    {
        // Clear out all the old bone objects
        TrashCan *can = nil;
        for (int index = 0; index < [trashCanObjectsArray count]; index++)
        {
            [can destroy];
            [trashCanObjectsArray removeObjectAtIndex:index];
        }
       trashCanObjectsArray = nil;
    }
}

- (void) setDisplayView: (UIView *) view
{
    NSLog(@"Set the DisplayView for GameLevel");
    displayView = view;
    
    background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backgroundImageName]];
    background.center = CGPointMake(kLeftX, background.center.y - 160);
    bgFloor = background.center.y;
    
    [displayView addSubview:background];
    [self loadParallaxScenery];
    [characterDog setDisplayView:displayView];
}

// Loads the extra scenery that scrolls in parallax
- (void) loadParallaxScenery
{
    NSLog(@"Loaded Parallax Scenery");
    UIImageView *scenery = nil;
    parallaxScenery = [NSMutableArray array];
    
    // Cloud Picture
    scenery = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud.png"]];
    scenery.center = CGPointMake( (1 * parallaxSceneLength) / 3, 100);
    [parallaxScenery addObject:scenery];
    
    // The moon picture
    scenery = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moon_up.png"]];
    scenery.center = CGPointMake( (2 * parallaxSceneLength) / 3, 100);
    [parallaxScenery addObject:scenery];
    
    // Cloud2 Picture
    scenery = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud2.png"]];
    scenery.center = CGPointMake( (3 * parallaxSceneLength) / 3, 100);
    [parallaxScenery addObject:scenery];
    
    for (UIImageView *img in parallaxScenery)
    {
        [displayView addSubview:img];
    }
}

- (void) generateBones
{
    // FIXES BUG that spawns bones with incorrect y pos while dog jumps
    if ([characterDog isJumping])
        return;
    
    // Generate a bone after a certain set distance has been traveled
    if (disTraveledRight > (lastBoneGenAtX + boneGenerationDist) && (disTraveledRight > lastBoneGenAtX))
    {
        NSLog(@"Generated a Bone");
        int yPos = (arc4random() % boneGenerationRangeY) + boneGenerationCeilingY;
        lastBoneGenAtX = lastBoneGenAtX + boneGenerationDist;
        
        Bone *myBone = [[Bone alloc] initWithWidth:64 height:32 xPos:lastBoneGenAtX yPos:yPos xVel:0 yVel:0];
        [myBone setDisplayView:displayView];
        [boneObjectsArray addObject:myBone];
        
        // Randomize the bone generation x distance a little
        boneGenerationDist = (arc4random() % boneGenerationVariableRangeX) + boneGenerationMinSeperationX;
    }
}

- (void) generateTrashCans
{
    // FIXES BUG that spawns garbage cans with incorrect y pos while dog jumps
    if ([characterDog isJumping])
        return;
    
    // Generate a trash can after a certain set distance has been traveled
    if (disTraveledRight > (lastTrashCanGenAtX + trashCanGenerationDist) && (disTraveledRight > lastTrashCanGenAtX))
    {
        NSLog(@"Generated a Trash Can");
        lastTrashCanGenAtX = lastTrashCanGenAtX + trashCanGenerationDist;
        
        TrashCan *myTrashCan = [[TrashCan alloc] initWithWidth:48 height:48 xPos:lastTrashCanGenAtX yPos:trashCanFloor xVel:0 yVel:0];
        
        [myTrashCan setDisplayView:displayView];
        [trashCanObjectsArray addObject:myTrashCan];
        
        // Randomize the trash can generation x distance a little
        trashCanGenerationDist = (arc4random() % trashCanGenerationVariablRangeX) + trashCanGenerationMinSeperationX;
    }
}

- (void) update
{
    // Movement of the world is based on the Dog's speed
    [characterDog update];
    worldVelX = [characterDog getVelX];
    worldVelY = [characterDog getVelY];
    
    disTraveledRight += worldVelX;
    
    // Scroll the background and sawp its position to make it look like it scrolls endlessly
    newX = background.center.x - worldVelX;
    newY = background.center.y + worldVelY;
    
    if (newX < kLeftX)
        newX = kRightX;
    else if(newX > kRightX)
        newX = kLeftX;
    
    // Make sure the background doesnt scroll over the floor
    if (newY < bgFloor)
    {
        newY = bgFloor;
        [characterDog setVelocityY:0.0];
    }
    
    background.center = CGPointMake(newX, newY);
    
    // Move the parallax items also
    for (UIImageView *img in parallaxScenery)
    {
        newX = img.center.x - (worldVelX * parallaxSpeedRatio );
        
        if(newX < parallaxLeftBounds)
            newX = parallaxRightBounds;
        
        img.center = CGPointMake(newX, img.center.y);
    }
    
    // Collision detection and movement with bones
    Bone *bone = nil;
    for (int index = 0; index < [boneObjectsArray count]; index++)
    {
        // Move the bones with the level
        bone = [boneObjectsArray objectAtIndex:index];
        [bone moveBone:-worldVelX yMove:worldVelY];
        
        // Dog collided with a bone
        if ([characterDog isCollidingWithWorldObject:bone])
        {
            NSLog(@"Bone Collected!");
            [soundManager playSound:CollectedBone];
            
            [bone destroy];
            [boneObjectsArray removeObjectAtIndex:index];
            numOfBonesCollected++;
        }
    }
    
    // Collision detection and movement with trash cans
    TrashCan *trashCan = nil;
    for (int index = 0; index < [trashCanObjectsArray count]; index++)
    {
        // Move the cans with the level
        trashCan = [trashCanObjectsArray objectAtIndex:index];
        [trashCan move:-worldVelX yMove:worldVelY];
        
        // Dog collided with a Trash Can
        if ([trashCan isKnockedDown] == NO && [characterDog isCollidingWithWorldObject:trashCan])
        {
            NSLog(@"Collided with Trash Can");
            [soundManager playSound:HitGarbageCan];
            
            [trashCan knockDown];
            [characterDog slowDown];
            
            worldVelX = [characterDog getVelX];
            worldVelY = [characterDog getVelY];
            
            //[trashCan destroy];
            //[trashCanObjectsArray removeObjectAtIndex:index];
        }
    }
    
    // Generate any bones or trash cans if possible
    [self generateBones];
    [self generateTrashCans];
}

- (Dog *) getCharacterDog
{
    return characterDog;
}

- (int) getNumOfBonesCollected
{
    return numOfBonesCollected;
}

- (float) getMainGameTimeAmount
{
    return mainGameTimeAmount;
}

- (NSString *) getDifficultyLvl
{
    return difficultyLvl;
}

- (void) saveGameResults
{
    // Find out what the old high score was at this difficulty level
    int oldScore = [savedData getHighScore:difficultyLvl];
    
    // If our new score is better, save it!
    if (numOfBonesCollected > oldScore)
        [savedData saveHighScore:numOfBonesCollected difficultyLevel:difficultyLvl];
}

@end
