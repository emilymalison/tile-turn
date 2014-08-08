//
//  Gameplay.h
//  emilymalison
//
//  Created by Emily Malison on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Gameplay : CCNode <CCPhysicsCollisionDelegate>


-(void)timerExpired;
-(void)noPossibleMatches;
-(void)shufflingDone;

@property (nonatomic, assign) BOOL shuffling;

@end
