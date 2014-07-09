//
//  Gameplay.m
//  emilymalison
//
//  Created by Emily Malison on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Grid.h"

@implementation Gameplay{
    Grid *_grid;
    int timeRemaining;
    CCLabelTTF *_timer;

}

-(void)onEnter{
    [super onEnter];
    
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerExpired) userInfo:nil repeats:NO];
    [self schedule:@selector(second) interval:1.f];
    timeRemaining=60;

}

-(void)second{
    _timer.string= [NSString stringWithFormat:@"%d", timeRemaining];
    timeRemaining-=1;
}

-(void)timerExpired{
    
}

@end
