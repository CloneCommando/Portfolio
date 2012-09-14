//
//  Controls.h
//  DogDreamer
//
//  Created by Thomas Colligan on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Controls : NSObject
{
    int arrowThatIsHeld;
    BOOL leftArrowIsHeld;
    BOOL upArrowIsHeld;
    BOOL rightArrowIsHeld;
    UIView *displayView;
}

- (void) loadArrowButtons;
- (void) setDisplayView: (UIView *) view;

- (int) getArrowThatIsHeld;
- (BOOL) isLeftArrowHeld;
- (BOOL) isRightArrowHeld;
- (BOOL) isUpArrowHeld;

- (void) leftArrowTouchDown: (id)sender;
- (void) leftArrowTouchUpInside: (id)sender;
- (void) leftArrowTouchUpOutside: (id)sender;

- (void) upArrowTouchDown: (id)sender;
- (void) upArrowTouchUpInside: (id)sender;
- (void) upArrowTouchUpOutside: (id)sender;

- (void) rightArrowTouchDown: (id)sender;
- (void) rightArrowTouchUpInside: (id)sender;
- (void) rightArrowTouchUpOutside: (id)sender;

@end
