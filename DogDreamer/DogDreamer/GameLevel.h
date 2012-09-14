//
//  GameLevel.h
//  DogDreamer
//
//  Created by Thomas Colligan on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dog.h"
#import "Bone.h"
#import "SavedData.h"
#import "SoundManager.h"
#import "TrashCan.h"

@interface GameLevel : NSObject
{
    UIImageView *background;
    UIView *displayView;
    NSString *difficultyLvl;
    
    SavedData *savedData;
    SoundManager *soundManager;
    
    NSString *backgroundImageName;
    float mainGameTimeAmount;
    float bgFloor;
    float newX;
    float newY;
    
    NSMutableArray *parallaxScenery;
    float parallaxSpeedRatio;
    float parallaxSceneLength;
    float parallaxLeftBounds;
    float parallaxRightBounds;
    
    NSMutableArray *boneObjectsArray;
    float boneGenerationDist;
    float disTraveledRight;
    float lastBoneGenAtX;
    
    NSMutableArray *trashCanObjectsArray;
    float trashCanGenerationDist;
    float lastTrashCanGenAtX;
    
    float worldVelX;
    float worldVelY;
    int numOfBonesCollected;
    
    int boneGenerationRangeY;
    int boneGenerationCeilingY;
    
    int boneGenerationMinSeperationX;
    int boneGenerationVariableRangeX;
    
    int trashCanGenerationMinSeperationX;
    int trashCanGenerationVariablRangeX;
    float trashCanFloor;
}

@property (nonatomic, strong) Dog *characterDog;

- (void) setDisplayView: (UIView *) view;
- (void) loadParallaxScenery;
- (void) generateBones;
- (void) generateTrashCans;
- (void) reset;
- (void) update;
- (Dog *) getCharacterDog;
- (int) getNumOfBonesCollected;
- (float) getMainGameTimeAmount;
- (NSString *) getDifficultyLvl;
- (void) saveGameResults;

@end
