//
//  Gameplay.h
//  emilymalison
//
//  Created by Emily Malison on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Gameplay : CCNode


-(void)timerExpired;
-(void)updateScore:(int)score;

@end
