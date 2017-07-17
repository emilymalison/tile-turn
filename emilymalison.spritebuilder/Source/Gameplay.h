//
//  Gameplay.h
//  emilymalison
//
//  Created by Emily Malison on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Gameplay : CCNode <CCPhysicsCollisionDelegate>{  //screen than contains all gameplay objects (grid, timer, buttons)
    SystemSoundID timerSound;
}


-(void)timerExpired; //when time is up, disables user interaction
-(void)noPossibleMatches; //when there are no more possible matches, redraw the grid of tiles
-(void)shufflingDone; //allows gameplay to begin again when the grid has been reset
-(void)gameOver; //makes Game Over screen appear
-(void)combo; //when user makes more than one match at a time, they earn double points

@property (nonatomic, assign) BOOL shuffling; //whether the board is being shuffled (redrawn) or not - when there are no more possible matches
@property (nonatomic, assign) BOOL sound; //whether sound is on or off

@end
