//
//  Gameplay.h
//  emilymalison
//
//  Created by Emily Malison on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Gameplay : CCNode <CCPhysicsCollisionDelegate>{
    SystemSoundID timerSound;
}


-(void)timerExpired;
-(void)noPossibleMatches;
-(void)shufflingDone;
-(void)gameOver;

@property (nonatomic, assign) BOOL shuffling;
@property (nonatomic, assign) BOOL sound;

@end
